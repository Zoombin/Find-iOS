//
//  FDAppDelegate.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAppDelegate.h"
#import "FDAroundViewController.h"
#import "FDDiscoveryViewController.h"
#import "FDHostViewController.h"
#import "FDCameraViewController.h"
#import "FDMeViewController.h"
#import "FDAppDelegate+Appearance.h"

@implementation FDAppDelegate
{
	UITabBarController *tabBarController;
}

- (void)test
{
//	NSNumber *number = @(1379575567);//2013-09-19 15:26 = 1379575567
//	NSLog(@"number: %@", [number printableTimestamp]);

	[[FDAFHTTPClient shared] test];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self test];
	
	[[FDAFHTTPClient shared] test];
	
	[self customizeAppearance];
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	
	NSMutableArray *viewControllers = [NSMutableArray array];
	[viewControllers addObject:[FDAroundViewController new]];
	[viewControllers addObject:[FDDiscoveryViewController new]];
	[viewControllers addObject:[FDTestPhotoUploadViewController new]];
	[viewControllers addObject:[FDTestAccountsViewController new]];
	[viewControllers addObject:[FDMeViewController new]];
	[viewControllers addObject:[FDCameraViewController new]];
	[viewControllers addObject:[FDHostViewController new]];

	NSMutableArray *naviControllers = [NSMutableArray array];
	for (UIViewController *viewController in viewControllers) {
		[naviControllers addObject:[[UINavigationController alloc] initWithRootViewController:viewController]];
	}
	
	tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers = naviControllers;
	tabBarController.selectedIndex = 0;
	
	self.window.rootViewController = tabBarController;
	
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		[application setStatusBarStyle:UIStatusBarStyleLightContent];
	} else {
		[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	}

	[self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
