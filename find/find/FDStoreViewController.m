//
//  FDStoreViewController.m
//  find
//
//  Created by zhangbin on 11/30/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDStoreViewController.h"
#import "FDStuffCell.h"
#import "AlixPayOrder.h"
#import "AlixLibService.h"
#import "PartnerConfig.h"
#import "DataSigner.h"
#import "FDPrice.h"
#import "FDStuff.h"
#import "FDWebViewController.h"

#define kSectionIndexOfVirtualStuff 0
#define kSectionIndexOfRealStuff 1

@interface FDStoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableDictionary *stuffs;

@end

@implementation FDStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
#ifdef IGNORE_RULES_OF_APP_STORE
	NSString *stuffs = NSLocalizedString(@"Stuffs", nil);
	NSString *records = NSLocalizedString(@"Records", nil);
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[stuffs, records]];
	segmentedControl.tintColor = [UIColor whiteColor];
	segmentedControl.selectedSegmentIndex = 0;
	self.navigationItem.titleView = segmentedControl;
#endif
	
	_stuffs = [NSMutableDictionary dictionary];
	
	[self fetchStuffs:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self fetchStuffs:NO];
}

- (void)fetchStuffs:(BOOL)bVirtual
{
	[[FDAFHTTPClient shared] stuffsList:bVirtual withCompletionBlock:^(BOOL success, NSString *message, NSArray *stuffsData) {
		if (success) {
			if (bVirtual) {
				_stuffs[@(kSectionIndexOfVirtualStuff)] = [FDStuff createMutableWithData:stuffsData];
			} else {
				_stuffs[@(kSectionIndexOfRealStuff)] = [FDStuff createMutableWithData:stuffsData];
			}
			[_tableView reloadData];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	FDStuff *stuff = _stuffs[@(indexPath.section)][indexPath.row];
	FDWebViewController *webViewController = [[FDWebViewController alloc] init];
	webViewController.path = stuff.detailsURLString;
	[self.navigationController pushViewController:webViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _stuffs.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_stuffs[@(section)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FDStuffCell *cell = [tableView dequeueReusableCellWithIdentifier:kFDStuffCellIdentifier];
	if (!cell) {
		cell = [[FDStuffCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFDStuffCellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
		cell.accessoryType = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? UITableViewCellAccessoryDetailButton :UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.imageView.image = [UIImage imageNamed:@"Placeholder"];
	FDStuff *stuff = _stuffs[@(indexPath.section)][indexPath.row];
	cell.stuff = stuff;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	FDStuff *stuff = _stuffs[@(indexPath.section)][indexPath.row];
	/*
	 *生成订单信息及签名
	 *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
	 */
	if (!stuff.bReal.boolValue) {
	    NSString* orderInfo = [self getOrderInfo:stuff];
		NSString* signedStr = [self doRsa:orderInfo];
		NSLog(@"%@",signedStr);
		NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderInfo, signedStr, @"RSA"];
		[AlixLibService payOrder:orderString AndScheme:APP_SCHEME seletor:nil target:self];
	} else {
		[[FDAFHTTPClient shared] exchangeRealStuff:stuff.ID withCompletionBlock:^(BOOL success, NSString *message) {
			;
		}];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Alipay

-(NSString*)getOrderInfo:(FDStuff *)stuff
{
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    order.tradeNO = [NSString generateAlipayTradeNOWithStuffID:stuff.ID];//订单ID（由商家自行制定）
	order.productName = stuff.name;
	order.productDescription = stuff.describe;
	order.amount = [NSString stringWithFormat:@"%.2f", stuff.price.RMB.floatValue];
	order.notifyURL =  @"http://121.199.14.43/pay/alipay/notfiy";//回调URL//TODO: should use base url
	return [order description];
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}


@end
