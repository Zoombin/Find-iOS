//
//  FDUser+Test.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDUser+Test.h"

@implementation FDUser (Test)

+ (NSArray *)createTest:(NSUInteger)count
{
	NSMutableArray *users = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		[users addObject:[self createTestOne]];
	}
	return users;
}

+ (FDUser *)createTestOne
{
	FDUser *user = [[FDUser alloc] init];
	user.photos = [FDPhoto createTest:100];
	return user;
}

@end
