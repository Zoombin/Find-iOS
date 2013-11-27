//
//  FDSettingsViewController.m
//  find
//
//  Created by zhangbin on 11/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDSettingsViewController.h"

@interface FDSettingsViewController ()

@end

@implementation FDSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
