//
//  FDMeCell.h
//  find
//
//  Created by zhangbin on 12/3/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDAvatarView.h"
#import "FDUserProfile.h"

@interface FDMeCell : UITableViewCell

@property (nonatomic, strong) FDUserProfile *profile;

+ (CGFloat)height;

@end
