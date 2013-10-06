//
//  FDAFHTTPClient.h
//  find
//
//  Created by zhangbin on 9/10/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "AFHTTPClient.h"
#import <CoreLocation/CoreLocation.h>

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

@interface FDAFHTTPClient : AFHTTPClient

+(FDAFHTTPClient *)shared;

- (void)tweetPhotos:(NSArray *)photos atLocation:(CLLocation *)location address:(NSString *)address withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

- (void)aroundPhotosAtLocation:(CLLocation *)location limit:(NSNumber *)limit distance:(NSNumber *)distance withCompletionBlock:(void (^)(BOOL success, NSArray *tweets, NSNumber *distance))block;

- (void)likeOrUnlikePhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSNumber *message, NSNumber *liked))block;

- (void)commentPhoto:(NSNumber *)photoID content:(NSString *)content withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

- (void)commentsOfPhoto:(NSNumber *)photoID limit:(NSNumber *)limit published:(NSNumber *)published withCompletionBlock:(void (^)(BOOL success, NSArray *comments, NSNumber *lastestPublishedTimestamp))block;

- (void)signupAtLocation:(CLLocation *)location username:(NSString *)username password:(NSString *)password withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

- (void)signinAtLocation:(CLLocation *)location username:(NSString *)username password:(NSString *)password withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

//test gzip
- (void)test;


@end
