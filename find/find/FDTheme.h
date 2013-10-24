//
//  FDEvent.h
//  find
//
//  Created by zhangbin on 10/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kThemeTypeIdentifierPhoto;
extern NSString *kThemeTypeIdentifierUser;

@interface FDTheme : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *style;

+ (FDTheme *)createWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)createMutableWithData:(NSArray *)data;

@end
