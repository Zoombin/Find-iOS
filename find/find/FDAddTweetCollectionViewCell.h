//
//  FDAddTweetCollectionViewCell.h
//  find
//
//  Created by zhangbin on 12/4/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kFDAddTweetCollectionViewCellIdentifier = @"kFDAddTweetCollectionViewCellIdentifier";

@protocol FDAddTweetCollectionViewCellDelegate <NSObject>

- (void)willAddTweet;

@end

@interface FDAddTweetCollectionViewCell : PSUICollectionViewCell

@property (nonatomic, weak) id<FDAddTweetCollectionViewCellDelegate> delegate;

@end
