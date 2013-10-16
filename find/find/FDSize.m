//
//  FDSize.m
//  find
//
//  Created by zhangbin on 10/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDSize.h"

#define kBigSquareWidth 305
#define kBigSquareSize ( CGSizeMake(kBigSquareWidth, kBigSquareWidth) )

#define kThumbnailSmallSquareWidth 100
#define kThumbnailSmallSquareSize ( CGSizeMake(kThumbnailSmallSquareWidth, kThumbnailSmallSquareWidth) )

@implementation FDSize

+ (CGSize)aroundPhotoSize
{
	return CGSizeMake(150, 180);
}

+ (CGSize)profilePhotoSize
{
	return CGSizeMake(305, 305);
}

+ (CGSize)profileOtherPhotoSize
{
	return CGSizeMake(100, 100);
}

@end
