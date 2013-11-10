//
//  FDPhotoDetailsViewController.h
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDUser.h"
#import "FDPhoto.h"

@interface FDPhotoDetailsViewController : FDViewController

@property (nonatomic, assign) BOOL bMemberDetails;
@property (nonatomic, strong) FDUser *user;
@property (nonatomic, strong) FDPhoto *photo;

@end
