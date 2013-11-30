//
//  FDEditPropertyViewController.h
//  find
//
//  Created by zhangbin on 11/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDInformation.h"

@interface FDEditPropertyViewController : UITableViewController

@property (nonatomic, strong) Class cellClass;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) FDInformation *privacyInfo;

@end
