//
//  FDEditPropertyViewController.m
//  find
//
//  Created by zhangbin on 11/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDEditPropertyViewController.h"
#import "FDLabelEditCell.h"
#import "FDTextViewEditCell.h"
#import "FDUserCell.h"
#import "FDWebViewController.h"
@import MapKit;

static NSInteger sectionOfEdit = 0;
static NSInteger sectionOfUser = 1;
static NSInteger indexOfAlertDetails = 1;
static NSInteger heightOfMap = 150;

@interface FDEditPropertyViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UISearchBarDelegate, UISearchDisplayDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) UISegmentedControl *segmentedControl;
@property (readwrite) UISearchBar *searchBar;
@property (readwrite) NSArray *candidates;
@property (readwrite) NSInteger numberOfSections;
@property (readwrite) CLLocationManager *locationManager;
@property (readwrite) FDEditCell *cellInstance;
@property (readwrite) MKMapView *mapView;

@end

@implementation FDEditPropertyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.view.backgroundColor = [UIColor clearColor];
		[self setLeftBarButtonItemAsBackButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_numberOfSections = 1;
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	UIView *tableHeader = [[UIView alloc] init];//[[[_cellClass alloc] init] footerWithText:_footerText];
	tableHeader.backgroundColor = [UIColor clearColor];
	tableHeader.frame = CGRectMake(0, 0, _tableView.bounds.size.width, 30);
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
	[tableHeader addGestureRecognizer:tapGestureRecognizer];
	_tableView.tableHeaderView = tableHeader;
	
	NSString *public = NSLocalizedString(@"公开", nil);
	NSString *partly = NSLocalizedString(@"部分人可见", nil);
	NSString *private = NSLocalizedString(@"隐藏", nil);
	_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[public, partly, private]];
	_segmentedControl.frame = CGRectMake(0, 0, 180, 30);
	_segmentedControl.tintColor = [UIColor whiteColor];
	_segmentedControl.apportionsSegmentWidthsByContent = YES;
	[_segmentedControl addTarget:self action:@selector(privacyLevelChanged:) forControlEvents:UIControlEventValueChanged];
	
	_searchBar = [[UISearchBar alloc] init];
	_searchBar.backgroundColor = [UIColor clearColor];
	_searchBar.showsCancelButton = YES;
	_searchBar.delegate = self;
	
	_mapView = [[MKMapView alloc] init];
	_mapView.userInteractionEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (_cellClass) {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
		label.numberOfLines = 0;
		label.text = _footerText;
		label.font = [UIFont fdThemeFontOfSize:13];
		label.textAlignment = NSTextAlignmentCenter;
		label.userInteractionEnabled = YES;
		[_tableView.tableHeaderView addSubview:label];
	}

	if (_privacyInfo) {
		NSInteger index = 0;
		if ([_privacyInfo isPartly]) {
			index = 1;
		} else if ([_privacyInfo isPrivate]) {
			index = 2;
		}
		_segmentedControl.selectedSegmentIndex = index;
		self.navigationItem.titleView = _segmentedControl;
		
		if (_segmentedControl.selectedSegmentIndex == FDInformationLevelPartly) {
			[self fetchCandidatesWithBlock:^{
				[_tableView reloadData];
			}];
		}
		
		if (_privacyInfo.type == FDInformationTypeAddress) {
			_locationManager = [[CLLocationManager alloc] init];
			_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
			_locationManager.delegate = self;
			[_locationManager startUpdatingLocation];
		}
	}
}

- (void)fetchCandidatesWithBlock:(dispatch_block_t)block
{
	[[FDAFHTTPClient shared] candidatesWithCompletionBlock:^(BOOL success, NSString *message, NSNumber *published, NSArray *usersData) {
		if (success) {
			_candidates = [FDUser createMutableWithData:usersData];
		}
		if (block) block ();
	}];
}

- (void)privacyLevelChanged:(id)sender
{
	NSInteger index = _segmentedControl.selectedSegmentIndex;
	NSString *key = [FDUserProfile apiParameterPrivacyLevelKeyWithIdentifier:_identifier];
	[[FDAFHTTPClient shared] editProfile:@{key : @(index)} withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			[[NSNotificationCenter defaultCenter] postNotificationName:ME_PROFILE_NEED_REFRESH_NOTIFICATION_IDENTIFIER object:nil];
			if (index == FDInformationLevelPartly) {
				_numberOfSections = 2;
				_searchBar.hidden = NO;
				[self fetchCandidatesWithBlock:^{
					[_tableView reloadData];
				}];
			} else {
				_numberOfSections = 1;
				_searchBar.hidden = YES;
			}
			[_tableView reloadData];
		} else {
			[self displayHUDTitle:nil message:message];
		}
	}];
}

