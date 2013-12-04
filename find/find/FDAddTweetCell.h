//
//  FDAddTweetCell.h
//  find
//
//  Created by zhangbin on 12/4/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kFDAddTweetCellIdentifier = @"kFDAddTweetCellIdentifier";

@protocol FDAddTweetCellDelegate <NSObject>

- (void)willAddTweet;

@end

@interface FDAddTweetCell : PSUICollectionViewCell

@property (nonatomic, weak) id<FDAddTweetCellDelegate> delegate;

@end
