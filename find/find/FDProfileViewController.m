//
//  FDProfileViewController.m
//  find
//
//  Created by zhangbin on 11/30/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDProfileViewController.h"
#import "FDSignupViewController.h"
#import "FDEditPropertyViewController.h"
#import "FDLabelEditCell.h"
#import "FDTextViewEditCell.h"
#import "FDSettingsViewController.h"
#import "FDAvatarView.h"
#import "FDMeCell.h"

static NSString *numberOfPickerComponents = @"numberOfPickerComponents";
static NSString *numberOfPickerRows = @"numberOfPickerRows";
static NSString *minimumValueOfPicker = @"minimamOfPicker";
static NSString *maximumValueOfPicker = @"maximumValueOfPicker";
static NSString *actionOfPickerRow = @"actionOfPickerRow";

static NSInteger tagOfProfileLabel = 'prof';
static NSInteger tagOfPrivacyLabel = 'priv';

@interface FDProfileViewController ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property (readwrite) FDUserProfile *userProfile;
@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableDictionary *dataSourceDictionary;
@property (readwrite) UIPickerView *pickerView;
@property (readwrite) NSMutableDictionary *pickerDataSource;
@property (readwrite) NSString *identifierOfSelectedCell;
@property (readwrite) UISegmentedControl *genderSegmentedControl;
@property (readwrite) UISegmentedControl *shapeSegmentedControl;
@property (readwrite) FDAvatarView *avatar;
@property (readwrite) NSInteger selectedPickerRow;
@property (readwrite) UILabel *signatureLabel;
@property (readwrite) BOOL bMyself;//是我自己的资料还是别人的资料
@property (readwrite) NSString *age;
@property (readwrite) NSString *height;
@property (readwrite) NSString *weight;
@property (readwrite) NSString *chest;

@end

@implementation FDProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationController.title = NSLocalizedString(@"Profile", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (!_userID) {
		_bMyself = YES;
	} else {
		_bMyself = [_userID integerValue] == [[[FDAFHTTPClient shared] userID] integerValue];
	}
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	_dataSourceDictionary = [NSMutableDictionary dictionary];
	_pickerDataSource = [NSMutableDictionary dictionary];
	
	NSInteger section = 0;
	NSArray *sectionData;
	
	sectionData = @[
				  @{kIdentifier : kProfileAvatar, kIcon : @"IconAvatar", kTitle : NSLocalizedString(@"Avatar", nil), kAction : NSStringFromSelector(@selector(editAvatar)), kHeightOfCell : @([FDMeCell height])},
				  
				  @{kIdentifier : kProfileNickname, kIcon : @"IconNickname", kTitle : NSLocalizedString(@"Nickname", nil), kAction : NSStringFromSelector(@selector(pushEditPropertyViewControllerWithIdentifier:))},
				  
				  @{kIdentifier : kProfileSignature, kIcon : @"IconSignature", kTitle : NSLocalizedString(@"Signature", nil), kAction : NSStringFromSelector(@selector(pushEditPropertyViewControllerWithIdentifier:))},
				  
				  @{kIdentifier : kProfileGender, kIcon : @"IconGender", kTitle : NSLocalizedString(@"Gender", nil)},
				  ];
	_dataSourceDictionary[@(section)] = sectionData;
	section++;
	
	sectionData = @[
				  @{kIdentifier : kProfileShape, kHeightOfCell : @(33)},
					];
	_dataSourceDictionary[@(section)] = sectionData;
	section++;
	
	sectionData = @[
				  @{kIdentifier : kProfileMobile, kIcon : @"IconMobile", kTitle : NSLocalizedString(@"Mobile", nil), kAction : NSStringFromSelector(@selector(pushEditPropertyViewControllerWithIdentifier:))},
				  
				  @{kIdentifier : kProfileQQ, kIcon : @"IconQQ", kTitle : NSLocalizedString(@"QQ", nil), kAction : NSStringFromSelector(@selector(pushEditPropertyViewControllerWithIdentifier:))},
				  
				  @{kIdentifier : kProfileWeixin, kIcon : @"IconWeixin", kTitle : NSLocalizedString(@"Weixin", nil), kAction : NSStringFromSelector(@selector(pushEditPropertyViewControllerWithIdentifier:))},
				  
				  @{kIdentifier : kProfileAddress, kIcon : @"IconLocation", kTitle : NSLocalizedString(@"Address", nil), kAction : NSStringFromSelector(@selector(pushEditPropertyViewControllerWithIdentifier:))},
				  
				  ];
	_dataSourceDictionary[@(section)] = sectionData;
	section++;


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
	
	min = @(30);
	max = @(100);
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
	_pickerView.delegate = self;
	_pickerView.dataSource = self;
	_pickerView.showsSelectionIndicator = YES;
	[self.view addSubview:_pickerView];
	[self hidePickerViewAnimated:NO];
	
	if (!_genderSegmentedControl) {
		NSString *female = NSLocalizedString(@"Female", nil);
		NSString *male = NSLocalizedString(@"Male", nil);
		_genderSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[female, male]];
		_genderSegmentedControl.tintColor = [UIColor fdThemeRed];
		_genderSegmentedControl.selectedSegmentIndex = 0;
		[_genderSegmentedControl addTarget:self action:@selector(editGender) forControlEvents:UIControlEventValueChanged];
		_genderSegmentedControl.userInteractionEnabled = _bMyself;
	}
	
	if (!_shapeSegmentedControl) {
		_age = NSLocalizedString(@"Age", nil);
		_height = NSLocalizedString(@"Height", nil);
		_weight = NSLocalizedString(@"Weight", nil);
		_chest = NSLocalizedString(@"Chest", nil);
		_shapeSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[_age, _height, _weight, _chest]];
		_shapeSegmentedControl.tintColor = [UIColor fdThemeRed];
		[_shapeSegmentedControl addTarget:self action:@selector(editShape) forControlEvents:UIControlEventValueChanged];
		_shapeSegmentedControl.userInteractionEnabled = _bMyself;
	}
	
	[self displayHUD:NSLocalizedString(@"Loading...", nil)];
	[self fetchProfile:^{
		[self hideHUD:YES];
		[self refreshGenderSegmentedControl];
		[self refreshShapeSegmentedControl];
		[_tableView reloadData];
	}];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchProfileThenReloadTableView) name:ME_PROFILE_NEED_REFRESH_NOTIFICATION_IDENTIFIER object:nil];
}

