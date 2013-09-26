//
//  FDCommentCell.h
//  find
//
//  Created by zhangbin on 9/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "PSTCollectionViewCell.h"
#import "FDPhoto.h"
#import "FDUser.h"

#define kFDCommentCellIdentifier @"kFDCommentCellIdentifier"

@interface FDCommentCell : UITableViewCell

@property (nonatomic, strong) FDComment *comment;

+ (CGFloat)heightForComment:(FDComment *)comment boundingRectWithWidth:(CGFloat)width;

@end
