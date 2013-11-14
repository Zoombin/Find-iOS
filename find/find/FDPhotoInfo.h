//
//  FDPhotoInfo.h
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDPhotoInfo : NSObject//TODO:需要存在数据库中吗？不需要每次请求了

@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSString *colorModel;

+ (instancetype)createWithAttributes:(NSDictionary *)attributes;

@end
