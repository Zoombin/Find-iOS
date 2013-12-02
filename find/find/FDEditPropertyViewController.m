//
//  FDEditPropertyViewController.m
//  find
//
//  Created by zhangbin on 11/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDEditPropertyViewController.h"
#import "FDEditCell.h"
#import "FDEditSignatureCell.h"

@interface FDEditPropertyViewController () <UITextViewDelegate, UITextFieldDelegate>

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
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellClass numberOfRows];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [_cellClass height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FDEditCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[_cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.delegate = self;
		cell.content = _content;
		[cell becomeFirstResponder];
	}
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return [[[_cellClass alloc] init] footerWithText:_footerText];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return [_cellClass heightOfFooter];
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
	_content = textView.text;
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
