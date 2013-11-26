//
//  FDAddress.m
//  find
//
//  Created by zhangbin on 11/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAddress.h"

@implementation FDAddress

+ (instancetype)createWithAttributes:(NSDictionary *)attributes
{
	FDAddress *address = [[FDAddress alloc] init];
	address.addr = attributes[@"addr"];
	if (attributes[@"lat"] && attributes[@"lng"]) {
		address.location = [[CLLocation alloc] initWithLatitude:[attributes[@"lat"] doubleValue] longitude:[attributes[@"lng"] doubleValue]];
	}
	return address;
}

@end
