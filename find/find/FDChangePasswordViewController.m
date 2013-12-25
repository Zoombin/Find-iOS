//
//  FDChangePasswordViewController.m
//  find
//
//  Created by zhangbin on 12/25/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDChangePasswordViewController.h"
#import "FDIdentityPasswordCell.h"
#import "FDIdentityPasswordConfirmCell.h"

#define kIndexRowOfOldPassword 0
#define kIndexRowOfNewPassword 1
#define kIndexRowOfNewPasswordConfirm 2

@interface FDChangePasswordViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) UITextField *oldPasswordTextField;
@property (readwrite) UITextField *kNewPasswordTextField;
@property (readwrite) UITextField *kNewPasswordConfirmTextField;

@end

@implementation FDChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"修改密码", nil);
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

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[_oldPasswordTextField becomeFirstResponder];
}

- (void)changePassword
{
	if (_oldPasswordTextField.text == nil || _kNewPasswordTextField.text == nil || _kNewPasswordConfirmTextField.text == nil || [_oldPasswordTextField.text areAllCharactersSpace] || [_kNewPasswordTextField.text areAllCharactersSpace] || [_kNewPasswordConfirmTextField.text areAllCharactersSpace]) {
		[self displayHUDTitle:NSLocalizedString(@"密码不能为空", nil) message:nil duration:1];
		return;
	}
	
	if (![_kNewPasswordTextField.text isEqualToString:_kNewPasswordConfirmTextField.text]) {
		[self displayHUDTitle:NSLocalizedString(@"新密码两次输入不同", nil) message:nil duration:1];
		return;
	}
	
	[self displayHUD:NSLocalizedString(@"修改中...", nil)];
	[[FDAFHTTPClient shared] changePassword:_kNewPasswordTextField.text newPasswordConfirm:_kNewPasswordConfirmTextField.text oldPassword:_oldPasswordTextField.text withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			[self displayHUDTitle:NSLocalizedString(@"成功", nil) message:NSLocalizedString(@"新密码设置成功，以后请用新密码登录", nil)];
			[self performSelector:@selector(backOrClose) withObject:nil afterDelay:2];
		} else {
			[self displayHUDTitle:NSLocalizedString(@"失败", nil) message:message];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier;
	Class class;
	UIReturnKeyType returnKeyType;
	NSString *text;
	NSString *placeholder;
	if (indexPath.row == kIndexRowOfOldPassword) {
		identifier = @"oldPasswordCellIdentifier";
		class = [FDIdentityPasswordCell class];
		returnKeyType = UIReturnKeyNext;
		text = NSLocalizedString(@"旧密码", nil);
		placeholder = NSLocalizedString(@"旧密码", nil);
	} else if (indexPath.row == kIndexRowOfNewPassword) {
		identifier = @"newPasswordCellIdentifier";
		class = [FDIdentityPasswordCell class];
		returnKeyType = UIReturnKeyNext;
		text = NSLocalizedString(@"新密码", nil);
		placeholder = NSLocalizedString(@"请填写新密码", nil);
	} else {
		identifier = @"newPasswordConfirmCellIdentifier";
		class = [FDIdentityPasswordConfirmCell class];
		returnKeyType = UIReturnKeyDone;
		text = NSLocalizedString(@"确认", nil);
		placeholder = NSLocalizedString(@"再次填写新密码", nil);
	}
	FDIdentityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.inputField.delegate = self;
		cell.inputField.placeholder = placeholder;
		CGRect frame = cell.inputField.frame;
		frame.origin.x += 20;
		frame.size.width -= 20;
		cell.inputField.frame = frame;
		cell.inputField.enablesReturnKeyAutomatically = YES;
	}
	if (indexPath.row == kIndexRowOfOldPassword) _oldPasswordTextField = cell.inputField;
	else if (indexPath.row == kIndexRowOfNewPassword) _kNewPasswordTextField = cell.inputField;
	else _kNewPasswordConfirmTextField = cell.inputField;
	cell.textLabel.text = text;
	cell.inputField.returnKeyType = returnKeyType;
	cell.tag = indexPath.row;
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([textField.text areAllCharactersSpace]) return NO;
	if (textField == _oldPasswordTextField) {
		[_kNewPasswordTextField becomeFirstResponder];
	} else if (textField == _kNewPasswordTextField) {
		[_kNewPasswordConfirmTextField becomeFirstResponder];
	} else if (textField == _kNewPasswordConfirmTextField){
		[self changePassword];
	}
	return YES;
}

@end
