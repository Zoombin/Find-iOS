//
//  FDUserProfile.h
//  find
//
//  Created by zhangbin on 10/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"FDInformation.h"

@interface FDUserProfile : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSDate *birthday;
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
- (BOOL)isFemale;

@end
