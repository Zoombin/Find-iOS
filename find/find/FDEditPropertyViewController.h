//
//  FDEditPropertyViewController.h
//  find
//
//  Created by zhangbin on 11/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDInformation.h"

@interface FDEditPropertyViewController : UIViewController

@property (nonatomic, strong) Class cellClass;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *footerText;
@property (nonatomic, strong) FDInformation *privacyInfo;
@property (nonatomic, assign) UIKeyboardType keyboardType;

@end
