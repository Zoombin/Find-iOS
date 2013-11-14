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

@interface FDMeViewController ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSMutableArray *dataSource;
@property (readwrite) NSMutableDictionary *actionsDictionary;
@property (readwrite) UIPickerView *pickerView;
@property (readwrite) NSMutableDictionary *pickerDataSource;
@property (readwrite) NSString *titleOfSelectedCell;

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
	
	NSString *nickname = NSLocalizedString(@"Nickname", nil);
	[_dataSource addObject:nickname];
	_actionsDictionary[nickname] = NSStringFromSelector(@selector(editNickname:));
	
	NSString *signature = NSLocalizedString(@"Signature", nil);
	[_dataSource addObject:signature];
	_actionsDictionary[signature] = NSStringFromSelector(@selector(editSignature:));
	
	NSString *age = NSLocalizedString(@"Age", nil);
	[_dataSource addObject:age];
	_actionsDictionary[age] = NSStringFromSelector(@selector(editAge:));
	NSNumber *min = @(10);
	NSNumber *max = @(40);
	NSNumber *delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[age] = @{numberOfPickerComponents : @(1),
							   numberOfPickerRows : delta,
							   minimumValueOfPicker : min,
							   maximumValueOfPicker : max,
							   actionOfPickerRow : @"printableAge"};
	
	NSString *gender = NSLocalizedString(@"Gender", nil);
	[_dataSource addObject:gender];
	_actionsDictionary[gender] = NSStringFromSelector(@selector(editGender:));
	
	NSString *height = NSLocalizedString(@"Height", nil);
	[_dataSource addObject:height];
	_actionsDictionary[height] = NSStringFromSelector(@selector(editHeight:));
	min = @(150);
	max = @(200);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[height] = @{numberOfPickerComponents : @(1),
							   numberOfPickerRows : delta,
							   minimumValueOfPicker : min,
							   maximumValueOfPicker : max,
							   actionOfPickerRow : @"printableHeight"};

	
	NSString *weight = NSLocalizedString(@"Weight", nil);
	[_dataSource addObject:weight];
	_actionsDictionary[weight] = NSStringFromSelector(@selector(editWeight:));
	min = @(40);
	max = @(80);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[weight] = @{numberOfPickerComponents : @(1),
							   numberOfPickerRows : delta,
							   minimumValueOfPicker : min,
							   maximumValueOfPicker : max,
							   actionOfPickerRow : @"printableWeight"};

	
	NSString *bust = NSLocalizedString(@"Bust", nil);
	[_dataSource addObject:bust];
	_actionsDictionary[bust] = NSStringFromSelector(@selector(editBust:));
	min = @(0);
	max = @(6);
	delta = @(max.integerValue - min.integerValue + 1);
	_pickerDataSource[bust] = @{numberOfPickerComponents : @(1),
								  numberOfPickerRows : delta,
								  minimumValueOfPicker : min,
								  maximumValueOfPicker : max,
								  actionOfPickerRow : @"printableBust"};
	
	NSString *phone = NSLocalizedString(@"Phone", nil);
	[_dataSource addObject:phone];
	_actionsDictionary[phone] = NSStringFromSelector(@selector(editPhone:));
	
	NSString *QQ = NSLocalizedString(@"QQ", nil);
	[_dataSource addObject:QQ];
	_actionsDictionary[QQ] = NSStringFromSelector(@selector(editQQ:));
	
	NSString *wechat = NSLocalizedString(@"Wechat", nil);
	[_dataSource addObject:wechat];
	_actionsDictionary[wechat] = NSStringFromSelector(@selector(editWechat:));
	
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
	NSLog(@"editNickname");
	FDEditPropertyViewController *editPropertyViewController = [[FDEditPropertyViewController alloc] initWithStyle:UITableViewStyleGrouped];
	editPropertyViewController.cellClass = [FDEditNicknameCell class];
	[self.navigationController pushViewController:editPropertyViewController animated:YES];
}

- (void)editSignature:(NSString *)title
{
	NSLog(@"editSignature");
	FDEditPropertyViewController *editPropertyViewController = [[FDEditPropertyViewController alloc] initWithStyle:UITableViewStyleGrouped];
	editPropertyViewController.cellClass = [FDEditSignatureCell class];
	[self.navigationController pushViewController:editPropertyViewController animated:YES];
}

- (void)editAge:(NSString *)title
{
	NSLog(@"edit: %@", title);
	_titleOfSelectedCell = title;
	[_pickerView reloadAllComponents];
	[self showPickerViewAnimated:YES];
}

- (void)editGender:(NSString *)title
{
	NSLog(@"edit: %@", title);
}

- (void)editHeight:(NSString *)title
{
	NSLog(@"edit: %@", title);
	_titleOfSelectedCell = title;
	[_pickerView reloadAllComponents];
	[self showPickerViewAnimated:YES];
}

- (void)editWeight:(NSString *)title
{
	NSLog(@"edit: %@", title);
	_titleOfSelectedCell = title;
	[_pickerView reloadAllComponents];
	[self showPickerViewAnimated:YES];
	
}

- (void)editBust:(NSString *)title
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
		
		NSString *key = _dataSource[indexPath.row];
		if ([key isEqualToString:NSLocalizedString(@"Gender", nil)]) {
			UISegmentedControl *genderSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Male", nil), NSLocalizedString(@"Female", nil)]];
			genderSegmentedControl.selectedSegmentIndex = 0;//TODO: should select correctly
			genderSegmentedControl.userInteractionEnabled = !_bOther;
			cell.accessoryView = genderSegmentedControl;
			
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
	if (!_pickerDataSource[key]) {
		if (!_pickerView.hidden) {
			[self hidePickerViewAnimated:YES];
			return;
		}
	}
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
