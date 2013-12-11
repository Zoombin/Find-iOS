//
//  FDPhotoCollectionViewCell.h
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDUser.h"
#import "FDPhoto.h"
#import "FDLikesView.h"

static NSString *kFDPhotoCollectionViewCellIdentifier = @"kFDPhotoCollectionViewCellIdentifier";

@class FDPhotoCollectionViewCell;
@protocol FDPhotoCollectionViewCellDelegate <NSObject>

- (void)photoCell:(FDPhotoCollectionViewCell *)photoCell willLikeOrUnlikePhoto:(FDPhoto *)photo;

@end


@interface FDPhotoCollectionViewCell : PSUICollectionViewCell

@property (nonatomic, weak) id<FDPhotoCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) FDTweet *tweet;
@property (nonatomic, strong) FDUser *user;
@property (nonatomic, strong) FDPhoto *photo;
@property (nonatomic, strong) FDLikesView *likesView;

- (void)hideDetails;
//- (void)setPhoto:(FDPhoto *)photo scaleFitWidth:(CGFloat)width completionBlock:(dispatch_block_t)block;

@end



