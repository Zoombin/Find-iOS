//
//  FDFifthViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDMeViewController.h"
#import "FDSignupViewController.h"

//static NSString *keyOfAction = @"keyOfAction";

@interface FDMeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableArray *dataSource;
@property (readwrite) NSMutableDictionary *actionsDictionary;

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
	_bOther = YES;
	if (_bOther) {
		self.title = NSLocalizedString(@"Profile", nil);
	}
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	_dataSource = [NSMutableArray array];
	_actionsDictionary = [NSMutableDictionary dictionary];
	
	NSString *nickname = NSLocalizedString(@"Nickname", nil);
	[_dataSource addObject:nickname];
	_actionsDictionary[nickname] = NSStringFromSelector(@selector(editNickname));
	
	NSString *signature = NSLocalizedString(@"Signature", nil);
	[_dataSource addObject:signature];
	_actionsDictionary[signature] = NSStringFromSelector(@selector(editSignature));
	
	NSString *age = NSLocalizedString(@"Age", nil);
	[_dataSource addObject:age];
	_actionsDictionary[age] = NSStringFromSelector(@selector(editAge));
	
	NSString *gender = NSLocalizedString(@"Gender", nil);
	[_dataSource addObject:gender];
	_actionsDictionary[gender] = NSStringFromSelector(@selector(editGender));
	
	NSString *height = NSLocalizedString(@"Height", nil);
	[_dataSource addObject:height];
	_actionsDictionary[height] = NSStringFromSelector(@selector(editHeight));
	
	NSString *weight = NSLocalizedString(@"Weight", nil);
	[_dataSource addObject:weight];
	_actionsDictionary[weight] = NSStringFromSelector(@selector(editHeight));
	
	NSString *bust = NSLocalizedString(@"Bust", nil);
	[_dataSource addObject:bust];
	_actionsDictionary[bust] = NSStringFromSelector(@selector(editBust));
	
	NSString *phone = NSLocalizedString(@"Phone", nil);
	[_dataSource addObject:phone];
	_actionsDictionary[phone] = NSStringFromSelector(@selector(editPhone));
	
	NSString *QQ = NSLocalizedString(@"QQ", nil);
	[_dataSource addObject:QQ];
	_actionsDictionary[QQ] = NSStringFromSelector(@selector(editQQ));
	
	NSString *wechat = NSLocalizedString(@"Wechat", nil);
	[_dataSource addObject:wechat];
	_actionsDictionary[wechat] = NSStringFromSelector(@selector(editWechat));
	
	NSString *qrcode = NSLocalizedString(@"QRCode", nil);
	[_dataSource addObject:qrcode];
	
	NSString *location = NSLocalizedString(@"Location", nil);
	[_dataSource addObject:location];
	
	NSString *level = NSLocalizedString(@"Level", nil);
	[_dataSource addObject:level];
	
	NSString *gifts = NSLocalizedString(@"Gifts", nil);
	[_dataSource addObject:gifts];
	
	if (!_bOther) {
		NSString *followers = NSLocalizedString(@"Followers", nil);
		[_dataSource addObject:followers];
		
		NSString *following = NSLocalizedString(@"Following", nil);
		[_dataSource addObject:following];
		
		NSString *privateMessage = NSLocalizedString(@"Private Message", nil);
		[_dataSource addObject:privateMessage];
		
		NSString *manageMyAvatar = NSLocalizedString(@"Manage My Avatar", nil);
		[_dataSource addObject:manageMyAvatar];
		
		NSString *manageMyPhotos = NSLocalizedString(@"Manage My Photos", nil);
		[_dataSource addObject:manageMyPhotos];
		
		NSString *settings = NSLocalizedString(@"Settings", nil);
		[_dataSource addObject:settings];
	}
}

- (void)editNickname
{
	NSLog(@"editNickname");
}

- (void)editSignature
{
	NSLog(@"editSignature");
}

- (void)editAge
{
	NSLog(@"editAge");
}

- (void)editGender
{
	NSLog(@"editGender");
}

- (void)editHeight
{
	NSLog(@"editHeight");
}

- (void)editBust
{
	NSLog(@"editBust");
}

- (void)editPhone
{
	NSLog(@"editPhone");
}

- (void)editQQ
{
	NSLog(@"editQQ");
}

- (void)editWechat
{
	NSLog(@"editWechat");
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
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	NSString *title = _dataSource[indexPath.row];
	cell.textLabel.text = title;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *key = _dataSource[indexPath.row];
	SEL action = NSSelectorFromString(_actionsDictionary[key]);
	if (action) {
		[self performSelector:action withObject:nil afterDelay:0];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
