//
//  FDSettingsViewController.m
//  find
//
//  Created by zhangbin on 11/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDSettingsViewController.h"
#import "FDWebViewController.h"
#import "FDAdviseViewController.h"

@interface FDSettingsViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableArray *dataSource;

@end

@implementation FDSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"设置", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 55)];
	
	UIButton *signoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[signoutButton setTitle:NSLocalizedString(@"退出登录", nil) forState:UIControlStateNormal];
	signoutButton.showsTouchWhenHighlighted = YES;
	[signoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[signoutButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
	[signoutButton setBackgroundColor:[UIColor fdThemeRed]];
	signoutButton.frame = CGRectMake(10, 10, tableFooterView.bounds.size.width - 2 * 10, 35);
	[signoutButton addTarget:self action:@selector(willSignout) forControlEvents:UIControlEventTouchUpInside];
	[tableFooterView addSubview:signoutButton];
	
	_tableView.tableFooterView = tableFooterView;
	
	_dataSource = [NSMutableArray array];
	
	NSInteger section = 0;
	_dataSource[section] = @{kIcon: @"IconPush", kTitle : NSLocalizedString(@"推送", nil), kPushTargetClass : NSStringFromClass([FDWebViewController class]), kWebViewPath : @"http://www.baidu.com"};
	section++;
	
	_dataSource[section] = @{kIcon: @"IconLocal", kTitle : NSLocalizedString(@"定位", nil), kPushTargetClass : NSStringFromClass([FDWebViewController class]), kWebViewPath : @"http://www.google.com"};
	section++;
	
	_dataSource[section] = @{kIcon: @"IconIntroduce", kTitle : NSLocalizedString(@"功能介绍", nil), kPushTargetClass : NSStringFromClass([FDWebViewController class]), kWebViewPath : @"http://www.apple.com.cn"};
	section++;
	
	_dataSource[section] = @{kIcon: @"IconNotice", kTitle : NSLocalizedString(@"系统通知", nil), kPushTargetClass : NSStringFromClass([FDWebViewController class]), kWebViewPath : @"http://www.sina.com"};
	section++;
	
	_dataSource[section] = @{kIcon: @"IconEnroll", kTitle : NSLocalizedString(@"招募合伙人", nil), kPushTargetClass : NSStringFromClass([FDWebViewController class]), kWebViewPath : @"http://www.qq.com"};
	section++;
	
	_dataSource[section] = @{kIcon: @"IconAdvise", kTitle : NSLocalizedString(@"意见与反馈", nil), kPushTargetClass : NSStringFromClass([FDAdviseViewController class])};
	section++;
	
	_dataSource[section] = @{kIcon: @"IconAdvise", kTitle : NSLocalizedString(@"修改密码", nil), kPushTargetClass : NSStringFromClass([FDAdviseViewController class])};
	section++;
}

- (void)willSignout
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"退出登录", nil) message:NSLocalizedString(@"确定要退出登录吗？", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
	[alertView show];
}

- (void)signout
{
	//[[FDAFHTTPClient shared] signout];
	NSLog(@"signout");
	//TODO: should have notifications
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex) {
		[self signout];
	}
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"identifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.textLabel.text = _dataSource[indexPath.section][kTitle];
	cell.textLabel.font = [UIFont fdThemeFontOfSize:16];
	
	NSString *iconName = _dataSource[indexPath.section][kIcon];
	if (iconName) {
		cell.imageView.image = [UIImage imageNamed:iconName];
	}
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Class class = NSClassFromString(_dataSource[indexPath.section][kPushTargetClass]);
	NSString *webViewPath = _dataSource[indexPath.section][kWebViewPath];
	if (class) {
		UIViewController *viewController = [[class alloc] init];
		if (webViewPath) {
			((FDWebViewController *)viewController).path = webViewPath;
			viewController.title = _dataSource[indexPath.section][kTitle];
		}
		[self.navigationController pushViewController:viewController animated:YES];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
