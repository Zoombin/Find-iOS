//
//  FDPhoto.h
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDPhoto : NSObject

@property (nonatomic, strong) NSString *urlString;

- (NSString *)urlStringScaleToFit:(CGSize)size;

@end
