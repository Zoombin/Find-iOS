//
//  FDPhotoCell.h
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "PSTCollectionViewCell.h"
#import "FDPhoto.h"

#define kFDPhotoCellIdentifier @"fd_photo_cell_identifier"

@interface FDPhotoCell : PSTCollectionViewCell

@property (nonatomic, strong) FDPhoto *photo;

@end
