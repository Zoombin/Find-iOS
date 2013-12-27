//
//  FDErrorMessage.m
//  find
//
//  Created by zhangbin on 10/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDErrorMessage.h"

NSInteger SYSTEM_ERROR = 1001;
NSInteger USERNAME_EMPTY = 2001;
NSInteger PASSWORD_EMPTY = 2002;
NSInteger USER_DONOT_EXISTS = 2003;
NSInteger PASSWORD_WRONG = 2004;
NSInteger USER_EXISTS = 2005;
NSInteger USERNAME_ERROR = 2006;
NSInteger CANNOT_FOLLOW_SELF = 2007;
NSInteger PHOTO_DONOT_EXISTS = 3001;
NSInteger CONTENT_EMPTY = 3002;
NSInteger TAG_DONOT_EXISTS = 4001;
NSInteger DOLIKE = 10;
NSInteger DOUNLIKE = 11;
NSInteger DOFOLLOW = 14;
NSInteger DOUNFOLLOW = 15;

@implementation FDErrorMessage

static NSDictionary *errorMessageMap;

+ (NSString *)messageFromData:(id)msgData
{
	if (!errorMessageMap) {
		errorMessageMap = @{@(SYSTEM_ERROR) : @"服务异常，请检测您的网络！",
							@(USERNAME_EMPTY) : @"用户名不能为空！",
							@(PASSWORD_EMPTY) : @"密码不能为空！",
							@(USER_DONOT_EXISTS) : @"用户不存在！",
							@(PASSWORD_WRONG) : @"密码错误！",
							@(USER_EXISTS) : @"用户已存在！",
							@(CANNOT_FOLLOW_SELF) : @"不能关注自己！",
							@(PHOTO_DONOT_EXISTS) : @"照片不存在！",
							@(CONTENT_EMPTY) : @"内容为空！",
							@(DOLIKE) : @"喜欢",
							@(DOUNLIKE) : @"不喜欢",
							@(TAG_DONOT_EXISTS) : @"标签不存在！",
							@(DOFOLLOW) : NSLocalizedString(@"已关注", @"关注后返回的结果"),
							@(DOUNFOLLOW) : NSLocalizedString(@"取消关注", @"取消关注后返回的结果")
 							};
	}
	
	if (msgData) {
		if ([msgData isKindOfClass:[NSString class]]) {
			return msgData;
		} else if ([msgData isKindOfClass:[NSNumber class]]) {
			NSNumber *msgNumber = msgData;
			return errorMessageMap[msgNumber];
		}
	}
	return nil;
}

+ (NSString *)messageNetworkError
{
	return @"网络错误，请检测您的网络！";
}


@end
