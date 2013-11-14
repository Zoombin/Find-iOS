//
//  FDDetailsViewController.h
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDUser.h"
#import "FDPhoto.h"

@interface FDDetailsViewController : FDViewController

@property (nonatomic, assign) BOOL bMemberDetails;//是图片详情还是会员详情
@property (nonatomic, strong) FDUser *user;
@property (nonatomic, strong) FDPhoto *photo;

@end
