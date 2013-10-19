//
//  UIFont+Find.m
//  find
//
//  Created by zhangbin on 10/14/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "UIFont+Find.h"

@implementation UIFont (Find)

+ (UIFont *)fdThemeFontOfSize:(CGFloat)size
{
	//return [UIFont fontWithName:@"FZBWKSJW--GB1-0" size:size];
	//return [UIFont fontWithName:@"YouYuan" size:size];
	return [UIFont systemFontOfSize:size];
}

+ (UIFont *)fdBoldThemeFontOfSize:(CGFloat)size
{
	return [UIFont boldSystemFontOfSize:size];
}

@end
