//
//  FDTweet.m
//  find
//
//  Created by zhangbin on 9/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDTweet.h"

@implementation FDTweet

+ (FDTweet *)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"A tweet must have an ID!");
	FDTweet *tweet = [[FDTweet alloc] init];
	tweet.ID = attributes[@"id"];
	tweet.userID = attributes[@"mid"];
	if (attributes[@"latitude"] && attributes[@"longitude"]) {
		tweet.location = [[CLLocation alloc] initWithLatitude:[attributes[@"latitude"] doubleValue] longitude:[attributes[@"longitude"] doubleValue]];
	}
	tweet.address = attributes[@"address"];
	tweet.signature = attributes[@"signature"];
	
	if (attributes[@"photos"]) {
		tweet.photos = [FDPhoto createMutableWithData:attributes[@"photos"]];
	}
	
	tweet.published = attributes[@"published"];
	tweet.publishday = attributes[@"publishday"];
	tweet.distance = attributes[@"distance"];
	return tweet;
}

+ (NSArray *)createMutableWithData:(NSArray *)data
{
	NSMutableArray *tweets = [NSMutableArray array];
	for (NSDictionary *attributes in data) {
		[tweets addObject:[self createWithAttributes:attributes]];
	}
	return tweets;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<ID: %@, userID: %@, address: %@, distance: %@>", _ID, _userID, _address, _distance];
}

@end
