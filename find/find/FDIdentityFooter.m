//
//  FDIdentityFooter.m
//  find
//
//  Created by zhangbin on 12/23/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDIdentityFooter.h"

@interface FDIdentityFooter ()

@property (readwrite) UIButton *forgotPasswordButton;
@property (readwrite) UIButton *gotoSigninButton;

@end

@implementation FDIdentityFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor randomColor];
		
		CGFloat buttonWidth = 100;
		CGFloat gap = 20;
		
		_forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
		//_forgotPasswordButton.backgroundColor = [UIColor randomColor];
		_forgotPasswordButton.frame = CGRectMake(gap, 0, buttonWidth, [self.class height]);
		[_forgotPasswordButton addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
		_forgotPasswordButton.showsTouchWhenHighlighted = YES;
		[_forgotPasswordButton setTitle:NSLocalizedString(@"忘记密码？", nil) forState:UIControlStateNormal];
		_forgotPasswordButton.titleLabel.font = [UIFont fdThemeFontOfSize:11];
		[_forgotPasswordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[self addSubview:_forgotPasswordButton];
		
		_gotoSigninButton = [UIButton buttonWithType:UIButtonTypeCustom];
		//_gotoSigninButton.backgroundColor = [UIColor randomColor];
		_gotoSigninButton.frame = CGRectMake(self.bounds.size.width - gap - buttonWidth, 0, buttonWidth, [self.class height]);
		_gotoSigninButton.titleLabel.textAlignment = NSTextAlignmentRight;
		_gotoSigninButton.showsTouchWhenHighlighted = YES;
		[_gotoSigninButton setTitle:NSLocalizedString(@"已经注册去登录", nil) forState:UIControlStateNormal];
		_gotoSigninButton.titleLabel.font = [UIFont fdThemeFontOfSize:11];
		[_gotoSigninButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[_gotoSigninButton addTarget:self action:@selector(gotoSignin) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_gotoSigninButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (CGFloat)height
{
	return 60;
}

- (void)forgotPassword
{
	[_delegate forgotPasswordTapped];
}

- (void)gotoSignin
{
	[_delegate gotoSigninTapped];
}


@end
