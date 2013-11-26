//
//  FDAddress.h
//  find
//
//  Created by zhangbin on 11/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDAddress : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *addr;

+ (instancetype)createWithAttributes:(NSDictionary *)attributes;

@end
