//
//  FDPrice.h
//  find
//
//  Created by zhangbin on 12/23/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDPrice : NSObject

@property (nonatomic, strong) NSNumber *bRMB;
@property (nonatomic, strong) NSNumber *RMB;
@property (nonatomic, strong) NSNumber *flowers;
@property (nonatomic, strong) NSNumber *diamonds;

+ (instancetype)createWithAttributes:(NSDictionary *)attributes;
- (NSString *)printablePrice;

@end
