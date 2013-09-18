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

@interface FDCommentCell : PSTCollectionViewCell

@property (nonatomic, strong) FDComment *comment;

@end
