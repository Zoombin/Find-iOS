//
//  FDUserCell.h
//  find
//
//  Created by zhangbin on 11/14/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDUserCell : UITableViewCell

@property (nonatomic, strong) FDUser *user;

+ (NSString *)identifier;

@end
