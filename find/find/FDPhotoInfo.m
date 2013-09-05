//
//  FDPhotoInfo.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhotoInfo.h"

@implementation FDPhotoInfo

+ (FDPhotoInfo *)createWithAttributes:(NSDictionary *)attributes
{
	FDPhotoInfo *info = [[FDPhotoInfo alloc] init];
	info.format = attributes[@"format"];
	info.width = attributes[@"width"];
	info.height = attributes[@"height"];
	info.colorModel = attributes[@"colorModel"];
	return info;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"{ format:%@, width:%d, height:%d, colorModel:%@ }", _format, _width.intValue, _height.intValue, _colorModel];
}

@end
