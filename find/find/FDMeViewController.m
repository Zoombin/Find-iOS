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

@interface FDMeViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (readwrite) FDUserProfile *userProfile;
@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableArray *dataSource;
@property (readwrite) NSMutableDictionary *actionsDictionary;
@property (readwrite) UIPickerView *pickerView;
@property (readwrite) NSMutableDictionary *pickerDataSource;
@property (readwrite) NSString *titleOfSelectedCell;
@property (readwrite) UISegmentedControl *genderSegmentedControl;

@property (readwrite) NSString *kNickname;
@property (readwrite) NSString *kSignature;
@property (readwrite) NSString *kGender;
@property (readwrite) NSString *kAge;
@property (readwrite) NSString *kHeight;
@property (readwrite) NSString *kWeight;
@property (readwrite) NSString *kChest;
@property (readwrite) NSString *kMobile;
@property (readwrite) NSString *kQQ;
@property (readwrite) NSString *kWeixin;
@property (readwrite) NSString *kAddress;
//@property (readwrite) NSString *kLevel;
//@property (readwrite) NSString *kGifts;
//@property (readwrite) NSString *kNumberOfFollowers;
//@property (readwrite) NSString *kNumberOfFollowing;
@property (readwrite) NSString *kPrivateMessages;
@property (readwrite) NSString *kAvatar;
@property (readwrite) NSString *kPhotos;
@property (readwrite) NSString *kSettings;

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
	_actionsDictionary = [NSMutableDictionary dictionary];
	_pickerDataSource = [NSMutableDictionary dictionary];
	
	NSNumber *min = @(0);
	NSNumber *max = @(0);
	NSNumber *delta = @(max.integerValue - min.integerValue + 1);
	
	_kNickname = NSLocalizedString(@"Nickname", nil);
	[_dataSource addObject:_kNickname];
	_actionsDictionary[_kNickname] = NSStringFromSelector(@selector(editNickname:));
	
	_kSignature = NSLocalizedString(@"Signature", nil);
	[_dataSource addObject:_kSignature];
	_actionsDictionary[_kSignature] = NSStringFromSelector(@selector(editSignature:));
	
	_kGender = NSLocalizedString(@"Gender", nil);
	[_dataSource addObject:_kGender];
	
	_kAge = NSLocalizedString(@"Age", nil);
	[_dataSource addObject:_kAge];
	_actionsDictionary[_kAge] = NSStringFromSelector(@selector(editPicker:));
	min = @(10);
	max = @(40);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[_kAge] = @{numberOfPickerComponents : @(1),
							   numberOfPickerRows : delta,
							   minimumValueOfPicker : min,
							   maximumValueOfPicker : max,
							   actionOfPickerRow : NSStringFromSelector(@selector(printableAge))};
	
	_kHeight = NSLocalizedString(@"Height", nil);
	[_dataSource addObject:_kHeight];
	_actionsDictionary[_kHeight] = NSStringFromSelector(@selector(editPicker:));
	min = @(150);
	max = @(200);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[_kHeight] = @{numberOfPickerComponents : @(1),
								  numberOfPickerRows : delta,
								  minimumValueOfPicker : min,
								  maximumValueOfPicker : max,
								  actionOfPickerRow : NSStringFromSelector(@selector(printableHeight))};
	
	_kWeight = NSLocalizedString(@"Weight", nil);
	[_dataSource addObject:_kWeight];
	_actionsDictionary[_kWeight] = NSStringFromSelector(@selector(editPicker:));
	min = @(40);
	max = @(80);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[_kWeight] = @{numberOfPickerComponents : @(1),
							   numberOfPickerRows : delta,
							   minimumValueOfPicker : min,
							   maximumValueOfPicker : max,
							   actionOfPickerRow : NSStringFromSelector(@selector(printableWeight))};

	
	_kChest = NSLocalizedString(@"Chest", nil);
	[_dataSource addObject:_kChest];
	_actionsDictionary[_kChest] = NSStringFromSelector(@selector(editPicker:));
	min = @(0);
	max = @(6);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[_kChest] = @{numberOfPickerComponents : @(1),
								  numberOfPickerRows : delta,
								  minimumValueOfPicker : min,
								  maximumValueOfPicker : max,
								  actionOfPickerRow : NSStringFromSelector(@selector(printableChest))};
	
	_kMobile = NSLocalizedString(@"Mobile", nil);
	[_dataSource addObject:_kMobile];
	_actionsDictionary[_kMobile] = NSStringFromSelector(@selector(editPhone:));
	
	_kQQ = NSLocalizedString(@"QQ", nil);
	[_dataSource addObject:_kQQ];
	_actionsDictionary[_kQQ] = NSStringFromSelector(@selector(editQQ:));
	
	_kWeixin = NSLocalizedString(@"Weixin", nil);
	[_dataSource addObject:_kWeixin];
	_actionsDictionary[_kWeixin] = NSStringFromSelector(@selector(editWechat:));
	
	_kAddress = NSLocalizedString(@"Address", nil);
	[_dataSource addObject:_kAddress];
	
	_kAvatar = NSLocalizedString(@"Avatar", nil);
	[_dataSource addObject:_kAvatar];
	
	_kPhotos = NSLocalizedString(@"Photos", nil);
	[_dataSource addObject:_kPhotos];
	
	_kPrivateMessages = NSLocalizedString(@"Private Messages", nil);
	[_dataSource addObject:_kPrivateMessages];
	
	if (_bMyself) {
		_kSettings = NSLocalizedString(@"Settings", nil);
		[_dataSource addObject:_kSettings];
	}
	
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