- (void)refreshGenderSegmentedControl
{
	_genderSegmentedControl.selectedSegmentIndex = _userProfile.bFemale ? FDGenderTypeFemale : FDGenderTypeMale;
}

- (void)refreshShapeSegmentedControl
{
	[_shapeSegmentedControl setTitle:[NSString stringWithFormat:@"%@:%@", _age, [_userProfile.age printableAge]] forSegmentAtIndex:FDShapeTypeAge];
	[_shapeSegmentedControl setTitle:[NSString stringWithFormat:@"%@:%@", _height, [_userProfile.height printableHeight]] forSegmentAtIndex:FDShapeTypeHeight];
	[_shapeSegmentedControl setTitle:[NSString stringWithFormat:@"%@:%@", _weight, [_userProfile.weight printableWeight]] forSegmentAtIndex:FDShapeTypeWeight];
	[_shapeSegmentedControl setTitle:[NSString stringWithFormat:@"%@:%@", _chest, [_userProfile.chest printableChest]] forSegmentAtIndex:FDShapeTypeChest];
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
	if (_identifierOfSelectedCell) {
		NSNumber *min = _pickerDataSource[_identifierOfSelectedCell][minimumValueOfPicker];
		NSNumber *max = _pickerDataSource[_identifierOfSelectedCell][maximumValueOfPicker];
		NSInteger delta = [max integerValue] - [min integerValue];
		id value = [_userProfile valueWithIdentifier:_identifierOfSelectedCell];
		if ([value isKindOfClass:[NSNumber class]]) {
			NSInteger row = [value integerValue] - [min integerValue];
			if (row >= 0  && row < delta) {
				[_pickerView selectRow:row inComponent:0 animated:NO];
			}
		}
	}
	_pickerView.hidden = NO;
	[UIView animateWithDuration:duration animations:^{
		_pickerView.backgroundColor = [UIColor randomColor];
		CGRect frame = _pickerView.frame;
		frame.origin.y = self.view.bounds.size.height - frame.size.height;
		_pickerView.frame = frame;
	} completion:nil];
}

