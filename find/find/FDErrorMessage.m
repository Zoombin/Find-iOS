//
//  FDErrorMessage.m
//  find
//
//  Created by zhangbin on 10/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDErrorMessage.h"

NSInteger PHOTO_LIKE = 3;
NSInteger FORBIDDEN = 403;
NSInteger NEW_PASSWORD_EMPTY = 20021;
NSInteger AGAIN_PASSWORD_EMPTY = 20022;
NSInteger AGAIN_PASSWORD_WRONG = 20023;
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
NSInteger CONTENT_FORBIDDEN = 3003;
NSInteger DOLIKE = 10;
NSInteger DOUNLIKE = 11;
NSInteger DOADD = 12;
NSInteger DOREMOVE = 13;
NSInteger DOFOLLOW = 14;
NSInteger DOUNFOLLOW = 15;
NSInteger TAG_DONOT_EXISTS = 4001;
NSInteger CATEGORY_DONOT_EXISTS = 4002;
NSInteger SHOP_SOLD_OUT = 5001;
NSInteger MONEY_NOT_ENOUGH = 5002;

@implementation FDErrorMessage

static NSDictionary *errorMessageMap;

+ (NSString *)messageFromData:(id)msgData
{
	if (!errorMessageMap) {
		errorMessageMap = @{
							@(PHOTO_LIKE) : NSLocalizedString(@"喜欢照片", nil),
							@(FORBIDDEN) : NSLocalizedString(@"操作无效", nil),
							@(NEW_PASSWORD_EMPTY) : NSLocalizedString(@"新密码不能为空", nil),
							@(AGAIN_PASSWORD_EMPTY) : NSLocalizedString(@"确认密码不能为空", nil),
							@(AGAIN_PASSWORD_WRONG) : NSLocalizedString(@"两次密码输入不一致", nil),
							@(SYSTEM_ERROR) : NSLocalizedString(@"服务异常，请检测您的网络！", nil),
							@(USERNAME_EMPTY) : NSLocalizedString(@"用户名不能为空！", nil),
							@(PASSWORD_EMPTY) : NSLocalizedString(@"密码不能为空！", nil),
							@(USER_DONOT_EXISTS) : NSLocalizedString(@"用户不存在！", nil),
							@(PASSWORD_WRONG) : NSLocalizedString(@"密码错误！", nil),
							@(USER_EXISTS) : NSLocalizedString(@"用户已存在！", nil),
							@(USERNAME_ERROR) : NSLocalizedString(@"用户名错误", nil),
							@(CANNOT_FOLLOW_SELF) : NSLocalizedString(@"不能关注自己！", nil),
							@(PHOTO_DONOT_EXISTS) : NSLocalizedString(@"照片不存在！", nil),
							@(CONTENT_EMPTY) : NSLocalizedString(@"内容为空！", nil),
							@(CONTENT_FORBIDDEN) : NSLocalizedString(@"内容被禁止", nil),
							@(DOLIKE) : NSLocalizedString(@"喜欢", nil),
							@(DOUNLIKE) : NSLocalizedString(@"不喜欢", nil),
							@(DOADD) : NSLocalizedString(@"添加", nil),
							@(DOREMOVE) : NSLocalizedString(@"删除", nil),
							@(TAG_DONOT_EXISTS) : NSLocalizedString(@"标签不存在！", nil),
							@(CATEGORY_DONOT_EXISTS) : NSLocalizedString(@"部位不存在", nil),
							@(SHOP_SOLD_OUT) : NSLocalizedString(@"已售完", nil),
							@(MONEY_NOT_ENOUGH) : NSLocalizedString(@"余额不足", nil)
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
