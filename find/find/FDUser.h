//
//  FDUser.h
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDPhoto.h"

@interface FDUser : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatarPath;
@property (nonatomic, strong) NSArray *photos;

+ (instancetype)createWithAttributes:(NSDictionary *)attributes;
+ (NSArray *)createMutableWithData:(NSArray *)data;
- (FDPhoto *)mainPhoto;

@end
