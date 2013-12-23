//
//  NSString+Find.h
//  find
//
//  Created by zhangbin on 11/27/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FDPrivatizeStyle) {
	FDPrivatizeStyleHideAll,
	FDPrivatizeStyleHideHeader,
	FDPrivatizeStyleHideMiddle,
	FDPrivatizeStyleHideTail
};

@interface NSString (Find)

+ (instancetype)photoPathWithUserID:(NSNumber *)userID;
+ (instancetype)avatarPathWithUserID:(NSNumber *)userID;
+ (instancetype)randomDigitalStringOfLength:(NSUInteger)length;
- (BOOL)interestingPlace;
- (instancetype)privatizeWithStyle:(FDPrivatizeStyle)style;
+ (instancetype)generateAlipayTradeNO;

@end
