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

- (BOOL)isSessionValid;
- (NSString *)account;
- (NSNumber *)userID;
- (void)signout;

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

//把userID加入黑名单
- (void)blockUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//查询userID的黑名单
- (void)blockListOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//关注或者取消关注她
- (void)followOrUnfollowUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSNumber *followed))block;

//查看该用户的粉丝
- (void)followerListOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray* usersData))block;

//查看该用户关注的人
- (void)followedListOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;


//活动(发现界面)
- (void)themeListWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *themesData))block;

- (void)themeContent:(NSNumber *)themeID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *themeContentData, NSDictionary *themeAttributes))block;

//举报
- (void)reportComment:(NSNumber *)commentID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;
- (void)reportUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;
- (void)reportTweet:(NSNumber *)tweetID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;
- (void)reportPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;


- (void)tagsOfPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *votesData, NSNumber *totalVoted))block;

//服务器上叫category
- (void)regionsOfPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *votesData, NSNumber *totalVoted))block;

- (void)voteTag:(NSNumber *)tagID toPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *votesData, NSNumber *totalVoted))block;

- (void)voteRegion:(NSNumber *)regionID toPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *votesData, NSNumber *totalVoted))block;

//profile + all photo tweets
- (void)detailsOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSDictionary *profileAttributes, NSArray *tweetsData))block;

//发送私信
- (void)sendPrivateMessage:(NSString *)message toUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//我的资料和用户的资料
- (void)profileOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSDictionary *userProfileAttributes))block;

//修改我的资料
- (void)editProfile:(NSDictionary *)profileAttributes withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

- (void)editAvatarPath:(NSString *)avatarPath withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//用户的照片流//published是timestamp最后的时间用来分页的//published＝nil的话返回一定数量的tweets,由服务器控制
- (void)tweetsPublished:(NSNumber *)published limit:(NSNumber *)limit withCompletionBlock:(void (^)(BOOL success, NSString *message, NSNumber *published, NSArray *tweetsData))block;

//获取推荐的用户（公开，私密信息的时候用到）
- (void)candidatesWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSNumber *published, NSArray *usersData))block;

- (void)searchUserByKeyword:(NSString *)keyword withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *usersData))block;

//商店的商品，virtual表示是否是虚拟商品还是实物，有实物的礼物
- (void)stuffsList:(BOOL)bVirtual withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *stuffsData))block;

//申请兑换实体礼物
- (void)exchangeRealStuff:(NSNumber *)stuffID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//修改密码
- (void)changePassword:(NSString *)newPassword newPasswordConfirm:(NSString *)newPasswordConfirm oldPassword:(NSString *)oldPassword withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//test gzip
- (void)test;


@end
