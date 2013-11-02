//
//  FDCommentCell.h
//  find
//
//  Created by zhangbin on 9/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhoto.h"
#import "FDUser.h"

#define kFDCommentCellIdentifier @"kFDCommentCellIdentifier"

@protocol FDCommentCellDelegate <NSObject>

- (void)willCommentOrReply:(FDComment *)comment;
- (void)willReport:(FDComment *)comment;

@end

@interface FDCommentCell : UITableViewCell

@property (nonatomic, weak) id<FDCommentCellDelegate> delegate;
@property (nonatomic, strong) FDComment *comment;
@property (nonatomic, assign) BOOL bMine;

+ (CGFloat)heightForComment:(FDComment *)comment;

@end
