//
//  PSTCollectionViewFlowLayout+FDLayout.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "PSTCollectionViewFlowLayout+FDLayout.h"

@implementation PSTCollectionViewFlowLayout (FDLayout)

+ (PSTCollectionViewFlowLayout *)squaresLayout
{
	PSTCollectionViewFlowLayout *layout = [[PSTCollectionViewFlowLayout alloc] init];
	//layout.itemSize = kThumbnailSquareSize;//CGSizeMake(kThumbnailSquareLength, 175);
	layout.minimumInteritemSpacing = 10;
	layout.minimumLineSpacing = 10;
	layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
	return layout;
}

+ (PSTCollectionViewFlowLayout *)smallSquaresLayout
{
	PSTCollectionViewFlowLayout *layout = [[PSTCollectionViewFlowLayout alloc] init];
	//layout.itemSize = kThumbnailSmallSquareSize;
	layout.minimumInteritemSpacing = 5;
	layout.minimumLineSpacing = 5;
	layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);
	return layout;
}

@end
