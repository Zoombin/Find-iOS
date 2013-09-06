//
//  PSTCollectionViewFlowLayout+FDLayout.h
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "PSTCollectionViewFlowLayout.h"

#define kBigSquareLength 305
#define kBigSquareSize ( CGSizeMake(kBigSquareLength, kBigSquareLength) )

#define kThumbnailSmallSquareLength 100
#define kThumbnailSmallSquareSize ( CGSizeMake(kThumbnailSmallSquareLength, kThumbnailSmallSquareLength) )

#define kThumbnailSquareLength 144
#define kThumbnailSquareSize ( CGSizeMake(kThumbnailSquareLength, kThumbnailSquareLength) )

@interface PSTCollectionViewFlowLayout (FDLayout)

+ (PSTCollectionViewFlowLayout *)squaresLayout;
+ (PSTCollectionViewFlowLayout *)smallSquaresLayout;

@end
