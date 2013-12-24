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
#import "FDStoreViewController.h"
#import "FDSettingsViewController.h"
#import "FDMeCell.h"
#import "FDSessionInvalidCell.h"
#import "FDAlbumViewController.h"

NSString *kLogin = @"kLogin";
NSString *kMyProfile = @"kMyProfile";
NSString *kMyAlbum = @"kMyAlbum";
NSString *kMyWealth = @"kMyWealth";
NSString *kMyInterests = @"kMyInterests";
NSString *kMyMessages = @"kMyMessages";
NSString *kStore = @"kStore";
NSString *kSettings = @"kSettings";

@interface FDMeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (readwrite) FDUserProfile *userProfile;
@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableDictionary *dataSourceDictionary;
@property (readwrite) NSArray *meSectionData;
@property (readwrite) NSArray *loginSectionData;

@end

@implementation FDMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"Me", nil);
		self.title = identifier;

		UIImage *normalImage = [UIImage imageNamed:@"Me"];
		UIImage *selectedImage = [UIImage imageNamed:@"MeHighlighted"];
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
			[self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:normalImage tag:0];
			[self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
		}
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	_dataSourceDictionary = [NSMutableDictionary dictionary];
	
	NSInteger section = 0;
	NSArray *sectionData;
	
	_meSectionData = @[
					   @{kIdentifier : kMyProfile, kCellClass : [FDMeCell class], kTitle : NSLocalizedString(@"My Profile", nil), kHeightOfCell : @([FDMeCell height]), kPushTargetClass : NSStringFromClass([FDProfileViewController class])},
					   ];
	_loginSectionData = @[
						  @{kIdentifier : kLogin, kCellClass : [FDSessionInvalidCell class], kHeightOfCell : @([FDSessionInvalidCell height]), kPresentTargetClass : NSStringFromClass([FDSignupViewController class])},
						  ];
	
	if ([[FDAFHTTPClient shared] isSessionValid]) {
		sectionData = _meSectionData;
	} else {
		sectionData = _loginSectionData;
	}
	_dataSourceDictionary[@(section)] = sectionData;
	section++;
	
	sectionData = @[
					@{kIdentifier : kMyAlbum, kIcon : @"IconAlbum", kTitle : NSLocalizedString(@"My Album", nil), kNeedSigninAlert : @(YES), kPushTargetClass : NSStringFromClass([FDAlbumViewController class])},
					
					@{kIdentifier : kMyWealth, kIcon : @"IconWealth", kTitle : NSLocalizedString(@"My Properties", nil), kNeedSigninAlert : @(YES)},
					
					@{kIdentifier : kMyInterests, kIcon : @"IconInterests", kTitle : NSLocalizedString(@"My Interests", nil), kNeedSigninAlert : @(YES)},
					
					@{kIdentifier : kMyMessages, kIcon : @"IconMessages", kTitle : NSLocalizedString(@"My Messages", nil), kNeedSigninAlert : @(YES)},
				  ];
	_dataSourceDictionary[@(section)] = sectionData;
	section++;
	
	sectionData = @[
				  @{kIdentifier : kStore, kIcon : @"IconStore", kTitle : NSLocalizedString(@"Store", nil), kPushTargetClass : NSStringFromClass([FDStoreViewController class])},
				  ];
	_dataSourceDictionary[@(section)] = sectionData;
	section++;
	
	sectionData = @[
				  @{kIdentifier : kSettings, kIcon : @"IconSettings", kTitle : NSLocalizedString(@"Settings", nil), kPushTargetClass : NSStringFromClass([FDSettingsViewController class])},
				  ];
	_dataSourceDictionary[@(section)] = sectionData;
	section++;
	
	[self displayHUD:NSLocalizedString(@"Loading...", nil)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchProfileThenReloadTableView) name:ME_PROFILE_NEED_REFRESH_NOTIFICATION_IDENTIFIER object:nil];
	
	[self fetchProfile:^{
		[self hideHUD:YES];
		[_tableView reloadData];
	}];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)fetchProfileThenReloadTableView
{
	_dataSourceDictionary[@(0)] = _meSectionData;
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
		if ([identifier isEqualToString:kLogin]) {
			cell = (FDSessionInvalidCell *)[[FDSessionInvalidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
			cell.accessoryType = UITableViewCellAccessoryNone;
		} else if ([identifier isEqualToString:kMyProfile]) {
			cell = (FDMeCell *)[[FDMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	}
	
	if ([identifier isEqualToString:kMyProfile]) {
		if ([[FDAFHTTPClient shared] isSessionValid]) {
			((FDMeCell *)cell).profile = _userProfile;
		}
	}
	
	cell.textLabel.text = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kTitle];
	cell.textLabel.font = [UIFont fdThemeFontOfSize:16];
	
	NSString *iconName = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kIcon];
	if (iconName) {
		cell.imageView.image = [UIImage imageNamed:iconName];
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
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSNumber *needSigninAlert = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kNeedSigninAlert];
	if (needSigninAlert.boolValue && ![[FDAFHTTPClient shared] isSessionValid]) {
		[self displayHUDTitle:NSLocalizedString(@"Need Signin", nil) message:NSLocalizedString(@"You have to signin first!", nil)];
		return;
	}
	
	Class class = NSClassFromString(_dataSourceDictionary[@(indexPath.section)][indexPath.row][kPushTargetClass]);
	if (class) {
		UIViewController *viewController = [[class alloc] init];
		//viewController.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:viewController animated:YES];
		return;
	}
	
	class = NSClassFromString(_dataSourceDictionary[@(indexPath.section)][indexPath.row][kPresentTargetClass]);
	if (class) {
		UIViewController *viewController = [[class alloc] init];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
		[self.navigationController presentViewController:navigationController animated:YES completion:nil];
		return;
	}
}

@end
