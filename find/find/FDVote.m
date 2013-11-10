//
//  FDVote.m
//  find
//
//  Created by zhangbin on 11/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDVote.h"

@implementation FDVote

+ (instancetype)createWithAttributes:(NSDictionary *)attributes
{
	FDVote *vote = [[FDVote alloc] init];
	NSAssert(attributes[@"id"], @"A vote must have a id!");
	
	vote.ID = attributes[@"id"];
	vote.name = attributes[@"name"];
	vote.quantity = attributes[@"quantity"];
	vote.percentage = attributes[@"percentage"];
	vote.voted = attributes[@"choosed"];
	return vote;
}

+ (NSArray *)createMutableWithData:(NSArray *)data
{
	NSMutableArray *votes = [NSMutableArray array];
	for (NSDictionary *attributes in data) {
		FDVote *vote = [self createWithAttributes:attributes];
		[votes addObject:vote];
	}
	return votes;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<id: %@, name: %@>", _ID, _name];
}



@end
