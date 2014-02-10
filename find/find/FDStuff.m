//
//  FDStuff.m
//  find
//
//  Created by zhangbin on 12/23/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDStuff.h"

@implementation FDStuff

+ (instancetype)createWithAttributes:(NSDictionary *)attributes
{
	FDStuff *stuff = [[FDStuff alloc] init];
	stuff.ID = attributes[@"id"];
	stuff.name = attributes[@"name"];
	stuff.iconPath = attributes[@"pic"];
	stuff.describe = attributes[@"intro"];
	stuff.quantity = attributes[@"num"];
	stuff.detailsURLString = @"http://www.baidu.com";//TODO: test
	
	NSDictionary *priceAttributes = attributes[@"price"];
	if (priceAttributes) {
		stuff.price = [FDPrice createWithAttributes:priceAttributes];
		if (!stuff.price.bRMB.boolValue) {
			stuff.bReal = @(YES);
		}
	}
	return stuff;
}

+ (NSArray *)createMutableWithData:(NSArray *)data
{
	NSMutableArray *stuffs = [NSMutableArray array];
	for (NSDictionary *attributes in data) {
		[stuffs addObject:[self createWithAttributes:attributes]];
	}
	return stuffs;
}

@end