- (void)editNickname:(NSString *)title
{
	NSLog(@"edit: %@", title);
	FDEditPropertyViewController *editPropertyViewController = [[FDEditPropertyViewController alloc] initWithStyle:UITableViewStyleGrouped];
	editPropertyViewController.cellClass = [FDEditNicknameCell class];
	editPropertyViewController.key = title;
	editPropertyViewController.content = _userProfile.username;
	[self.navigationController pushViewController:editPropertyViewController animated:YES];
}

- (void)editSignature:(NSString *)title
{
	NSLog(@"edit: %@", title);
	FDEditPropertyViewController *editPropertyViewController = [[FDEditPropertyViewController alloc] initWithStyle:UITableViewStyleGrouped];
	editPropertyViewController.cellClass = [FDEditSignatureCell class];
	editPropertyViewController.key = title;
	editPropertyViewController.content = _userProfile.signature;
	[self.navigationController pushViewController:editPropertyViewController animated:YES];
}

- (void)editPicker:(NSString *)title
{
	NSLog(@"edit: %@", title);
	_titleOfSelectedCell = title;
	[_pickerView reloadAllComponents];
	[self showPickerViewAnimated:YES];
}

- (void)editPhone:(NSString *)title
{
	NSLog(@"edit: %@", title);
}

- (void)editQQ:(NSString *)title
{
	NSLog(@"edit: %@", title);
}

- (void)editWechat:(NSString *)title
{
	NSLog(@"edit: %@", title);
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
	NSString *key = _dataSource[indexPath.row];
	if ([key isEqualToString:_kGender]) {
		if (!_genderSegmentedControl) {
			_genderSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Male", nil), NSLocalizedString(@"Female", nil)]];
		}
		if (_userProfile) {
			_genderSegmentedControl.selectedSegmentIndex = [_userProfile isFemale] ? 0 : 1;
		}
		_genderSegmentedControl.userInteractionEnabled = _bMyself;
		cell.accessoryView = _genderSegmentedControl;
	} else if ([key isEqualToString:_kSettings]) {
		
	} else if ([key isEqualToString:_kAvatar]) {
		
	} else if ([key isEqualToString:_kPrivateMessages]) {
		
	} else {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
		label.backgroundColor = [UIColor randomColor];
		label.textAlignment = NSTextAlignmentRight;
		cell.accessoryView = label;
		if (_userProfile) {
			if ([key isEqualToString:_kNickname]) {
				label.text = _userProfile.username;
			} else if ([key isEqualToString:_kSignature]) {
				label.text = _userProfile.signature;
			} else if ([key isEqualToString:_kAge]) {
				label.text = [_userProfile.age printableAge];
			} else if ([key isEqualToString:_kHeight]) {
				label.text = [_userProfile.height printableHeight];
			} else if ([key isEqualToString:_kWeight]) {
				label.text = [_userProfile.weight printableWeight];
			} else if ([key isEqualToString:_kChest]) {
				label.text = [_userProfile.chest printableChest];
			} else if ([key isEqualToString:_kQQ] || [key isEqualToString:_kMobile] || [key isEqualToString:_kWeixin] || [key isEqualToString:_kAddress]) {
				FDInformation *info;
				if ([key isEqualToString:_kQQ]) {
					info = _userProfile.qqInformation;
				} else if ([key isEqualToString:_kMobile]) {
					info = _userProfile.mobileInformation;
				} else if ([key isEqualToString:_kWeixin]) {
					info = _userProfile.weixinInformation;
				} else if ([key isEqualToString:_kAddress]) {
					info = _userProfile.addressInformation;
				}
				label.text = [info displayPrivacy];
				
				UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, cell.bounds.size.height)];
				content.backgroundColor = [UIColor randomColor];
				if ([info.value isKindOfClass:[NSNumber class]]) {
					content.text = [info.value stringValue];
				} else if ([info.value isKindOfClass:[NSString class]]) {
					content.text = info.value;
				}
			} else if ([key isEqualToString:_kPhotos]) {
				label.text = [_userProfile.numberOfPhotos stringValue];
			}
		}
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
	if ([key isEqualToString:_kGender]) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	//if (!_pickerDataSource[key]) {//如果这个cell也是picker
		if (!_pickerView.hidden) {
			[self hidePickerViewAnimated:YES];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			return;
		}
	//}
	if (action) {
		[self performSelector:action withObject:key afterDelay:0];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	if (_titleOfSelectedCell) {
		return [_pickerDataSource[_titleOfSelectedCell][numberOfPickerComponents] integerValue];
	}
	return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (_titleOfSelectedCell) {
		return [_pickerDataSource[_titleOfSelectedCell][numberOfPickerRows] integerValue];
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (_titleOfSelectedCell) {
		NSNumber *min = _pickerDataSource[_titleOfSelectedCell][minimumValueOfPicker];
		SEL selector = NSSelectorFromString(_pickerDataSource[_titleOfSelectedCell][actionOfPickerRow]);
		NSNumber *value = @(min.integerValue + row);
		return (NSString *)[value performSelector:selector withObject:nil];
	}
	return @"";
}

@end