- (void)pushEditPropertyViewControllerWithIdentifier:(NSString *)identifier
{
	FDEditPropertyViewController *editPropertyViewController = [[FDEditPropertyViewController alloc] initWithStyle:UITableViewStylePlain];
	//editPropertyViewController.hidesBottomBarWhenPushed = YES;
	editPropertyViewController.identifier = identifier;
	
	if ([identifier isEqualToString:kProfileNickname]) {
		editPropertyViewController.cellClass = [FDLabelEditCell class];
		editPropertyViewController.content = _userProfile.nickname;
		editPropertyViewController.footerText = NSLocalizedString(@"Place input your nickname", nil);
		editPropertyViewController.title = NSLocalizedString(@"Nickname", nil);
	} else if ([identifier isEqualToString:kProfileSignature]) {
		editPropertyViewController.cellClass = [FDTextViewEditCell class];
		editPropertyViewController.content = _userProfile.signature;
		editPropertyViewController.footerText = NSLocalizedString(@"Place input your signature", nil);
		editPropertyViewController.title = NSLocalizedString(@"Signature", nil);
	} else if ([identifier isEqualToString:kProfileMobile]) {
		editPropertyViewController.cellClass = [FDLabelEditCell class];
		editPropertyViewController.content = [_userProfile.mobileInformation valueString];
		editPropertyViewController.privacyInfo = _userProfile.mobileInformation;
		editPropertyViewController.footerText = NSLocalizedString(@"Place input your mobile", nil);
		editPropertyViewController.title = NSLocalizedString(@"Mobile", nil);
		editPropertyViewController.keyboardType = UIKeyboardTypeNumberPad;
	} else if ([identifier isEqualToString:kProfileQQ] ) {
		editPropertyViewController.cellClass = [FDLabelEditCell class];
		editPropertyViewController.content = [_userProfile.qqInformation valueString];
		editPropertyViewController.privacyInfo = _userProfile.qqInformation;
		editPropertyViewController.footerText = NSLocalizedString(@"Place input your QQ", nil);
		editPropertyViewController.title = NSLocalizedString(@"QQ", nil);
		editPropertyViewController.keyboardType = UIKeyboardTypeNumberPad;
	} else if ([identifier isEqualToString:kProfileWeixin]) {
		editPropertyViewController.cellClass = [FDLabelEditCell class];
		editPropertyViewController.content = [_userProfile.weixinInformation valueString];
		editPropertyViewController.privacyInfo = _userProfile.weixinInformation;
		editPropertyViewController.footerText = NSLocalizedString(@"Place input your Weixin", nil);
		editPropertyViewController.title = NSLocalizedString(@"Weixin", nil);
	} else if ([identifier isEqualToString:kProfileAddress]) {
		editPropertyViewController.cellClass = [FDLabelEditCell class];
		editPropertyViewController.content = [_userProfile.addressInformation valueString];
		editPropertyViewController.privacyInfo = _userProfile.addressInformation;
		editPropertyViewController.footerText = NSLocalizedString(@"Place input your address", nil);
		editPropertyViewController.title = NSLocalizedString(@"Address", nil);
	}
	[self.navigationController pushViewController:editPropertyViewController animated:YES];
}

- (void)editAvatar
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Snap a New", @"Pick From Photo Library", nil];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)editGender
{
	NSLog(@"gender changed!");
	NSNumber *gender = @(_genderSegmentedControl.selectedSegmentIndex);
	[[FDAFHTTPClient shared] editProfile:@{kProfileGender : gender} withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			_userProfile.bFemale = _genderSegmentedControl.selectedSegmentIndex == FDGenderTypeFemale ? YES : NO;
		} else {
			[self displayHUDTitle:nil message:message];
			_genderSegmentedControl.selectedSegmentIndex = _userProfile.bFemale ? FDGenderTypeFemale : FDGenderTypeMale;
		}
	}];
}

- (void)editShape
{
	NSLog(@"editShape");
	NSString *identifier = kProfileAge;
	if (_shapeSegmentedControl.selectedSegmentIndex == FDShapeTypeAge) {
		identifier = kProfileAge;
	} else if (_shapeSegmentedControl.selectedSegmentIndex == FDShapeTypeHeight) {
		identifier = kProfileHeight;
	} else if (_shapeSegmentedControl.selectedSegmentIndex == FDShapeTypeWeight) {
		identifier = kProfileWeight;
	} else if (_shapeSegmentedControl.selectedSegmentIndex == FDShapeTypeChest) {
		identifier = kProfileChest;
	}
	[self editPicker:identifier];
}

