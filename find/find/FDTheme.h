//
//  FDEvent.h
//  find
//
//  Created by zhangbin on 10/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kThemeCategoryIdentifierSlide;
extern NSString *kThemeCategoryIdentifierIcon;
extern NSString *kThemeCategoryIdentifierBrand;

@interface FDTheme : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *categoryIdentifier;
@property (nonatomic, strong) NSString *imagePath;

+ (FDTheme *)createWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)createMutableWithData:(NSArray *)data;

@end
