//
//  PSTCollectionViewFlowLayout+FDLayout.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "PSTCollectionViewFlowLayout+FDLayout.h"

@implementation PSTCollectionViewFlowLayout (FDLayout)

+ (PSTCollectionViewFlowLayout *)themeLayout
{
	PSTCollectionViewFlowLayout *layout = [[PSTCollectionViewFlowLayout alloc] init];
	layout.scrollDirection = PSTCollectionViewScrollDirectionHorizontal;
	layout.itemSize = kThemeSize;
	layout.minimumInteritemSpacing = 0;
	layout.minimumLineSpacing = 0;
	layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return layout;
}

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
