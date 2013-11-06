//
//  FDVote+Test.m
//  find
//
//  Created by zhangbin on 11/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDVote+Test.h"

@implementation FDVote (Test)

+ (NSArray *)createTest:(NSUInteger)count
{
	NSMutableArray *users = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		[users addObject:[self createTestOne]];
	}
	return users;
}

+ (instancetype)createTestOne
{
	FDVote *vote = [[FDVote alloc] init];
	vote.ID = @1;
	vote.name = @"萌妹纸";
	vote.percentage = @(0.3);
	vote.quantity = @(11);
	vote.voted = @(NO);
	return vote;
}

@end
