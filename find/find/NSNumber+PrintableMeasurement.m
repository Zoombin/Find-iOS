//
//  NSNumber+ReadableDistance.m
//  find
//
//  Created by zhangbin on 9/10/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "NSNumber+ReadableDistance.h"

@implementation NSNumber (PrintableMeasurement)

- (NSString *)readableDistance
{
//	if (self.integerValue < 10) {
//		return @"<10m";
//	} else if (self.integerValue < 100) {
//		return @"<100m";
//	} else
	if (self.integerValue < 1000) {
		return [NSString stringWithFormat:@"%dm", self.integerValue];
	} else if (self.integerValue < 10000) {
		return [NSString stringWithFormat:@"%.1fkm", self.floatValue / 1000];
	} else if (self.integerValue < 1000000) {
		return [NSString stringWithFormat:@"%.0fkm", self.floatValue / 1000];
	} else
		return @"千里之外";
}

@end
