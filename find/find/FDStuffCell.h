//
//  FDStuffCell.h
//  find
//
//  Created by zhangbin on 12/20/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDStuff.h"

static NSString *kFDStuffCellIdentifier = @"kFDStuffCellIdentifier";

@interface FDStuffCell : UITableViewCell

@property (nonatomic, strong) FDStuff *stuff;

@end
