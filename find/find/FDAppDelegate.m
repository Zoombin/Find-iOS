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
#import "FDAlbumViewController.h"
#import "FDMeViewController.h"
#import "FDAppDelegate+Appearance.h"

@import iAd.ADBannerView;

@interface FDAppDelegate ()

@property (readwrite) UITabBarController *tabBarController;

@end

@implementation FDAppDelegate

- (void)test
{
//	NSNumber *number = @(1379575567);//2013-09-19 15:26 = 1379575567
//	NSLog(@"number: %@", [number printableTimestamp]);

//	[[FDAFHTTPClient shared] followOrUnfollowUser:@(1) withCompletionBlock:^(BOOL success, NSString *message, NSNumber *followed) {
//		if (success) {
//			NSLog(@"followed: %@", followed);
//		}
//	}];
	
//	[[FDAFHTTPClient shared] sendPrivateMessage:@"test" toUser:@(1) withCompletionBlock:^(BOOL success, NSString *message) {
//		if (success) {
//			NSLog(@"Private message send successfully!");
//		}
//	}];
	
	//[[FDAFHTTPClient shared] test];
	
//	NSDictionary *data = @{@"qq" : @(30135878), @"mobile" : @(18662606288), @"weixin" : @"archer", @"address" : @"国际科技园"};
//	NSDictionary *privacy = @{@"qq" : @(1), @"mobile" : @(2), @"weixin" : @(0), @"address" : @(1)};
//	NSArray *informations = [FDInformation createMutableWithData:data andPrivacy:privacy];
//	NSLog(@"informations: %@", informations);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
		[application setStatusBarStyle:UIStatusBarStyleLightContent];
	} else {
		[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	}
	[self customizeAppearance];
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0f];
	
	NSMutableArray *viewControllers = [NSMutableArray array];
	[viewControllers addObject:[FDDiscoveryViewController new]];
	[viewControllers addObject:[FDAroundViewController new]];
	[viewControllers addObject:[FDAlbumViewController new]];
	[viewControllers addObject:[FDMeViewController new]];
	[viewControllers addObject:[FDTestAccountsViewController new]];
//	[viewControllers addObject:[FDHostViewController new]];
//	[viewControllers addObject:[FDTestPhotoUploadViewController new]];
	
	NSMutableArray *navigationControllers = [NSMutableArray array];
	for (UIViewController *viewController in viewControllers) {
		[navigationControllers addObject:[[UINavigationController alloc] initWithRootViewController:viewController]];
	}
	
	_tabBarController = [[UITabBarController alloc] init];
	_tabBarController.viewControllers = navigationControllers;
	_tabBarController.selectedIndex = 0;
	
	self.window.rootViewController = _tabBarController;
	[self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	NSLog(@"url: %@", url);
	NSLog(@"urlstring: %@", url.absoluteString);
	NSLog(@"sourceApplication: %@", sourceApplication);
	NSLog(@"annotation: %@", annotation);
	//[self parse:url application:application];
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
