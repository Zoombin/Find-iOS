//
//  FDAFHTTPClient.h
//  find
//
//  Created by zhangbin on 9/10/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "AFHTTPClient.h"
#import <CoreLocation/CoreLocation.h>

@interface FDAFHTTPClient : AFHTTPClient

+(instancetype)shared;

- (NSString *)account;
- (NSNumber *)userID;

- (void)infoOfPhoto:(NSString *)photoInfoUrlString completionBlockWithSuccess:(void (^)(NSDictionary *infoAttributes))success;

- (void)tweetPhotos:(NSArray *)photos atLocation:(CLLocation *)location address:(NSString *)address withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//distance是本次请求返回的所有照片中距离的最大值
- (void)aroundPhotosAtLocation:(CLLocation *)location limit:(NSNumber *)limit distance:(NSNumber *)distance withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *tweetsData, NSNumber *distance))block;

- (void)likeOrUnlikePhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSNumber *liked, NSNumber *likes))block;

- (void)commentPhoto:(NSNumber *)photoID content:(NSString *)content withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//lastestPublishedTimestamp是本次返回的评论中的时间最大值
- (void)commentsOfPhoto:(NSNumber *)photoID limit:(NSNumber *)limit published:(NSNumber *)published withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *commentsData, NSNumber *total, NSNumber *lastestPublishedTimestamp))block;

- (void)signupAtLocation:(CLLocation *)location username:(NSString *)username password:(NSString *)password withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

- (void)signinAtLocation:(CLLocation *)location username:(NSString *)username password:(NSString *)password withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//- (void)changePassword:()

- (void)profileOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSDictionary *userProfileAttributes))block;

- (void)editProfileOfUser:(NSNumber *)userID profileAttributes:(NSDictionary *)profileAttributes withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//把userID加入黑名单
- (void)blockUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//查询userID的黑名单
- (void)blockListOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//- (void)tweetsOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

- (void)followOrUnfollowUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//查看改用户的粉丝
- (void)followerListOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//查看该用户关注的人
- (void)followedListOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;


//活动(发现界面)
- (void)themeListWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *themesData))block;

- (void)themeContent:(NSNumber *)themeID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *themeContentData, NSDictionary *themeAttributes))block;

- (void)reportComment:(NSNumber *)commentID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;
- (void)reportUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;
- (void)reportPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;


- (void)tagsOfPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *votesData))block;

//服务器上叫category
- (void)regionsOfPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *votesData))block;

- (void)voteTag:(NSNumber *)tagID toPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *votesData))block;

- (void)voteRegion:(NSNumber *)regionID toPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *votesData))block;

//profile + all photo tweets
- (void)detailsOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSDictionary *profileAttributes, NSArray *tweetsData))block;

//test gzip
- (void)test;


@end