- (void)editPicker:(NSString *)identifier
{
	_identifierOfSelectedCell = identifier;
	[_pickerView reloadAllComponents];
	[self showPickerViewAnimated:YES];
}

- (void)pushToSettings
{
	FDSettingsViewController *settingsViewController = [[FDSettingsViewController alloc] init];
	//settingsViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:settingsViewController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)fetchProfileThenReloadTableView
{
	
	[self fetchProfile:^{
		[_tableView reloadData];
	}];
}

- (void)fetchProfile:(dispatch_block_t)block
{
	[[FDAFHTTPClient shared] profileOfUser:_userID withCompletionBlock:^(BOOL success, NSString *message, NSDictionary *userProfileAttributes) {
		if (success) {
			_userProfile = [FDUserProfile createWithAttributes:userProfileAttributes];
		}
		if (block) block ();
	}];
}

- (void)editPickerPropertyWith:(NSString *)identifier withValue:(NSNumber *)value
{
	NSLog(@"will editPickerPropertyWith: %@ in withValue: %@", identifier, value);
	[[FDAFHTTPClient shared] editProfile:@{identifier : value} withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			[_userProfile setValue:value withIdentifier:identifier];
			[self refreshShapeSegmentedControl];
			[_tableView reloadData];
		} else {
			[self displayHUDTitle:NSLocalizedString(@"Update Failed", nil) message:message duration:1];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	static CGFloat rightMargin;
	rightMargin = _bMyself ? 35 : 15;
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.selectionStyle = _bMyself ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
		cell.accessoryType = _bMyself ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	}
	
	if ([identifier isEqualToString:kProfileAvatar]) {
		CGSize avatarSize = [FDAvatarView bigSize];
		NSNumber *heightOfCell = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kHeightOfCell];
		CGRect frame = CGRectMake(tableView.bounds.size.width - avatarSize.width - rightMargin, (heightOfCell.floatValue - avatarSize.height) / 2, avatarSize.width, avatarSize.height);
		_avatar = [[FDAvatarView alloc] initWithFrame:frame];
		_avatar.imagePath = _userProfile.avatarPath;
		[cell.contentView addSubview:_avatar];
	} else if ([identifier isEqualToString:kProfileGender]) {
		cell.accessoryView = _genderSegmentedControl;
	} else if ([identifier isEqualToString:kProfileShape]) {
		_shapeSegmentedControl.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height);
		[cell.contentView addSubview:_shapeSegmentedControl];
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else if ([identifier isEqualToString:kProfileAvatar]) {
		_avatar.imagePath = _userProfile.avatarPath;
	} else {
		if (_userProfile) {
			NSString *display = [_userProfile displayWithIdentifier:identifier];
			if (display) {
				UILabel *label = (UILabel *)[cell viewWithTag:tagOfProfileLabel];
				if (!label) {
					CGFloat widthOfLabel = [identifier isEqualToString:kProfileSignature] ? 210 : 85;
					label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.bounds.size.width - widthOfLabel - rightMargin, 0, widthOfLabel, cell.bounds.size.height)];
					label.backgroundColor = [UIColor clearColor];
					//label.backgroundColor = [UIColor randomColor];
					label.textAlignment = NSTextAlignmentRight;
					label.numberOfLines = 0;
					label.tag = tagOfProfileLabel;
					label.lineBreakMode = NSLineBreakByCharWrapping;
					label.font = [UIFont fdBoldThemeFontOfSize:12];
					[cell.contentView addSubview:label];
					if ([identifier isEqualToString:kProfileSignature]) {
						_signatureLabel = label;
					}
				}
				label.text = display;
			}
			
			NSString *privacyInfo = [_userProfile privacyInfoWithIdentifier:identifier];
			if (privacyInfo) {
				UILabel *privacyInfoLabel = (UILabel *)[cell viewWithTag:tagOfPrivacyLabel];
				if (!privacyInfoLabel) {
					privacyInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, cell.bounds.size.height)];
					privacyInfoLabel.backgroundColor = [UIColor clearColor];
					privacyInfoLabel.backgroundColor = [UIColor randomColor];//TODO
					privacyInfoLabel.font = [UIFont fdThemeFontOfSize:14];
					privacyInfoLabel.textAlignment = NSTextAlignmentCenter;
					privacyInfoLabel.tag = tagOfPrivacyLabel;
					[cell.contentView addSubview:privacyInfoLabel];
				}
				privacyInfoLabel.text = privacyInfo;
			}
		}
	}
		
	NSString *title = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kTitle];
	if (title) {
		cell.textLabel.text = title;
		cell.textLabel.font = [UIFont fdThemeFontOfSize:16];
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
	
	//	NSString *identifier = _dataSource[indexPath.row][kIdentifier];
	//	if ([identifier isEqualToString:kProfileSignature]) {
	//		if (_signatureLabel) {
	//			[_signatureLabel sizeToFit];
	//			return _signatureLabel.bounds.size.height;
	//		}
	//	}
	
	return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!_pickerView.hidden) {
		[self hidePickerViewAnimated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
		
		//注意这里一定要用_identifierOfSelectedCell来识别,代表之前选中的picker
		NSNumber *min = _pickerDataSource[_identifierOfSelectedCell][minimumValueOfPicker];
		NSNumber *max = _pickerDataSource[_identifierOfSelectedCell][maximumValueOfPicker];
		NSInteger selectedValue = [min integerValue] + _selectedPickerRow;
		if (selectedValue >= [min integerValue] && selectedValue <= [max integerValue]) {
			[self editPickerPropertyWith:_identifierOfSelectedCell withValue:@(selectedValue)];
		}
		_shapeSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
		return;
	}
	NSString *identifier = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kIdentifier];
	if (!_pickerDataSource[identifier]) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
	if (_bMyself) {
		SEL action = NSSelectorFromString(_dataSourceDictionary[@(indexPath.section)][indexPath.row][kAction]);
		if (action) {
			[self performSelector:action withObject:identifier afterDelay:0];
		}
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
		NSNumber *value = @(min.integerValue + row);
		SEL selector = NSSelectorFromString(_pickerDataSource[_identifierOfSelectedCell][actionOfPickerRow]);
		return (NSString *)[value performSelector:selector withObject:nil];
	}
	return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	_selectedPickerRow = row;
	if (_identifierOfSelectedCell) {
		NSNumber *min = _pickerDataSource[_identifierOfSelectedCell][minimumValueOfPicker];
		NSNumber *value = @(min.integerValue + row);
		if ([_identifierOfSelectedCell isEqualToString:kProfileAge]) {
			_userProfile.age = value;
		} else if ([_identifierOfSelectedCell isEqualToString:kProfileHeight]) {
			_userProfile.height = value;
		} else if ([_identifierOfSelectedCell isEqualToString:kProfileWeight]) {
			_userProfile.weight = value;
		} else if ([_identifierOfSelectedCell isEqualToString:kProfileChest]) {
			_userProfile.chest = value;
		}
		//[_tableView reloadData];
	}
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.delegate = self;
			imagePickerController.allowsEditing = YES;
			imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
			if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
				imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
			}
			[self presentViewController:imagePickerController animated:YES completion:nil];
		}
	} else if (buttonIndex == 1) {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
			UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.delegate = self;
			imagePickerController.allowsEditing = YES;
			[self presentViewController:imagePickerController animated:YES completion:nil];
		}
	}
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self displayHUD:NSLocalizedString(@"Uploading Avatar", nil)];
	[picker dismissViewControllerAnimated:YES completion:^{
		UIImage *image = info[UIImagePickerControllerEditedImage];
		NSString *path = [NSString avatarPathWithUserID:[[FDAFHTTPClient shared] userID]];
		NSData *imageData = UIImagePNGRepresentation(image);
		[[ZBQNAFHTTPClient shared] uploadData:imageData name:path withCompletionBlock:^(BOOL success) {
			if (success) {
				[[FDAFHTTPClient shared] editAvatarPath:path withCompletionBlock:^(BOOL success, NSString *message) {
					if (success) {
						[self displayHUDTitle:nil message:NSLocalizedString(@"Update Succeed!", nil) duration:1];
						_userProfile.avatarPath = path;
						_avatar.image = image;
					} else {
						[self displayHUDTitle:nil message:message];
					}
				}];
			} else {
				[self hideHUD:YES];
			}
		}];
	}];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
		if (((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
			[[UIApplication sharedApplication] setStatusBarHidden:NO];
			[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
		}
    }
}

@end
