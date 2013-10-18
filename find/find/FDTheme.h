//
//  FDEvent.h
//  find
//
//  Created by zhangbin on 10/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FDThemeCategory) {
    FDThemeCategorySlideAD,
    FDThemeCategoryIcon,
    FDThemeCategoryBrand
};

@interface FDTheme : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *typeID;//0会员 1图片
@property (nonatomic, strong) NSNumber *categoryID;//aid in DB: 活动位置 0banner 1hot a 2hot b
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, strong) NSString *imagePath;

+ (FDTheme *)createWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)createMutableWithData:(NSArray *)data;

@end
