//
//  PSTCollectionViewFlowLayout+FDLayout.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "PSTCollectionViewFlowLayout+FDLayout.h"

@implementation PSTCollectionViewFlowLayout (FDLayout)

+ (PSTCollectionViewFlowLayout *)aroundPhotoLayout
{
	PSTCollectionViewFlowLayout *layout = [[PSTCollectionViewFlowLayout alloc] init];
	layout.minimumInteritemSpacing = 5;
	layout.minimumLineSpacing = 5;
	layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
	return layout;
}

+ (PSTCollectionViewFlowLayout *)smallSquaresLayout
{
	PSTCollectionViewFlowLayout *layout = [[PSTCollectionViewFlowLayout alloc] init];
	layout.minimumInteritemSpacing = 5;
	layout.minimumLineSpacing = 5;
	layout.sectionInset = UIEdgeInsetsMake(10, 5, 10, 5);
	return layout;
}



@end
