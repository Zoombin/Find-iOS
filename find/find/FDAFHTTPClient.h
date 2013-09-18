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

+(FDAFHTTPClient *)shared;

- (void)tweetPhotos:(NSArray *)photos atLocation:(CLLocation *)location address:(NSString *)address withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

- (void)aroundPhotosAtLocation:(CLLocation *)location limit:(NSNumber *)limit distance:(NSNumber *)distance withCompletionBlock:(void (^)(BOOL success, NSArray *tweets, NSNumber *distance))block;

- (void)likePhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

- (void)unlikePhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

- (void)commentPhoto:(NSNumber *)photoID content:(NSString *)content withCompletionBlock:(void (^)(BOOL success, NSString *message))block;

- (void)commentsOfPhoto:(NSNumber *)photoID limit:(NSNumber *)limit published:(NSNumber *)published withCompletionBlock:(void (^)(BOOL success, NSArray *comments, NSNumber *lastestPublishedTimestamp))block;



@end
