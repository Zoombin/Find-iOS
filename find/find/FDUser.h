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

@property (nonatomic, strong) NSArray *photos;

- (FDPhoto *)mainPhoto;

@end
