//
//  FDPhoto.h
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"FDPhotoInfo.h"

@interface FDPhoto : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *tweetID;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSNumber *liked;//和用户相关的，当前用户是否like了这张照片
@property (nonatomic, strong) NSNumber *views;
@property (nonatomic, strong) NSNumber *uploaded;//timestamp
@property (nonatomic, strong) FDPhotoInfo *info;

+ (FDPhoto *)createWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)createMutableWithData:(NSArray *)data;

- (NSString *)urlString;
- (NSURL *)url;
- (NSString *)urlStringInfo;
- (NSString *)urlStringScaleAspectFit:(CGSize)size;
- (NSString *)urlStringScaleFitWidth:(CGFloat)width;
- (NSURL *)urlScaleFitWidth:(CGFloat)width;
- (NSString *)urlstringCropToSize:(CGSize)size;

- (void)fetchInfoWithCompletionBlock:(dispatch_block_t)block;

@end
