//
//  NSString+Find.m
//  find
//
//  Created by zhangbin on 11/27/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "NSString+Find.h"

@implementation NSString (Find)

+ (instancetype)avatarPathWithUserID:(NSNumber *)userID
{
	NSAssert(userID, @"UserID can not be nil!");
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
	return [NSString stringWithFormat:@"avatar_%@_%@.png", userID, [dateFormatter stringFromDate:date]];
}

@end
