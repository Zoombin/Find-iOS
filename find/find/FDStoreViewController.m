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

@interface FDStoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;

@end

@implementation FDStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
	NSString *virtual = NSLocalizedString(@"Virtual", nil);
	NSString *stuff = NSLocalizedString(@"Stuff", nil);
	NSString *records = NSLocalizedString(@"Records", nil);
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[virtual, stuff, records]];
	segmentedControl.tintColor = [UIColor whiteColor];
	segmentedControl.selectedSegmentIndex = 0;
	self.navigationItem.titleView = segmentedControl;
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

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
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"StoreCell";
	FDStuffCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[FDStuffCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.textLabel.text = @"0.01";
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	NSNumber *height = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kHeightOfCell];
//	if (height) {
//		return height.floatValue;
//	}
	return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*
	 *生成订单信息及签名
	 *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
	 */
    
    NSString* orderInfo = [self getOrderInfo:indexPath.row];
    NSString* signedStr = [self doRsa:orderInfo];
    NSLog(@"%@",signedStr);
    
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             orderInfo, signedStr, @"RSA"];
	
    [AlixLibService payOrder:orderString AndScheme:APP_SCHEME seletor:nil target:self];
	
	
//	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	Class class = NSClassFromString(_dataSourceDictionary[@(indexPath.section)][indexPath.row][kPushTargetClass]);
//	if (class) {
//		UIViewController *viewController = [[class alloc] init];
//		viewController.hidesBottomBarWhenPushed = YES;
//		[self.navigationController pushViewController:viewController animated:YES];
//	}
}

-(NSString*)getOrderInfo:(NSInteger)index
{
    /*
	 *点击获取prodcut实例并初始化订单信息
	 */
	//Product *product = [_products objectAtIndex:index];
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
	
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
	order.productName = @"商品标题"; //商品标题
	order.productDescription = @"商品描述"; //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f", 0.01f]; //商品价格
	order.notifyURL =  @"http%3A%2F%2Fwwww.zoombin.com"; //回调URL
	
	return [order description];
}

- (NSString *)generateTradeNO
{
	const int N = 15;
	
	NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *result = [[NSMutableString alloc] init] ;
	srand(time(0));
	for (int i = 0; i < N; i++)
	{
		unsigned index = rand() % [sourceString length];
		NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
		[result appendString:s];
	}
	return result;
}

-(NSString*)doRsa:(NSString*)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}


@end
