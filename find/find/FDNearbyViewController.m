//
//  FDFirstViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDNearbyViewController.h"

@interface FDNearbyViewController ()

@end

@implementation FDNearbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"First";
//		[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabAccountActive"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabAccount"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTitle:@"submit" forState:UIControlStateNormal];
	[button setBackgroundColor:[UIColor greenColor]];
	[button addTarget:self action:@selector(sumbit) forControlEvents:UIControlEventTouchUpInside];
	button.frame = CGRectMake(0, 100, 100, 100);
	[self.view addSubview:button];
}

- (void)sumbit
{
	NSString *fileName = @"3.jpg";
	NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:fileName], 1);
	
	[[ZBQNAFHTTPClient shared] uploadData:imageData name:fileName completionBlock:^(void) {
		NSLog(@"complete");
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
