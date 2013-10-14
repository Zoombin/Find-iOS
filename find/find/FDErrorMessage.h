//
//  FDErrorMessage.h
//  find
//
//  Created by zhangbin on 10/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYSTEM_ERROR 1001
#define USERNAME_EMPTY 2001
#define PASSWORD_EMPTY 2002
#define USER_DONOT_EXISTS 2003
#define PASSWORD_WRONG 2004
#define USER_EXISTS 2005
#define USERNAME_ERROR 2006
#define CANNOT_FOLLOW_SELF 2007
#define PHOTO_DONOT_EXISTS 3001
#define CONTENT_EMPTY 3002
#define DOLIKE 10
#define DOUNLIKE 11
#define TAG_DONOT_EXISTS 4001

@interface FDErrorMessage : NSObject

+ (NSString *)messageFromData:(id)msgData;
+ (NSString *)messageNetworkError;

@end
