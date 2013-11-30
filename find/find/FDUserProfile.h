//
//  FDUserProfile.h
//  find
//
//  Created by zhangbin on 10/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"FDInformation.h"

typedef NS_ENUM(NSInteger, FDGenderType) {
	FDGenderTypeFemale,
	FDGenderTypeMale,
	FDGenderTypeUnknow
};

typedef NS_ENUM(NSInteger, FDShapeType) {
	FDShapeTypeAge,
	FDShapeTypeHeight,
	FDShapeTypeWeight,
	FDShapeTypeChest
};

extern NSString *kProfileShape;
extern NSString *kProfileNickname;
extern NSString *kProfileGender;
extern NSString *kProfileAge;
extern NSString *kProfileHeight;
extern NSString *kProfileWeight;
extern NSString *kProfileChest;
extern NSString *kProfileNumberOfPhotos;
extern NSString *kProfileNumberOfFollowers;
extern NSString *kProfileNumberOfFollowing;
extern NSString *kProfileViews;
extern NSString *kProfileSignature;
extern NSString *kProfileAsignature;
extern NSString *kProfileQQ;
extern NSString *kProfileMobile;
extern NSString *kProfileWeixin;
extern NSString *kProfileAddress;
extern NSString *kProfileAvatar;
extern NSString *kProfilePhotos;
extern NSString *kProfilePrivateMessages;
extern NSString *kProfileSettings;

@interface FDUserProfile : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatarPath;
@property (nonatomic, assign) BOOL bFemale;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSNumber *chest;
@property (nonatomic, strong) NSNumber *numberOfPhotos;
@property (nonatomic, strong) NSNumber *numberOfFollowers;
@property (nonatomic, strong) NSNumber *numberOfFollowing;
@property (nonatomic, strong) NSNumber *views;//被访问次数
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *asignature;//语音签名.这个应该是一个url，是否要做到数据库？听过以后都存下来

//@property (nonatomic, strong) NSDate *birthday;
//@property (nonatomic, strong) NSString *province;
//@property (nonatomic, strong) NSString *city;
//@property (nonatomic, strong) NSString *school;
//@property (nonatomic, strong) NSNumber *integral;//积分
//@property (nonatomic, strong) NSNumber *money;
//@property (nonatomic, strong) NSNumber *starvar;//明星值
//@property (nonatomic, strong) CLLocation *location;
//@property (nonatomic, strong) NSNumber *status;//用户状态 0被禁用 1正常
//@property (nonatomic, strong) NSDate *signined;//注册时间

@property (nonatomic, strong) FDInformation *qqInformation;
@property (nonatomic, strong) FDInformation *mobileInformation;
@property (nonatomic, strong) FDInformation *weixinInformation;
@property (nonatomic, strong) FDInformation *addressInformation;

+ (instancetype)createWithAttributes:(NSDictionary *)attributes;
- (id)valueWithIdentifier:(NSString  *)identifier;
- (NSString *)displayWithIdentifier:(NSString *)identifier;
- (NSString *)privacyInfoWithIdentifier:(NSString *)identifier;
- (void)setValue:(NSNumber *)value withIdentifier:(NSString *)identifier;

@end
