//
//  FDFifthViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDMeViewController.h"
#import "FDSignupViewController.h"
#import "FDEditPropertyViewController.h"
#import "FDEditNicknameCell.h"
#import "FDEditSignatureCell.h"

static NSString *numberOfPickerComponents = @"numberOfPickerComponents";
static NSString *numberOfPickerRows = @"numberOfPickerRows";
static NSString *minimumValueOfPicker = @"minimamOfPicker";
static NSString *maximumValueOfPicker = @"maximumValueOfPicker";
static NSString *actionOfPickerRow = @"actionOfPickerRow";

#define kIdentifier @"identifier"
#define kTitle @"title"
#define kAction @"action"

@interface FDMeViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (readwrite) FDUserProfile *userProfile;
@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableArray *dataSource;
@property (readwrite) UIPickerView *pickerView;
@property (readwrite) NSMutableDictionary *pickerDataSource;
@property (readwrite) NSString *identifierOfSelectedCell;
@property (readwrite) UISegmentedControl *genderSegmentedControl;

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
	_bMyself = YES;
	if (!_bMyself) {
		self.navigationController.title = NSLocalizedString(@"Profile", nil);
	}
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	_dataSource = [NSMutableArray array];
	_pickerDataSource = [NSMutableDictionary dictionary];
	
	[_dataSource addObject:@{kIdentifier : kProfileUsername, kTitle : NSLocalizedString(@"Nickname", nil), kAction : NSStringFromSelector(@selector(editNickname:))}];
	[_dataSource addObject:@{kIdentifier : kProfileSignature, kTitle : NSLocalizedString(@"Signature", nil), kAction : NSStringFromSelector(@selector(editSignature:))}];
	[_dataSource addObject:@{kIdentifier : kProfileGender, kTitle : NSLocalizedString(@"Gender", nil)}];
	[_dataSource addObject:@{kIdentifier : kProfileAge, kTitle : NSLocalizedString(@"Age", nil), kAction : NSStringFromSelector(@selector(editPicker:))}];
	[_dataSource addObject:@{kIdentifier : kProfileHeight, kTitle : NSLocalizedString(@"Height", nil), kAction : NSStringFromSelector(@selector(editPicker:))}];
	[_dataSource addObject:@{kIdentifier : kProfileWeight, kTitle : NSLocalizedString(@"Weight", nil), kAction : NSStringFromSelector(@selector(editPicker:))}];
	[_dataSource addObject:@{kIdentifier : kProfileChest, kTitle : NSLocalizedString(@"Chest", nil), kAction : NSStringFromSelector(@selector(editPicker:))}];
	[_dataSource addObject:@{kIdentifier : kProfileMobile, kTitle : NSLocalizedString(@"Mobile", nil), kAction : NSStringFromSelector(@selector(editPhone:))}];
	[_dataSource addObject:@{kIdentifier : kProfileQQ, kTitle : NSLocalizedString(@"QQ", nil), kAction : NSStringFromSelector(@selector(editQQ:))}];
	[_dataSource addObject:@{kIdentifier : kProfileWeixin, kTitle : NSLocalizedString(@"Weixin", nil), kAction : NSStringFromSelector(@selector(editWeixin:))}];
	[_dataSource addObject:@{kIdentifier : kProfileAddress, kTitle : NSLocalizedString(@"Address", nil)}];
	[_dataSource addObject:@{kIdentifier : kProfileAvatar, kTitle : NSLocalizedString(@"Avatar", nil)}];
	[_dataSource addObject:@{kIdentifier : kProfilePhotos, kTitle : NSLocalizedString(@"Photos", nil)}];
	[_dataSource addObject:@{kIdentifier : kProfilePrivateMessages, kTitle : NSLocalizedString(@"Private Messages", nil)}];
	if (_bMyself) {
		[_dataSource addObject:@{kIdentifier : kProfileSettings, kTitle : NSLocalizedString(@"Settings", nil)}];
	}

	
	NSNumber *min = @(0);
	NSNumber *max = @(0);
	NSNumber *delta = @(max.integerValue - min.integerValue + 1);
	min = @(10);
	max = @(40);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[kProfileAge] = @{numberOfPickerComponents : @(1),
							   numberOfPickerRows : delta,
							   minimumValueOfPicker : min,
							   maximumValueOfPicker : max,
							   actionOfPickerRow : NSStringFromSelector(@selector(printableAge))};
	
	min = @(150);
	max = @(200);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[kProfileHeight] = @{numberOfPickerComponents : @(1),
								  numberOfPickerRows : delta,
								  minimumValueOfPicker : min,
								  maximumValueOfPicker : max,
								  actionOfPickerRow : NSStringFromSelector(@selector(printableHeight))};
	
	min = @(40);
	max = @(80);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[kProfileWeight] = @{numberOfPickerComponents : @(1),
							   numberOfPickerRows : delta,
							   minimumValueOfPicker : min,
							   maximumValueOfPicker : max,
							   actionOfPickerRow : NSStringFromSelector(@selector(printableWeight))};

	min = @(0);
	max = @(6);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[kProfileChest] = @{numberOfPickerComponents : @(1),
								  numberOfPickerRows : delta,
								  minimumValueOfPicker : min,
								  maximumValueOfPicker : max,
								  actionOfPickerRow : NSStringFromSelector(@selector(printableChest))};
	
	_pickerView = [[UIPickerView alloc] initWithFrame:self.view.bounds];
	_pickerView.backgroundColor = [UIColor randomColor];
	_pickerView.delegate = self;
	_pickerView.dataSource = self;
	_pickerView.showsSelectionIndicator = YES;
	[self.view addSubview:_pickerView];
	[self hidePickerViewAnimated:NO];
	
	
}

