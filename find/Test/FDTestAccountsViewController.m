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
	UITextField *account;
	UITextField *password;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"Accounts";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CGFloat startY = 100;
	CGFloat gap = 10;
	
	CGSize fullSize = self.view.bounds.size;
	
	account = [[UITextField alloc] initWithFrame:CGRectMake(gap, startY, fullSize.width - 2 * gap, 40)];
	account.placeholder = @"帐号";
	account.backgroundColor = [UIColor grayColor];
	account.textColor = [UIColor whiteColor];
	[self.view addSubview:account];
	
	startY = CGRectGetMaxY(account.frame) + gap;
	
	password = [[UITextField alloc] initWithFrame:CGRectMake(gap, startY, fullSize.width - 2 * gap, 40)];
	password.placeholder = @"密码";
	password.backgroundColor = [UIColor grayColor];
	password.textColor = [UIColor whiteColor];
	[self.view addSubview:password];

	startY = CGRectGetMaxY(password.frame) + gap;
	
	UIButton *signup = [UIButton buttonWithType:UIButtonTypeCustom];
	[signup setTitle:@"注册" forState:UIControlStateNormal];
	signup.frame = CGRectMake(fullSize.width - gap - 60, startY, 60, 40);
	signup.backgroundColor = [UIColor grayColor];
	[signup addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:signup];
	
	
}

- (void)signup
{
	if (!account.text || [account.text isEqualToString:@""] || !password.text || [password.text isEqualToString:@""]) {
		return;
	}
	
	[self displayHUD:@"注册中..."];
	[[FDAFHTTPClient shared] signupAtLocation:[CLLocation fakeLocation] username:account.text password:password.text withCompletionBlock:^(BOOL success, NSString *message) {
		[self hideHUD:YES];
		account.text = nil;
		password.text = nil;
		if (success) {
			[self displayHUDTitle:@"注册成功" message:nil];
			
			
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
