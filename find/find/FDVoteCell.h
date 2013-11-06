//
//  FDVoteCell.h
//  find
//
//  Created by zhangbin on 11/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDVote.h"

static NSString *kFDVoteCellIdentifier = @"kFDVoteCellIdentifier";

@protocol FDVoteCellDelegate <NSObject>

- (void)willVote:(FDVote *)vote;

@end

@interface FDVoteCell : UITableViewCell

@property (nonatomic, weak) id<FDVoteCellDelegate> delegate;
@property (nonatomic, strong) FDVote *vote;

+ (CGFloat)height;

@end
