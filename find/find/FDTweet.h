//
//  FDTweet.h
//  find
//
//  Created by zhangbin on 9/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDTweet : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *signature;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSNumber *published;
@property (nonatomic, strong) NSString *publishday;
@property (nonatomic, strong) NSNumber *distance;


+ (instancetype)createWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)createMutableWithData:(NSArray *)data;

@end
