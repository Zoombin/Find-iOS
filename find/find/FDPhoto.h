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

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) FDPhotoInfo *info;

- (NSString *)urlStringInfo;
- (NSString *)urlStringScaleAspectFit:(CGSize)size;
- (NSString *)urlStringScaleFitWidth:(CGFloat)width;

- (void)fetchInfoWithCompletionBlock:(dispatch_block_t)block;

@end
