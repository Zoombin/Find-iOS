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
#import "FDSettingsViewController.h"
#import "FDAvatarView.h"

static NSString *numberOfPickerComponents = @"numberOfPickerComponents";
static NSString *numberOfPickerRows = @"numberOfPickerRows";
static NSString *minimumValueOfPicker = @"minimamOfPicker";
static NSString *maximumValueOfPicker = @"maximumValueOfPicker";
static NSString *actionOfPickerRow = @"actionOfPickerRow";

#define kIdentifier @"identifier"
#define kTitle @"title"
#define kAction @"action"
#define kHeightOfCell @"heightOfCell"

@interface FDMeViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AFPhotoEditorControllerDelegate>

@property (readwrite) FDUserProfile *userProfile;
@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableArray *dataSource;
@property (readwrite) UIPickerView *pickerView;
@property (readwrite) NSMutableDictionary *pickerDataSource;
@property (readwrite) NSString *identifierOfSelectedCell;
@property (readwrite) UISegmentedControl *genderSegmentedControl;
@property (readwrite) NSDictionary *dataNeedSave;
@property (readwrite) FDAvatarView *avatarView;
@property (readwrite) NSInteger selectedPickerRow;
@property (readwrite) NSDictionary *willChangeData;

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
	
	[_dataSource addObject:@{kIdentifier : kProfileAvatar, kTitle : NSLocalizedString(@"Avatar", nil), kAction : NSStringFromSelector(@selector(editAvatar)), kHeightOfCell : @(60)}];
	[_dataSource addObject:@{kIdentifier : kProfileNickname, kTitle : NSLocalizedString(@"Nickname", nil), kAction : NSStringFromSelector(@selector(editNickname:))}];
	[_dataSource addObject:@{kIdentifier : kProfileAge, kTitle : NSLocalizedString(@"Age", nil), kAction : NSStringFromSelector(@selector(editPicker:))}];
	[_dataSource addObject:@{kIdentifier : kProfileHeight, kTitle : NSLocalizedString(@"Height", nil), kAction : NSStringFromSelector(@selector(editPicker:))}];
	[_dataSource addObject:@{kIdentifier : kProfileWeight, kTitle : NSLocalizedString(@"Weight", nil), kAction : NSStringFromSelector(@selector(editPicker:))}];
	[_dataSource addObject:@{kIdentifier : kProfileChest, kTitle : NSLocalizedString(@"Chest", nil), kAction : NSStringFromSelector(@selector(editPicker:))}];
	[_dataSource addObject:@{kIdentifier : kProfileSignature, kTitle : NSLocalizedString(@"Signature", nil), kAction : NSStringFromSelector(@selector(editSignature:))}];
	[_dataSource addObject:@{kIdentifier : kProfileGender, kTitle : NSLocalizedString(@"Gender", nil)}];
	[_dataSource addObject:@{kIdentifier : kProfileMobile, kTitle : NSLocalizedString(@"Mobile", nil), kAction : NSStringFromSelector(@selector(editPhone:))}];
	[_dataSource addObject:@{kIdentifier : kProfileQQ, kTitle : NSLocalizedString(@"QQ", nil), kAction : NSStringFromSelector(@selector(editQQ:))}];
	[_dataSource addObject:@{kIdentifier : kProfileWeixin, kTitle : NSLocalizedString(@"Weixin", nil), kAction : NSStringFromSelector(@selector(editWeixin:))}];
	[_dataSource addObject:@{kIdentifier : kProfileAddress, kTitle : NSLocalizedString(@"Address", nil)}];
	[_dataSource addObject:@{kIdentifier : kProfilePhotos, kTitle : NSLocalizedString(@"Photos", nil)}];
	[_dataSource addObject:@{kIdentifier : kProfilePrivateMessages, kTitle : NSLocalizedString(@"Private Messages", nil)}];
	if (_bMyself) {
		[_dataSource addObject:@{kIdentifier : kProfileSettings, kTitle : NSLocalizedString(@"Settings", nil), kAction : NSStringFromSelector(@selector(pushToSettings))}];
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
	
	[self fetchProfile:^{
		[_tableView reloadData];
	}];
}

- (BOOL)addDataNeedSave:(id)data withIdentifier:(NSString *)identifier
{
	return YES;
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
	editPropertyViewController.content = _userProfile.nickname;
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

- (void)editAvatar
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Snap a New", @"Pick From Photo Library", nil];
	[actionSheet showInView:self.view];
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

- (void)fetchProfile:(dispatch_block_t)block
{
	NSNumber *userID = _bMyself ? nil : @(2);//TODO: test
	[[FDAFHTTPClient shared] profileOfUser:userID withCompletionBlock:^(BOOL success, NSString *message, NSDictionary *userProfileAttributes) {
		if (success) {
			_userProfile = [FDUserProfile createWithAttributes:userProfileAttributes];
		}
		if (block) block ();
	}];
}

- (void)startCamera
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		imagePickerController.delegate = self;
		imagePickerController.allowsEditing = YES;
		[self presentViewController:imagePickerController animated:YES completion:nil];
	}
}

