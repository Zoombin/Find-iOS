//
//  FDFifthViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDMeViewController.h"
#import "FDSignupViewController.h"

@interface FDMeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableArray *dataSource;

@end

@implementation FDMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"Me", nil);
		self.title = identifier;
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
			[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"MeHighlighted"] withFinishedUnselectedImage:[UIImage imageNamed:@"Me"]];
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:@"Me"] tag:0];
		}
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	_dataSource = [NSMutableArray array];
	
	NSString *avatar = NSLocalizedString(@"Avatar", nil);
	[_dataSource addObject:avatar];
	
	NSString *nickname = NSLocalizedString(@"Nickname", nil);
	[_dataSource addObject:nickname];
	
	NSString *signature = NSLocalizedString(@"Signature", nil);
	[_dataSource addObject:signature];
	
	NSString *age = NSLocalizedString(@"Age", nil);
	[_dataSource addObject:age];
	
	NSString *gender = NSLocalizedString(@"Gender", nil);
	[_dataSource addObject:gender];
	
	NSString *height = NSLocalizedString(@"Height", nil);
	[_dataSource addObject:height];
	
	NSString *weight = NSLocalizedString(@"Weight", nil);
	[_dataSource addObject:weight];
	
	NSString *bust = NSLocalizedString(@"Bust", nil);
	[_dataSource addObject:bust];
	
	NSString *phone = NSLocalizedString(@"Phone", nil);
	[_dataSource addObject:phone];
	
	NSString *qq = NSLocalizedString(@"QQ", nil);
	[_dataSource addObject:qq];
	
	NSString *weixin = NSLocalizedString(@"Wechat", nil);
	[_dataSource addObject:weixin];
	
	NSString *qrcode = NSLocalizedString(@"QRCode", nil);
	[_dataSource addObject:qrcode];
	
	NSString *location = NSLocalizedString(@"Location", nil);
	[_dataSource addObject:location];
	
	NSString *level = NSLocalizedString(@"Level", nil);
	[_dataSource addObject:level];
	
	NSString *gifts = NSLocalizedString(@"Gifts", nil);
	[_dataSource addObject:gifts];
	
	NSString *followers = NSLocalizedString(@"Followers", nil);
	[_dataSource addObject:followers];
	
	NSString *following = NSLocalizedString(@"Following", nil);
	[_dataSource addObject:following];
	
	NSString *privateMessage = NSLocalizedString(@"Private Message", nil);
	[_dataSource addObject:privateMessage];
	
	NSString *photos = NSLocalizedString(@"Manage My Photos", nil);
	[_dataSource addObject:photos];
	
	NSString *settings = NSLocalizedString(@"Settings", nil);
	[_dataSource addObject:settings];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
//	BOOL bSigninValid = NO;
//	if (!bSigninValid) {
//		FDSignupViewController *signupViewController = [[FDSignupViewController alloc] init];
//		[self.navigationController pushViewController:signupViewController animated:YES];
//	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell identifier]];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[UITableViewCell identifier]];
	}
	NSString *title = _dataSource[indexPath.row];
	cell.textLabel.text = title;
	return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
