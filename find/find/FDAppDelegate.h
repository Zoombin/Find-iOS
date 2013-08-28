//
//  FDAppDelegate.h
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP_DELEGATE ( (FDAppDelegate *)[[UIApplication sharedApplication] delegate] )

@interface FDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
