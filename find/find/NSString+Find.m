//
//  NSString+Find.m
//  find
//
//  Created by zhangbin on 11/27/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "NSString+Find.h"

@implementation NSString (Find)

+ (instancetype)photoPathWithUserID:(NSNumber *)userID
{
	NSAssert(userID, @"UserID can not be nil!");
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
	return [NSString stringWithFormat:@"photo-%@-%@-%@.jpg", userID, [dateFormatter stringFromDate:date], [self randomDigitalStringOfLength:4]];
}

+ (instancetype)avatarPathWithUserID:(NSNumber *)userID
{
	NSAssert(userID, @"UserID can not be nil!");
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
	return [NSString stringWithFormat:@"avatar-%@-%@-%@.png", userID, [dateFormatter stringFromDate:date], [self randomDigitalStringOfLength:4]];
}

+ (instancetype)randomDigitalStringOfLength:(NSUInteger)length
{
	NSMutableString *randomDigitalString = [NSMutableString stringWithString:@""];
	for (int i = 0; i < length; i++) {
		[randomDigitalString appendString:[NSString stringWithFormat:@"%d", arc4random() % 9]];
	}
	return randomDigitalString;
}

- (BOOL)interestingPlace
{
	BOOL interesting = NO;
	static NSArray *interestingPlaces;
	if (!interestingPlaces) {
		interestingPlaces = @[@"酒吧", @"ktv", @"会所", @"娱乐", @"桑拿", @"温泉", @"按摩", @"足浴", @"美容", @"贵宾"];
	}
	NSRange range;
	for (NSString *place in interestingPlaces) {
		range = [self.lowercaseString rangeOfString:place];
		if (range.location != NSNotFound) {
			interesting = YES;
			break;
		}
	}
	return interesting;
}

- (instancetype)privatizeWithStyle:(FDPrivatizeStyle)style
{
	if (self.length == 0) {
		return self;
	}
	NSMutableString *privatized = [NSMutableString stringWithString:self];
	NSUInteger length = 0;
	if (style == FDPrivatizeStyleHideAll) {
		length = self.length;
		[privatized replaceCharactersInRange:NSMakeRange(0, length) withString:[self snowsWithLength:length]];
	} else if (style == FDPrivatizeStyleHideHeader) {
		if (self.length < 2) {
			length = 1;
		} else {
			length = self.length / 2;
		}
		[privatized replaceCharactersInRange:NSMakeRange(0, length) withString:[self snowsWithLength:length]];
	} else if (style == FDPrivatizeStyleHideMiddle) {
		if (self.length < 3) {
			return [self privatizeWithStyle:FDPrivatizeStyleHideHeader];
		} else {
			length = self.length - ((self.length / 3) * 2);
			[privatized replaceCharactersInRange:NSMakeRange((self.length / 3), length) withString:[self snowsWithLength:length]];
		}
	} else if (style == FDPrivatizeStyleHideTail) {
		if (self.length < 2) {
			length = 1;
		} else {
			length = self.length / 2;
		}
		[privatized replaceCharactersInRange:NSMakeRange(self.length - length, length) withString:[self snowsWithLength:length]];
	}
	return privatized;
}

- (instancetype)snowsWithLength:(NSUInteger)length
{
	static NSString *snow = @"*";
	NSMutableString *snows = [NSMutableString stringWithFormat:@""];
	for (int i = 0; i < length; i++) {
		[snows appendString:snow];
	}
	return snows;
}

//生成alipay订单号，时间+随机码+ios+alipay
+ (instancetype)generateAlipayTradeNO
{
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
	return [NSString stringWithFormat:@"%@-%@-%@-%@", [dateFormatter stringFromDate:date], [self randomDigitalStringOfLength:4], @"ios", @"alipay"];
}

@end
