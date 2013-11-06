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

@interface FDVoteCell : UITableViewCell

@property (nonatomic, strong) FDVote *vote;

+ (CGFloat)height;

@end
