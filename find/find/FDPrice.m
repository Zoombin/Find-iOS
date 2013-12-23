//
//  FDPrice.m
//  find
//
//  Created by zhangbin on 12/23/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPrice.h"

@implementation FDPrice

+ (instancetype)createWithAttributes:(NSDictionary *)attributes
{
	FDPrice *price = [[FDPrice alloc] init];
	price.RMB = attributes[@"ios"];
	if (price.RMB) {
		price.bRMB = @(YES);
	}
	price.flowers = attributes[@"flowers"];
	price.diamonds = attributes[@"diamonds"];
	return price;
}

- (NSString *)printablePrice
{
	if (_bRMB) {
		return [_RMB printableRMB];
	}
	return [NSString stringWithFormat:@"%d钻石\n%d鲜花", _diamonds.integerValue, _flowers.integerValue];
}

@end
