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

static NSInteger sectionOfEdit = 0;
static NSInteger sectionOfUser = 1;

@interface FDEditPropertyViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (readwrite) UISegmentedControl *segmentedControl;

@end

@implementation FDEditPropertyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		self.view.backgroundColor = [UIColor clearColor];
		
		[self setLeftBarButtonItemAsBackButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	NSString *public = NSLocalizedString(@"Public", nil);
	NSString *partly = NSLocalizedString(@"Partly", nil);
	NSString *private = NSLocalizedString(@"Private", nil);
	_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[public, partly, private]];
	[_segmentedControl addTarget:self action:@selector(privacyChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	if (_privacyInfo) {
		NSInteger index = 0;
		if ([_privacyInfo isPartly]) {
			index = 1;
		} else if ([_privacyInfo isPrivate]) {
			index = 2;
		}
		_segmentedControl.selectedSegmentIndex = index;
		self.navigationItem.titleView = _segmentedControl;
	}
}

- (void)privacyChanged:(id)sender
{
	
}

- (void)setPrivacyInfo:(FDInformation *)privacyInfo
{
	if (_privacyInfo == privacyInfo) return;
	_privacyInfo = privacyInfo;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save
{
	NSLog(@"save");
	
	if (!_identifier) return;
	
	NSLog(@"will save %@: %@", _identifier, _content);
	
	NSString *stringWithoutNewline = [_content stringByReplacingOccurrencesOfString: @"\r" withString:@""];
	stringWithoutNewline = [stringWithoutNewline stringByReplacingOccurrencesOfString: @"\n" withString:@""];
	[[FDAFHTTPClient shared] editProfile:@{_identifier : stringWithoutNewline} withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			[self displayHUDTitle:NSLocalizedString(@"Updated", nil) message:nil];
			[self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.0f];
			[[NSNotificationCenter defaultCenter] postNotificationName:ME_PROFILE_NEED_REFRESH_NOTIFICATION_IDENTIFIER object:nil];
		}
	}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (_privacyInfo) return 2;
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == sectionOfEdit) {
		return 15;
	}
	return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == sectionOfEdit) {
		return [_cellClass numberOfRows];
	}
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [_cellClass height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == sectionOfEdit) {
		FDEditCell *cell = [tableView dequeueReusableCellWithIdentifier:[FDEditCell identifier]];
		if (!cell) {
			cell = [[_cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FDEditCell identifier]];
			cell.delegate = self;
			cell.content = _content;
			[cell becomeFirstResponder];
		}
		return cell;
	} else {
		FDUserCell *cell = [tableView dequeueReusableCellWithIdentifier:[FDUserCell identifier]];
		if (!cell) {
			cell = [[_cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FDUserCell identifier]];
//			cell.delegate = self;
//			cell.content = _content;
//			[cell becomeFirstResponder];
		}
		return cell;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == sectionOfUser) {
		UISearchBar *searchBar = [[UISearchBar alloc] init];
		return searchBar;
	}
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (section == sectionOfEdit) {
		return [[[_cellClass alloc] init] footerWithText:_footerText];
	}
	return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if (section == sectionOfEdit) {
		return [_cellClass heightOfFooter];
	}
	return 1;
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if (textView.text.length > 10) {
		return NO;
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self setRightBarButtonItemAsSaveButtonWithSelector:@selector(save)];
//	if (textView.text.length > 10) {
//		textView.text = [textView.text substringToIndex:30];
//	}
	_content = textView.text;//TODO:限定字数，参照微信
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if (range.length == 0) {//表示不是删除后退键
		if (textView.text.length >= 10) {
			return NO;
		}
	}
	if ([text isEqualToString:@"\r"] || [text isEqualToString:@"\n"] || [text isEqualToString:@"\r\n"] || [text isEqualToString:@"\n\r"]) {
		return NO;
	}
	return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	[self setRightBarButtonItemAsSaveButtonWithSelector:@selector(save)];
	_content = textField.text;
	return YES;
}

@end
