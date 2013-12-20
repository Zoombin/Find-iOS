//
//  FDAppDelegate+Appearance.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAppDelegate+Appearance.h"

@implementation FDAppDelegate (Appearance)

- (void)customizeAppearance
{
#pragma mark - UINavigationBar Appearance
	id appearance = [UINavigationBar appearance];
	if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
		[appearance setBackgroundImage:[UIImage imageFromColor:[UIColor fdThemeRed]] forBarMetrics:UIBarMetricsDefault];
	} else {
		[appearance setBarTintColor:[UIColor fdThemeRed]];
	}
	
	[appearance setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
	
#pragma mark - UITabBar Appearance
	appearance = [UITabBar appearance];
	if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
		[appearance setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor]]];
		[appearance setSelectionIndicatorImage:[[UIImage alloc] init]];
	} else {
		[appearance setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor]]];
		[appearance setSelectionIndicatorImage:[[UIImage alloc] init]];
	}

#pragma mark - UITabBarItem Appearance
	appearance = [UITabBarItem appearance];
	[appearance setTitleTextAttributes:@{UITextAttributeFont : [UIFont fdThemeFontOfSize:10], UITextAttributeTextColor : [UIColor fdThemeRed]} forState:UIControlStateNormal];
	
#pragma mark - UIBarButtonItem Appearance
	appearance = [UIBarButtonItem appearance];
	[appearance setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]} forState:UIControlStateNormal];
}

@end
