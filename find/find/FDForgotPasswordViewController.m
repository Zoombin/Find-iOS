//
//  FDForgotPasswordViewController.m
//  find
//
//  Created by zhangbin on 12/24/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDForgotPasswordViewController.h"

@interface FDForgotPasswordViewController ()

@end

@implementation FDForgotPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"找回密码", nil);
		self.view.backgroundColor = [UIColor randomColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
