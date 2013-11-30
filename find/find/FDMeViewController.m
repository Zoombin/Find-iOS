//
//  FDFifthViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDMeViewController.h"
#import "FDSignupViewController.h"
#import "FDProfileViewController.h"
#import "FDSettingsViewController.h"
#import "FDAvatarView.h"

NSString *kIdentifier = @"identifier";
NSString *kIcon = @"icon";
NSString *kTitle = @"title";
NSString *kAction = @"action";
NSString *kHeightOfCell = @"heightOfCell";

NSString *kMyProfiles = @"kMyProfiles";
NSString *kMyAlbum = @"kMyAlbum";
NSString *kMyPorperties = @"kMyPorperties";
NSString *kMyInterests = @"kMyInterests";
NSString *kMyMessages = @"kMyMessages";
NSString *kStore = @"kStore";
NSString *kSettings = @"kSettings";

@interface FDMeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (readwrite) FDUserProfile *userProfile;
@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableDictionary *dataSourceDictionary;
@property (readwrite) FDAvatarView *avatarView;

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
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	NSArray *firstSectionData = @[
								  @{kIdentifier : kMyProfiles, kIcon : @"Avatar", kTitle : NSLocalizedString(@"My Profiles", nil), kAction : NSStringFromSelector(@selector(pushToProfiles)), kHeightOfCell : @(90)},
								];
	
	NSArray *secondSectionData = @[
								@{kIdentifier : kMyAlbum, kIcon : @"MoreMyAlbum", kTitle : NSLocalizedString(@"My Album", nil)},
								@{kIdentifier : kMyPorperties, kIcon : @"MoreMyBankCard", kTitle : NSLocalizedString(@"My Properties", nil)},
								@{kIdentifier : kMyInterests, kIcon : @"MoreExpressionShops", kTitle : NSLocalizedString(@"My Interests", nil)},
								@{kIdentifier : kMyMessages, kIcon : @"MoreMyFavorites", kTitle : NSLocalizedString(@"My Messages", nil)},
								];
	
	NSArray *thirdSectionData = @[
								  @{kIdentifier : kStore, kIcon : @"MoreGame", kTitle : NSLocalizedString(@"Store", nil)},
								  ];
	
	NSArray *fourthSectionData = @[
								  @{kIdentifier : kSettings, kIcon : @"MoreSetting", kTitle : NSLocalizedString(@"Settings", nil), kAction : NSStringFromSelector(@selector(pushToSettings))},
								  ];
	_dataSourceDictionary = [NSMutableDictionary dictionary];
	_dataSourceDictionary[@(0)] = firstSectionData;
	_dataSourceDictionary[@(1)] = secondSectionData;
	_dataSourceDictionary[@(2)] = thirdSectionData;
	_dataSourceDictionary[@(3)] = fourthSectionData;
	
	_avatarView = [[FDAvatarView alloc] initWithFrame:CGRectMake(0, 0, [FDAvatarView bigSize].width, [FDAvatarView bigSize].height)];
	
	[self displayHUD:NSLocalizedString(@"Loading...", nil)];
	[self fetchProfile:^{
		[self hideHUD:YES];
		
		if (_userProfile.avatarPath) {
			_avatarView.imagePath = _userProfile.avatarPath;
		}
		
		[_tableView reloadData];
	}];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchProfileThenReloadTableView) name:ME_PROFILE_NEED_REFRESH_NOTIFICATION_IDENTIFIER object:nil];
}

- (void)pushToProfiles
{
	FDProfileViewController *profileViewController = [[FDProfileViewController alloc] init];
	profileViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:profileViewController animated:YES];
}

- (void)pushToSettings
{
	FDSettingsViewController *settingsViewController = [[FDSettingsViewController alloc] init];
	settingsViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:settingsViewController animated:YES];
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

- (void)fetchProfileThenReloadTableView
{
	[self fetchProfile:^{
		[_tableView reloadData];
	}];
}

- (void)fetchProfile:(dispatch_block_t)block
{
	[[FDAFHTTPClient shared] profileOfUser:nil withCompletionBlock:^(BOOL success, NSString *message, NSDictionary *userProfileAttributes) {
		if (success) {
			_userProfile = [FDUserProfile createWithAttributes:userProfileAttributes];
		}
		if (block) block ();
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ME_PROFILE_NEED_REFRESH_NOTIFICATION_IDENTIFIER object:nil];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _dataSourceDictionary.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_dataSourceDictionary[@(section)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kIdentifier];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	if ([identifier isEqualToString:kMyProfiles]) {
		CGRect frame = _avatarView.frame;
		frame.origin.x = cell.indentationWidth;
		frame.origin.y = (cell.bounds.size.height - _avatarView.bounds.size.height) / 2;
		_avatarView.frame = frame;
		[cell.contentView addSubview:_avatarView];
	} else {
		NSString *imageName = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kIcon];
		cell.imageView.image = [UIImage imageNamed:imageName];
		NSString *title = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kTitle];
		cell.textLabel.text = title;
		cell.textLabel.font = [UIFont fdThemeFontOfSize:16];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNumber *height = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kHeightOfCell];
	if (height) {
		return height.floatValue;
	}
	return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kIdentifier];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	SEL action = NSSelectorFromString(_dataSourceDictionary[@(indexPath.section)][indexPath.row][kAction]);
	if (action) {
		[self performSelector:action withObject:identifier afterDelay:0];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
