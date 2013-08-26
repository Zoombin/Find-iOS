//
//  FDAppDelegate+Appearance.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAppDelegate+Appearance.h"
#import "RSTabBarViewController.h"

@implementation FDAppDelegate (Appearance)

- (void)customizeAppearance
{
#pragma mark RSTabBar Appearance
	id appearance = [RSTabBar appearance];
	
	[appearance setTabBarHeight:49];
	//[appearance setBorderBackgroundColor:[UIColor colorWithHexWhite:0xcf]];
	//CGSize buttonSize = CGSizeMake(106, 49);
	//UIImage *gradientImage = [UIImage imageFromColor:[UIColor colorWithHexWhite:0xff] toColor:[UIColor colorWithHexWhite:0xf2] size:buttonSize cornerRadius:0];
	//[appearance setBackgroundImage:gradientImage forButtonState:UIControlStateNormal];
	
//	//gradientImage = [UIImage imageFromSize:buttonSize block:^(CGContextRef context) {
//		CGRect rect = (CGRect){.size = buttonSize};
//		CGContextClip(context);
//		CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
//		CGContextFillRect(context, rect);
//		//UIImage *gradientVImage = [UIImage imageFromColors:@[
//															 [UIColor colorWithWhite:0 alpha:.02], [UIColor clearColor],
//															 [UIColor clearColor], [UIColor colorWithWhite:0 alpha:.1]]
//										 verticalLocations:@[@0, @.1, @.9, @1] size:buttonSize cornerRadius:0];
//		
//		//UIImage *gradientHImage = [UIImage imageFromColors:@[
//															 [UIColor colorWithWhite:0 alpha:.1], [UIColor clearColor],
//															 [UIColor clearColor], [UIColor colorWithWhite:0 alpha:.1]]
//									   horizontalLocations:@[@0, @.02, @.98, @1] size:buttonSize cornerRadius:0];
//		CGContextDrawImage(context, rect, gradientHImage.CGImage);
//		CGContextDrawImage(context, rect, gradientVImage.CGImage);
//	}];
	
	//[appearance setBackgroundImage:gradientImage forButtonState:UIControlStateSelected];
	//[appearance setOffsetBetweenIconAndText:UIOffsetMake(0, 5)];
	
	//[appearance setTitleAttributes:@{
	//								NSFontAttributeName: [UIFont applicationFontOfSize:12],
	//								 NSForegroundColorAttributeName: [UIColor lightGrayColor]
	//								 } forButtonState:UIControlStateNormal];
	//[appearance setTitleAttributes:@{
	//								 NSFontAttributeName: [UIFont applicationFontOfSize:12],
	//								 NSForegroundColorAttributeName: [UIColor colorWithHexRGB:0xfca032]
	//								 } forButtonState:UIControlStateSelected];
	
#pragma mark UINavigationBar Appearance
	appearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
	[appearance setTitleTextAttributes:@{ UITextAttributeFont : [UIFont systemFontOfSize:16],
										  UITextAttributeTextColor : [UIColor orangeColor],
										  } forState:UIControlStateNormal];
	//[appearance setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	
	appearance = [UINavigationBar appearance];
	
	//[appearance setBackgroundImage:[UIImage imageNamed:@"navigationBar_background"] forBarMetrics:UIBarMetricsDefault];
	//[appearance setTitleTextAttributes:@{
	//									 UITextAttributeFont: [UIFont demiBoldApplicationFontOfSize:16],
	//									 UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]}];
}

@end
