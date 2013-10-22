//
//  FDThemeSection.h
//  find
//
//  Created by zhangbin on 10/22/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kThemeStyleIdentifierSlide;
extern NSString *kThemeStyleIdentifierIcon;
extern NSString *kThemeStyleIdentifierBrand;

@interface FDThemeSection : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *ordered;
@property (nonatomic, strong) NSArray *themes;
@property (nonatomic, strong) NSString *style;

+ (FDThemeSection *)createWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)createMutableWithData:(NSArray *)data;
- (BOOL)isEmpty;

@end
