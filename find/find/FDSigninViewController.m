//
//  FDSigninViewController.m
//  find
//
//  Created by zhangbin on 9/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDSigninViewController.h"
#import "FDIdentityAccountCell.h"
#import "FDIdentityPasswordCell.h"
#import "FDIdentityPasswordConfirmCell.h"
#import "FDIdentityFooter.h"
#import "FDForgotPasswordViewController.h"

#define kIndexRowOfAccount 0
#define kIndexRowOfPassword 1

@interface FDSigninViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, FDIentityFooterDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) UITextField *accountTextField;
@property (readwrite) UITextField *passwordTextField;

@end

@implementation FDSigninViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"登录", nil);
		[self setLeftBarButtonItemAsBackButton];
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
	if ([_accountTextField.text isEqualToString:@""]) {
		[_accountTextField becomeFirstResponder];
	} else {
		[_passwordTextField becomeFirstResponder];
	}
}

- (void)signin
{
	if (_accountTextField.text == nil || _passwordTextField.text == nil || [_accountTextField.text areAllCharactersSpace] || [_passwordTextField.text areAllCharactersSpace]) {
		[self displayHUDTitle:NSLocalizedString(@"请填写登录信息", nil) message:nil duration:1];
		return;
	}
	
	[self displayHUD:NSLocalizedString(@"登录中...", nil)];
	[[FDAFHTTPClient shared] signinAtLocation:nil username:_accountTextField.text password:_passwordTextField.text withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			[self displayHUD:NSLocalizedString(@"登录成功", nil)];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
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
	return [FDIdentityFooter height];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	FDIdentityFooter *footer = [[FDIdentityFooter alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [FDIdentityFooter height])];
	footer.gotoSigninButton.hidden = YES;
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
		[self signin];
	}
	return YES;
}

#pragma mark - FDIdentityFooterDelegate

- (void)forgotPasswordTapped
{
	FDForgotPasswordViewController *forgotPasswordViewController = [[FDForgotPasswordViewController alloc] init];
	[self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}

@end
