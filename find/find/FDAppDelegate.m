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
	NSString *string = @" ";
	NSLog(@"%d", [string areAllCharactersSpace]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self test];
	
	[self umengTrack];
	[WXApi registerApp:@"wx5d8e3647ea5ebc6b" withDescription:@"demo 2.0"];
	[self jpush:launchOptions];
	
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
//	[viewControllers addObject:[FDTestAccountsViewController new]];
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
	[application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	[application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}

#pragma mark - UMeng

- (void)umengTrack
{
	[MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    //[MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
	//reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
	//channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
	//[MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
	//[MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    [MobClick updateOnlineConfig];  //在线参数配置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

#pragma mark - JPush

- (void)jpush:(NSDictionary *)launchOptions
{
	NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kAPNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kAPNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kAPNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kAPNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:launchOptions];
    [APService setTags:[NSSet setWithObjects:@"tag4",@"tag5",@"tag6",nil] alias:@"别名" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}

- (void)networkDidSetup:(NSNotification *)notification
{
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification
{
    NSLog(@"未连接。。。");
}

- (void)networkDidRegister:(NSNotification *)notification
{
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification
{
    NSLog(@"已登录");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
	NSLog(@"收到消息\ndate:%@\ntitle:%@\ncontent:%@", [dateFormatter stringFromDate:[NSDate date]], title, content);
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


@end
