//
//  FDStuff.h
//  find
//
//  Created by zhangbin on 12/23/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDPrice.h"

@interface FDStuff : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSNumber *bReal;//实物，非虚拟商品，鲜花/钻石是虚拟的
@property (nonatomic, strong) NSString *detailsURLString;//TODO:
@property (nonatomic, strong) FDPrice *price;

+ (instancetype)createWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)createMutableWithData:(NSArray *)data;

@end