- (void)setPrivacyInfo:(FDInformation *)privacyInfo
{
	_numberOfSections = [privacyInfo isPartly] ? 2 : 1;
	_searchBar.hidden = [privacyInfo isPartly] ? NO : YES;
	if (_privacyInfo == privacyInfo) return;
	_privacyInfo = privacyInfo;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)save
{
	if (!_identifier) return;
	NSLog(@"will save %@: %@", _identifier, [_cellInstance content]);
	
	//NSString *stringWithoutNewline = [_content stringByReplacingOccurrencesOfString: @"\r" withString:@""];
	//stringWithoutNewline = [stringWithoutNewline stringByReplacingOccurrencesOfString: @"\n" withString:@""];
	NSString *key = [FDUserProfile apiParameterKeyWithIdentifier:_identifier];
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[key] = [_cellInstance content];
	
	CLLocation *location;
	if (_mapView.annotations.count) {
		MKPointAnnotation *annotation = _mapView.annotations[0];
		location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
	}
	
	if (location) {
		parameters[@"lat"] = @(location.coordinate.latitude);
		parameters[@"lng"] = @(location.coordinate.longitude);
	}
	[[FDAFHTTPClient shared] editProfile:parameters withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			[self displayHUDTitle:NSLocalizedString(@"更新成功", nil) message:nil];
			[self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.0f];
			[[NSNotificationCenter defaultCenter] postNotificationName:ME_PROFILE_NEED_REFRESH_NOTIFICATION_IDENTIFIER object:nil];
		}
	}];
}

- (void)addAnnotationWithLocation:(CLLocation *)location
{
	[_mapView setCenterCoordinate:location.coordinate animated:YES];
	[_mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000) animated:YES];
	
	MKPointAnnotation *annotation;
	if (_mapView.annotations.count == 0) {
		annotation = [[MKPointAnnotation alloc] init];
		[_mapView addAnnotation:annotation];
	} else {
		annotation = _mapView.annotations[0];
	}
	annotation.coordinate = location.coordinate;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == sectionOfEdit) {
		return [_cellClass numberOfRows];
	}
	return _candidates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == sectionOfEdit) {
		FDEditCell *cell = [tableView dequeueReusableCellWithIdentifier:[FDEditCell identifier]];
		if (!cell) {
			cell = [[_cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FDEditCell identifier]];
			cell.delegate = self;
			cell.content = _content;
			cell.keyboardType = _keyboardType;
			[cell becomeFirstResponder];
			_cellInstance = cell;
		}
		return cell;
	} else {
		FDUserCell *cell = [tableView dequeueReusableCellWithIdentifier:[FDUserCell identifier]];
		if (!cell) {
			cell = [[FDUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FDUserCell identifier]];
		}
		cell.user = _candidates[indexPath.row];
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [_cellClass height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == sectionOfEdit) {
		return 0;
	}
	return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == sectionOfUser) {
		return _searchBar;
	}
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_privacyInfo.type == FDInformationTypeAddress) {
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, heightOfMap)];
		view.backgroundColor = [UIColor clearColor];
		_mapView.frame = CGRectMake(_cellInstance.indentationWidth, 0, view.bounds.size.width - 2 * _cellInstance.indentationWidth, view.bounds.size.height);
		[view addSubview:_mapView];
		return view;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if (section == sectionOfEdit) {
		if (_privacyInfo.type == FDInformationTypeAddress) {
			return heightOfMap;
		}
		return 0;
	} else {
		return 0;
	}
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self setRightBarButtonItemAsSaveButtonWithSelector:@selector(save)];
	//TODO:限定字数，参照微信
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//	if (range.length == 0) {//表示不是删除后退键
//		if (textView.text.length >= 10) {
//			return NO;
//		}
//	}
//	if ([text isEqualToString:@"\r"] || [text isEqualToString:@"\n"] || [text isEqualToString:@"\r\n"] || [text isEqualToString:@"\n\r"]) {
//		return NO;
//	}
	return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	[self setRightBarButtonItemAsSaveButtonWithSelector:@selector(save)];
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self save];
	return YES;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];

	[self displayHUD:NSLocalizedString(@"搜索中...", nil)];
	[[FDAFHTTPClient shared] searchUserByKeyword:searchBar.text withCompletionBlock:^(BOOL success, NSString *message, NSArray *usersData) {
		[self hideHUD:YES];
		if (success) {
			[self displayHUDTitle:NSLocalizedString(@"搜索结果", nil) message:[NSString stringWithFormat:@"搜索到%d个结果", usersData.count] duration:1];
			_candidates = [FDUser createMutableWithData:usersData];
			[_tableView reloadData];
		}
	}];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if (searchText == nil || [searchText isEqualToString:@""]) {
		[self fetchCandidatesWithBlock:^{
			[_tableView reloadData];
		}];
	}
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	if (locations.count) {
		NSLog(@"first location: %@", [locations[0] coordinateString]);
		CLLocation *location = locations[0];
		[self addAnnotationWithLocation:location];
	}
}

//ios6
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"newLocation: %@", [newLocation coordinateString]);
	[self addAnnotationWithLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
	
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"定位服务不可用", nil) message:NSLocalizedString(@"请去系统设置中开启定位服务", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"知道了", nil) otherButtonTitles:NSLocalizedString(@"教程", nil), nil];
		[alertView show];
	}
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == indexOfAlertDetails) {
		FDWebViewController *webViewController = [[FDWebViewController alloc] init];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
		[self.navigationController presentViewController:navigationController animated:YES completion:nil];
	}
}

@end
