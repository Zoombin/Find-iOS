//
//  NSString+ZBQNUtilities.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "NSString+ZBQNUtilities.h"

@implementation NSString (ZBQNUtilities)

- (NSString *)scaleToFit:(CGSize)size
{
	return [NSString stringWithFormat:@"%@?imageView/1/w/%d/h/%d", self, (NSUInteger)size.width, (NSUInteger)size.height];
}

@end
