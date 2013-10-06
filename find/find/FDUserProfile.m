//
//  FDUserProfile.m
//  find
//
//  Created by zhangbin on 10/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDUserProfile.h"

@implementation FDUserProfile

+ (FDUserProfile *)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"A profile must have userID!");
	FDUserProfile *userProfile = [[FDUserProfile alloc] init];
//	userProfile.userID = attributes[@"id"];//TODO: id now is a string, should be a number
	userProfile.username = attributes[@"username"];
	//TODO: rest of variables
	return userProfile;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<profile: userID: %@, username: %@>", _userID, _username];
}

@end
