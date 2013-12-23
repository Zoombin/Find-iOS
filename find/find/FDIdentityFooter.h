//
//  FDIdentityFooter.h
//  find
//
//  Created by zhangbin on 12/23/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDIentityFooterDelegate <NSObject>

- (void)forgotPasswordTapped;
- (void)gotoSigninTapped;

@end

@interface FDIdentityFooter : UIView

@property (nonatomic, weak) id<FDIentityFooterDelegate> delegate;

+ (CGFloat)height;

@end
