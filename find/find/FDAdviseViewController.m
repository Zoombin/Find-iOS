//
//  FDAdviseViewController.m
//  find
//
//  Created by zhangbin on 12/24/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAdviseViewController.h"
#import "FDEditCell.h"
#import "FDTextViewEditCell.h"

@interface FDAdviseViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) FDTextViewEditCell *cellInstance;

@end

@implementation FDAdviseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"意见与反馈", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
}

- (void)sendAdvice
{
	NSString *string = [_cellInstance content];
	if (!string || [string areAllCharactersSpace]) {
		[self displayHUDTitle:NSLocalizedString(@"请输入内容", nil) message:nil duration:1];
		return;
	}
	//TODO:
	NSLog(@"send advice here");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FDTextViewEditCell *cell = [tableView dequeueReusableCellWithIdentifier:[FDTextViewEditCell identifier]];
	if (!cell) {
		cell = [[FDTextViewEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[FDTextViewEditCell identifier]];
		cell.delegate = self;
		cell.returnKeyType = UIReturnKeySend;
		[cell becomeFirstResponder];
	}
	_cellInstance = cell;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [FDTextViewEditCell height];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
	[self setRightBarButtonItemAsSendButtonWithSelector:@selector(sendAdvice)];
	//TODO:限定字数，参照微信
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if (range.length != 1 && [text isEqualToString:@"\n"]) {
		[self sendAdvice];
		return NO;
	}
	return YES;
}

@end