- (void)hidePickerViewAnimated:(BOOL)animated
{
	CGFloat duration = 0;
	if (animated) {
		duration = 0.3;
	}
	[UIView animateWithDuration:duration animations:^{
		CGRect frame = _pickerView.frame;
		frame.origin.y = self.view.bounds.size.height;
		_pickerView.frame = frame;
	} completion:^(BOOL finished) {
		if (finished) {
			_pickerView.hidden = YES;
		}
	}];
}

- (void)showPickerViewAnimated:(BOOL)animated
{
	CGFloat duration = 0;
	if (animated) {
		duration = 0.3;
	}
	_pickerView.hidden = NO;
	[UIView animateWithDuration:duration animations:^{
		CGRect frame = _pickerView.frame;
		frame.origin.y = self.view.bounds.size.height - frame.size.height;
		_pickerView.frame = frame;
	}];
}

- (void)editNickname:(NSString *)identifier
{
	NSLog(@"edit: %@", identifier);
	FDEditPropertyViewController *editPropertyViewController = [[FDEditPropertyViewController alloc] initWithStyle:UITableViewStyleGrouped];
	editPropertyViewController.cellClass = [FDEditNicknameCell class];
	editPropertyViewController.identifier = identifier;
	editPropertyViewController.content = _userProfile.username;
	[self.navigationController pushViewController:editPropertyViewController animated:YES];
}

- (void)editSignature:(NSString *)identifier
{
	NSLog(@"edit: %@", identifier);
	FDEditPropertyViewController *editPropertyViewController = [[FDEditPropertyViewController alloc] initWithStyle:UITableViewStyleGrouped];
	editPropertyViewController.cellClass = [FDEditSignatureCell class];
	editPropertyViewController.identifier = identifier;
	editPropertyViewController.content = _userProfile.signature;
	[self.navigationController pushViewController:editPropertyViewController animated:YES];
}

- (void)editPicker:(NSString *)identifier
{
	NSLog(@"edit: %@", identifier);
	_identifierOfSelectedCell = identifier;
	[_pickerView reloadAllComponents];
	[self showPickerViewAnimated:YES];
}

- (void)editPhone:(NSString *)identifier
{
	NSLog(@"edit: %@", identifier);
}

- (void)editQQ:(NSString *)identifier
{
	NSLog(@"edit: %@", identifier);
}

- (void)editWeixin:(NSString *)identifier
{
	NSLog(@"edit: %@", identifier);
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (_bMyself) {
		[[FDAFHTTPClient shared] profileWithCompletionBlock:^(BOOL success, NSString *message, NSDictionary *userProfileAttributes) {
			if (success) {
				_userProfile = [FDUserProfile createWithAttributes:userProfileAttributes];
				[_tableView reloadData];
			}
		}];
	} else {
		[[FDAFHTTPClient shared] profileOfUser:@(2) withCompletionBlock:^(BOOL success, NSString *message, NSDictionary *userProfileAttributes) {
			if (success) {
				_userProfile = [FDUserProfile createWithAttributes:userProfileAttributes];
				[_tableView reloadData];
			}
		}];
	}
	
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
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	}
	NSString *identifier = _dataSource[indexPath.row][kIdentifier];
	if ([identifier isEqualToString:kProfileGender]) {
		if (!_genderSegmentedControl) {
			_genderSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Male", nil), NSLocalizedString(@"Female", nil)]];
		}
		if (_userProfile) {
			_genderSegmentedControl.selectedSegmentIndex = [_userProfile isFemale] ? 0 : 1;
		}
		_genderSegmentedControl.userInteractionEnabled = _bMyself;
		cell.accessoryView = _genderSegmentedControl;
	} else if ([identifier isEqualToString:kProfileSettings]) {
		
	} else if ([identifier isEqualToString:kProfileAvatar]) {
		
	} else if ([identifier isEqualToString:kProfilePrivateMessages]) {
		
	} else {
		if (_userProfile) {
			NSString *display = [_userProfile displayWithIdentifier:identifier];
			if (display) {
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
				label.backgroundColor = [UIColor randomColor];
				label.textAlignment = NSTextAlignmentRight;
				label.text = display;
				cell.accessoryView = label;
			}
			
			NSString *privacyInfo = [_userProfile privacyInfoWithIdentifier:identifier];
			if (privacyInfo) {
				UILabel *privacyInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, cell.bounds.size.height)];
				privacyInfoLabel.backgroundColor = [UIColor randomColor];
				privacyInfoLabel.text = privacyInfo;
			}
		}
	}
	
	NSString *title = _dataSource[indexPath.row][kTitle];
	cell.textLabel.text = title;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!_pickerView.hidden) {
		[self hidePickerViewAnimated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}
	NSString *identifier = _dataSource[indexPath.row][kIdentifier];
	SEL action = NSSelectorFromString(_dataSource[indexPath.row][kAction]);
	if ([identifier isEqualToString:kProfileGender]) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	if (action) {
		[self performSelector:action withObject:identifier afterDelay:0];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	if (_identifierOfSelectedCell) {
		return [_pickerDataSource[_identifierOfSelectedCell][numberOfPickerComponents] integerValue];
	}
	return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (_identifierOfSelectedCell) {
		return [_pickerDataSource[_identifierOfSelectedCell][numberOfPickerRows] integerValue];
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (_identifierOfSelectedCell) {
		NSNumber *min = _pickerDataSource[_identifierOfSelectedCell][minimumValueOfPicker];
		SEL selector = NSSelectorFromString(_pickerDataSource[_identifierOfSelectedCell][actionOfPickerRow]);
		NSNumber *value = @(min.integerValue + row);
		return (NSString *)[value performSelector:selector withObject:nil];
	}
	return @"";
}

@end
