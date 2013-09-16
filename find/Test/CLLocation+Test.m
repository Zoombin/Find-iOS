//
//  CLLocation+Test.m
//  find
//
//  Created by zhangbin on 9/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "CLLocation+Test.h"

@implementation CLLocation (Test)

+ (CLLocation *)fakeLocation
{
	CLLocationDegrees baseLat = 31.298026;
	CLLocationDegrees baseLon = 120.666564;
	return [[CLLocation alloc] initWithLatitude:baseLat longitude:baseLon];
}

@end
