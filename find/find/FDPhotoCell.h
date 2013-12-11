//
//  FDPhotoCell.h
//  find
//
//  Created by zhangbin on 12/11/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kFDPhotoCellIdentifier = @"kFDPhotoCellIdentifier";

@interface FDPhotoCell : UITableViewCell

@property (nonatomic, strong) FDPhoto *photo;

+ (CGFloat)height;

@end
