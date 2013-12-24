//
//  FDIdentityFooter.h
//  find
//
//  Created by zhangbin on 12/23/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDIentityFooterDelegate <NSObject>

@optional
- (void)forgotPasswordTapped;
- (void)gotoSigninTapped;

@end

@interface FDIdentityFooter : UIView

@property (nonatomic, weak) id<FDIentityFooterDelegate> delegate;
@property (nonatomic, strong) UIButton *forgotPasswordButton;
@property (nonatomic, strong) UIButton *gotoSigninButton;

+ (CGFloat)height;

@end
