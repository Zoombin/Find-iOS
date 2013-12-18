//
//  FDThirdViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDHostViewController.h"

@interface FDHostViewController ()

@end

@implementation FDHostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"Host", nil);
		self.title = identifier;

		UIImage *normalImage = [UIImage imageNamed:@"Host"];
		UIImage *selectedImage = [UIImage imageNamed:@"HostHighlighted"];
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:normalImage selectedImage:selectedImage];
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:normalImage tag:0];
			[self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
		}
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
