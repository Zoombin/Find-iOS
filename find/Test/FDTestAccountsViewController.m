//
//  FDTestAccountsViewController.m
//  find
//
//  Created by zhangbin on 10/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDTestAccountsViewController.h"

@interface FDTestAccountsViewController ()

@end

@implementation FDTestAccountsViewController
{
	UITextField *accountTextField;
	UITextField *passwordTextField;
	NSDictionary *accountsAndPassword;
	UILabel *currentAccountLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"帐号", nil);
		accountsAndPassword = @{@"30135878@qq.com": @"111111", @"001@test.com": @"111111", @"003@test.com" : @"qweqwe"};
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	CGFloat startY = 100;
	if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
		startY -= 64;
	}
	CGFloat gap = 10;
	CGSize fullSize = self.view.bounds.size;
	
	accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(gap, startY, fullSize.width - 2 * gap, 40)];
	accountTextField.placeholder = @"帐号";
	accountTextField.backgroundColor = [UIColor grayColor];
	accountTextField.textColor = [UIColor whiteColor];
	[self.view addSubview:accountTextField];
	
	startY = CGRectGetMaxY(accountTextField.frame) + gap;
	
	passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(gap, startY, fullSize.width - 2 * gap, 40)];
	passwordTextField.placeholder = @"密码";
	passwordTextField.backgroundColor = [UIColor grayColor];
	passwordTextField.textColor = [UIColor whiteColor];
	[self.view addSubview:passwordTextField];

	startY = CGRectGetMaxY(passwordTextField.frame) + gap;
	
	UIButton *signup = [UIButton buttonWithType:UIButtonTypeCustom];
	[signup setTitle:@"注册" forState:UIControlStateNormal];
	signup.frame = CGRectMake(fullSize.width - gap - 60, startY, 60, 40);
	signup.backgroundColor = [UIColor grayColor];
	[signup addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:signup];
	
	startY = CGRectGetMaxY(signup.frame) + gap;
	
	CGSize userButtonSize = CGSizeMake(90, 40);
	
	NSArray *accounts = [accountsAndPassword allKeys];
	
	UIButton *user = [UIButton buttonWithType:UIButtonTypeCustom];
	user.frame = CGRectMake(gap, startY, userButtonSize.width, userButtonSize.height);
	[user setTitle:accounts[0] forState:UIControlStateNormal];
	user.titleLabel.adjustsFontSizeToFitWidth = YES;
	[user setBackgroundColor:[UIColor grayColor]];
	[user addTarget:self action:@selector(signin:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:user];
	
	UIButton *user2 = [UIButton buttonWithType:UIButtonTypeCustom];
	user2.frame = CGRectMake(CGRectGetMaxX(user.frame) + gap, startY, userButtonSize.width, userButtonSize.height);
	[user2 setTitle:accounts[1] forState:UIControlStateNormal];
	user2.titleLabel.adjustsFontSizeToFitWidth = YES;
	[user2 setBackgroundColor:[UIColor grayColor]];
	[user2 addTarget:self action:@selector(signin:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:user2];
	
	UIButton *user3 = [UIButton buttonWithType:UIButtonTypeCustom];
	user3.frame = CGRectMake(CGRectGetMaxX(user2.frame) + gap, startY, userButtonSize.width, userButtonSize.height);
	[user3 setTitle:accounts[2] forState:UIControlStateNormal];
	user3.titleLabel.adjustsFontSizeToFitWidth = YES;
	[user3 setBackgroundColor:[UIColor grayColor]];
	[user3 addTarget:self action:@selector(signin:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:user3];
	
	startY = CGRectGetMaxY(user3.frame) + gap;
	
	currentAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(gap, startY, fullSize.width - 2 * gap, 40)];
	currentAccountLabel.backgroundColor = [UIColor clearColor];
	currentAccountLabel.textColor = [UIColor blackColor];
	[self.view addSubview:currentAccountLabel];
	
	[self displayCurrentAccount];
}

- (void)displayCurrentAccount
{
	NSString *str = [NSString stringWithFormat:@"Current account: %@", [[FDAFHTTPClient shared] account]];
	currentAccountLabel.text = str;
}

- (void)signin:(UIButton *)sender
{
	NSString *account = sender.titleLabel.text;
	NSString *password = accountsAndPassword[account];
	
	[self displayHUD:@"登录中..."];
	
	[[FDAFHTTPClient shared] signinAtLocation:[CLLocation fakeLocation] username:account password:password withCompletionBlock:^(BOOL success, NSString *message) {
		[self hideHUD:YES];
		if (success) {
			[self displayHUDTitle:@"登录成功" message:nil];
			[self displayCurrentAccount];
		} else {
			[self displayHUDTitle:@"登录失败" message:message];
		}
	}];
}

- (void)signup
{
	if (!accountTextField.text || [accountTextField.text isEqualToString:@""] || !passwordTextField.text || [passwordTextField.text isEqualToString:@""]) {
		return;
	}
	
	[self displayHUD:@"注册中..."];
	[[FDAFHTTPClient shared] signupAtLocation:[CLLocation fakeLocation] username:accountTextField.text password:passwordTextField.text withCompletionBlock:^(BOOL success, NSString *message) {
		[self hideHUD:YES];
		accountTextField.text = nil;
		passwordTextField.text = nil;
		if (success) {
			[self displayHUDTitle:@"注册成功" message:nil];
			[self displayCurrentAccount];
		} else {
			[self displayHUDTitle:@"注册失败" message:message];
		}
	}];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
