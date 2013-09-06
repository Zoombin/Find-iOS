//
//  FDAppDelegate.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAppDelegate.h"
#import "RSTabBarViewController.h"
#import "FDNearbyViewController.h"
#import "FDDiscoveryViewController.h"
#import "FDHostViewController.h"
#import "FDCameraViewController.h"
#import "FDMeViewController.h"

@implementation FDAppDelegate
{
	UITabBarController *tabBarController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
		
	UINavigationController *firstViewController = [[UINavigationController alloc] initWithRootViewController:[[FDDiscoveryViewController alloc] init]];
#ifdef FDDEBUG
	UINavigationController *secondViewController = [[UINavigationController alloc] initWithRootViewController:[[FDTestPhotoUploadViewController alloc] init]];
#else
	
	UINavigationController *secondViewController = [[UINavigationController alloc] initWithRootViewController:[[FDNearbyViewController alloc] init]];
#endif
	UINavigationController *thirdViewController = [[UINavigationController alloc] initWithRootViewController:[[FDHostViewController alloc] init]];
	UINavigationController *forthViewController = [[UINavigationController alloc] initWithRootViewController:[[FDCameraViewController alloc] init]];
	UINavigationController *fifthViewController = [[UINavigationController alloc] initWithRootViewController:[[FDMeViewController alloc] init]];
	
	UINavigationController *sixthViewController = [[UINavigationController alloc] initWithRootViewController:[[FDDiscoveryViewController alloc] init]];
	
	tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers = @[firstViewController, secondViewController, thirdViewController, forthViewController, fifthViewController, sixthViewController];
	tabBarController.selectedIndex = 0;
	
	self.window.rootViewController = tabBarController;
	
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
