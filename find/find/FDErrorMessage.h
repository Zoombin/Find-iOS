//
//  FDErrorMessage.h
//  find
//
//  Created by zhangbin on 10/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger PHOTO_LIKE;
extern NSInteger FORBIDDEN;
extern NSInteger NEW_PASSWORD_EMPTY;
extern NSInteger AGAIN_PASSWORD_EMPTY;
extern NSInteger AGAIN_PASSWORD_WRONG;
extern NSInteger SYSTEM_ERROR;
extern NSInteger USERNAME_EMPTY;
extern NSInteger PASSWORD_EMPTY;
extern NSInteger USER_DONOT_EXISTS;
extern NSInteger PASSWORD_WRONG;
extern NSInteger USER_EXISTS;
extern NSInteger USERNAME_ERROR;
extern NSInteger CANNOT_FOLLOW_SELF;
extern NSInteger PHOTO_DONOT_EXISTS;
extern NSInteger CONTENT_EMPTY;
extern NSInteger CONTENT_FORBIDDEN;
extern NSInteger DOLIKE;
extern NSInteger DOUNLIKE;
extern NSInteger DOADD;
extern NSInteger DOREMOVE;
extern NSInteger DOFOLLOW;
extern NSInteger DOUNFOLLOW;
extern NSInteger TAG_DONOT_EXISTS;
extern NSInteger CATEGORY_DONOT_EXISTS;
extern NSInteger SHOP_SOLD_OUT;
extern NSInteger MONEY_NOT_ENOUGH;

@interface FDErrorMessage : NSObject

+ (NSString *)messageFromData:(id)msgData;
+ (NSString *)messageNetworkError;

@end
