//
//  FDUser.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDUser.h"

@implementation FDUser

+ (instancetype)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"mid"], @"UserID shouldn't be nil");
	FDUser *user = [[FDUser alloc] init];
	user.ID = attributes[@"mid"];
	user.name = attributes[@"username"];
	return user;
}

+ (NSArray *)createMutableWithData:(NSArray *)data
{
	NSMutableArray *users = [NSMutableArray array];
	for (NSDictionary *attributes in data) {
		[users addObject:[self createWithAttributes:attributes]];
	}
	return users;
}

- (FDPhoto *)mainPhoto
{
	if (_photos.count) {
		return _photos[0];
	}
	return nil;
}

@end
