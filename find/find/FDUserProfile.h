//
//  FDUserProfile.h
//  find
//
//  Created by zhangbin on 10/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDUserProfile : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSNumber *gender;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *asignature;//语音签名.这个应该是一个url，是否要做到数据库？听过以后都存下来
@property (nonatomic, strong) NSNumber *userprivacy;//TODO:现在是string
@property (nonatomic, strong) NSNumber *integral;//积分
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, strong) NSNumber *starvar;//明星值
@property (nonatomic, strong) NSNumber *follower;//粉丝数
@property (nonatomic, strong) NSNumber *followed;//关注数
@property (nonatomic, strong) NSNumber *photos;//图片数
@property (nonatomic, strong) NSNumber *views;//被访问次数
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSNumber *status;//用户状态 0被禁用 1正常
@property (nonatomic, strong) NSDate *signined;//注册时间

+ (FDUserProfile *)createWithAttributes:(NSDictionary *)attributes;

@end
