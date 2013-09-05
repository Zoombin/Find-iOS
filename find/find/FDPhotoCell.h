//
//  FDPhotoCell.h
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "PSTCollectionViewCell.h"
#import "FDUser.h"
#import "FDPhoto.h"

#define kFDPhotoCellIdentifier @"fd_photo_cell_identifier"
#define kFDMainPhotoCellIdentifier @"fd_main_photo_cell_identifier"

@interface FDPhotoCell : PSTCollectionViewCell

@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) FDUser *user;
@property (nonatomic, strong) FDPhoto *photo;

@end
