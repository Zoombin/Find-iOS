//
//  FDAdviseViewController.m
//  find
//
//  Created by zhangbin on 12/24/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAdviseViewController.h"

@interface FDAdviseViewController ()

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
