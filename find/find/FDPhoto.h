//
//  FDPhoto.h
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"FDPhotoInfo.h"

@interface FDPhoto : NSObject//TODO:需要持久化吗？不需要每次都读取了，是否要一个字典来存放各种尺寸的图片，并且持久化

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *tweetID;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSNumber *views;
@property (nonatomic, strong) NSNumber *uploaded;//timestamp
@property (nonatomic, strong) FDPhotoInfo *info;

+ (FDPhoto *)createWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)createMutableWithData:(NSArray *)data;

- (NSString *)urlStringInfo;
- (NSString *)urlStringScaleAspectFit:(CGSize)size;
- (NSString *)urlStringScaleFitWidth:(CGFloat)width;

- (void)fetchInfoWithCompletionBlock:(dispatch_block_t)block;

@end
