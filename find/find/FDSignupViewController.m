//
//  FDSignupViewController.m
//  find
//
//  Created by zhangbin on 9/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDSignupViewController.h"
#import "FDSigninViewController.h"
#import "FDIdentityAccountCell.h"
#import "FDIdentityPasswordCell.h"
#import "FDIdentityPasswordConfirmCell.h"
#import "FDIdentityFooter.h"

#define kIndexRowOfAccount 0
#define kIndexRowOfPassword 1
#define kIndexRowOfPasswordConfirm 2

@interface FDSignupViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, FDIentityFooterDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) UITextField *accountTextField;
@property (readwrite) UITextField *passwordTextField;
@property (readwrite) UITextField *passwordConfirmTextField;

@end

@implementation FDSignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor grayColor];
		self.title = NSLocalizedString(@"注册", nil);
		[self setLeftBarButtonItemAsBackButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if ([_accountTextField.text isEqualToString:@""]) {
		[_accountTextField becomeFirstResponder];
	} else if ([_passwordTextField.text isEqualToString:@""]) {
		[_passwordTextField becomeFirstResponder];
	} else {
		[_passwordConfirmTextField becomeFirstResponder];
	}
}

- (void)signup
{
	if (_accountTextField.text == nil || _passwordTextField.text == nil || _passwordConfirmTextField.text == nil || [_accountTextField.text areAllCharactersSpace] || [_passwordTextField.text areAllCharactersSpace] || [_passwordConfirmTextField.text areAllCharactersSpace]) {
		[self displayHUDTitle:NSLocalizedString(@"注册信息不能为空", nil) message:nil duration:1];
		return;
	}
	
	if (![_passwordTextField.text isEqualToString:_passwordConfirmTextField.text]) {
		[self displayHUDTitle:NSLocalizedString(@"两次输入密码不同", nil) message:nil duration:1];
		return;
	}
	
	[self displayHUD:NSLocalizedString(@"注册中...", nil)];
	[[FDAFHTTPClient shared] signupAtLocation:nil username:_accountTextField.text password:_passwordTextField.text withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			[self displayHUD:NSLocalizedString(@"注册成功", nil)];
			[self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
			[[NSNotificationCenter defaultCenter] postNotificationName:ME_PROFILE_NEED_REFRESH_NOTIFICATION_IDENTIFIER object:nil];
		} else {
			[self displayHUDTitle:NSLocalizedString(@"错误", nil) message:message duration:3];
		}
	}];
}

- (void)dismiss
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier;
	Class class;
	UIReturnKeyType returnKeyType;
	if (indexPath.row == kIndexRowOfAccount) {
		identifier = kFDIdentityAccountCellIdentifier;
		class = [FDIdentityAccountCell class];
		returnKeyType = UIReturnKeyNext;
	} else if (indexPath.row == kIndexRowOfPassword) {
		identifier = kFDIdentityPasswordCellIdentifier;
		class = [FDIdentityPasswordCell class];
		returnKeyType = UIReturnKeyNext;
	} else {
		identifier = kFDIdentityPasswordConfirmCellIdentifier;
		class = [FDIdentityPasswordConfirmCell class];
		returnKeyType = UIReturnKeyJoin;
	}
	FDIdentityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.inputField.delegate = self;
		cell.inputField.enablesReturnKeyAutomatically = YES;
	}
	if (indexPath.row == kIndexRowOfAccount) _accountTextField = cell.inputField;
	else if (indexPath.row == kIndexRowOfPassword) _passwordTextField = cell.inputField;
	else _passwordConfirmTextField = cell.inputField;
	cell.inputField.returnKeyType = returnKeyType;
	cell.tag = indexPath.row;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return [FDIdentityFooter height];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	FDIdentityFooter *footer = [[FDIdentityFooter alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [FDIdentityFooter height])];
	footer.forgotPasswordButton.hidden = YES;
	footer.delegate = self;
	return footer;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([textField.text areAllCharactersSpace]) return NO;
	if (textField == _accountTextField) {
		[_passwordTextField becomeFirstResponder];
	} else if (textField == _passwordTextField) {
		[_passwordConfirmTextField becomeFirstResponder];
	} else if (textField == _passwordConfirmTextField){
		[self signup];
	}
	return YES;
}

#pragma mark - FDIdentityFooterDelegate

- (void)gotoSigninTapped
{
	FDSigninViewController *signinViewController = [[FDSigninViewController alloc] init];
	[self.navigationController pushViewController:signinViewController animated:YES];
}

@end
