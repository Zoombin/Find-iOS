//
//  FDPhoto.m
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhoto.h"

@implementation FDPhoto

- (NSString *)urlStringScaleToFit:(CGSize)size
{
	return [_urlString scaleToFit:size];
}

@end
