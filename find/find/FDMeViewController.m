//
//  FDFifthViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDMeViewController.h"
#import "FDSignupViewController.h"

@interface FDMeViewController ()

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
	// Do any additional setup after loading the view.
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

@end