- (void)startPhotoLibrary
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		imagePickerController.delegate = self;
		imagePickerController.allowsEditing = YES;
		[self presentViewController:imagePickerController animated:YES completion:nil];
	}
}

- (void)editPickerPropertyWith:(NSString *)identifier inRow:(NSInteger)row
{
	NSLog(@"will edit picker: %@ in row: %d", identifier, row);
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
	NSString *identifier = _dataSource[indexPath.row][kIdentifier];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
		
		if ([identifier isEqualToString:kProfileAvatar]) {
			CGSize avatarSize = [FDAvatarView bigSize];
			NSNumber *heightOfCell = _dataSource[indexPath.row][kHeightOfCell];
			CGRect frame = CGRectMake(tableView.bounds.size.width - avatarSize.width - 40, (heightOfCell.floatValue - avatarSize.height) / 2, avatarSize.width, avatarSize.height);
			_avatarView = [[FDAvatarView alloc] initWithFrame:frame];
			_avatarView.imagePath = _userProfile.avatarPath;
			[cell.contentView addSubview:_avatarView];
		}
	}
	if ([identifier isEqualToString:kProfileGender]) {
		if (!_genderSegmentedControl) {
			_genderSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Female", nil), NSLocalizedString(@"Male", nil)]];
			[_genderSegmentedControl addTarget:self action:@selector(editGender) forControlEvents:UIControlEventValueChanged];
			_genderSegmentedControl.userInteractionEnabled = _bMyself;
		}
		if (_userProfile) {
			_genderSegmentedControl.selectedSegmentIndex = _userProfile.bFemale ? FDGenderTypeFemale : FDGenderTypeMale;
		}
		
		cell.accessoryView = _genderSegmentedControl;
	} else if ([identifier isEqualToString:kProfileSettings]) {
		
	} else if ([identifier isEqualToString:kProfileAvatar]) {
		_avatarView.imagePath = _userProfile.avatarPath;
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
				UILabel *privacyInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, cell.bounds.size.height)];
				privacyInfoLabel.backgroundColor = [UIColor randomColor];
				privacyInfoLabel.text = privacyInfo;
				[cell.contentView addSubview:privacyInfoLabel];
			}
		}
	}
	
	NSString *title = _dataSource[indexPath.row][kTitle];
	cell.textLabel.text = title;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNumber *height = _dataSource[indexPath.row][kHeightOfCell];
	if (height) {
		return height.floatValue;
	}
	return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (!_pickerView.hidden) {
		[self hidePickerViewAnimated:YES];
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
		return;
	}
	NSString *identifier = _dataSource[indexPath.row][kIdentifier];
	if (_pickerDataSource[identifier]) {
//		if ([_identifierOfSelectedCell isEqualToString:identifier]) {//TODO: 修改picker的值
//			[self editPickerPropertyWith:identifier inRow:_selectedPickerRow];
//		}
	} else {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	
	SEL action = NSSelectorFromString(_dataSource[indexPath.row][kAction]);
	if (action) {
		[self performSelector:action withObject:identifier afterDelay:0];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	NSString *identifier = _dataSource[indexPath.row];//TODO
//	if (_pickerDataSource[identifier]) {
//		[self editPickerPropertyWith:identifier inRow:_selectedPickerRow];
//	}
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
		[self startCamera];
	} else if (buttonIndex == 1) {
		[self startPhotoLibrary];
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
		UIImage *avatarImage = info[UIImagePickerControllerEditedImage];
		NSString *avatarPath = [NSString avatarPathWithUserID:[[FDAFHTTPClient shared] userID]];
		NSData *imageData = UIImagePNGRepresentation(avatarImage);
		[[ZBQNAFHTTPClient shared] uploadData:imageData name:avatarPath withCompletionBlock:^(BOOL success) {
			if (success) {
				[[FDAFHTTPClient shared] editAvatarPath:avatarPath withCompletionBlock:^(BOOL success, NSString *message) {
					if (success) {
						[self displayHUDTitle:nil message:NSLocalizedString(@"Update Succeed!", nil) duration:1];
						_userProfile.avatarPath = avatarPath;
						_avatarView.image = avatarImage;
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


@end
