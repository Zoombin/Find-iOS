//
//  FDPhotoCell.h
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "PSTCollectionView.h"
#import "FDUser.h"
#import "FDPhoto.h"
#import "FDLikesView.h"

#define kFDPhotoCellIdentifier @"kFDPhotoCellIdentifier"
#define kFDMainPhotoCellIdentifier @"kFDMainPhotoCellIdentifier"

@class FDPhotoCell;
@protocol FDPhotoCellDelegate <NSObject>

- (void)photoCell:(FDPhotoCell *)photoCell willLikeOrUnlikePhoto:(FDPhoto *)photo;

@end


@interface FDPhotoCell : PSUICollectionViewCell

@property (nonatomic, weak) id<FDPhotoCellDelegate> delegate;
@property (nonatomic, strong) FDTweet *tweet;
@property (nonatomic, strong) FDUser *user;
@property (nonatomic, strong) FDPhoto *photo;
@property (nonatomic, strong) FDLikesView *likesView;

- (void)setPhoto:(FDPhoto *)photo scaleFitWidth:(CGFloat)width completionBlock:(dispatch_block_t)block;

@end



