//
//  FDAvatarView.h
//  find
//
//  Created by zhangbin on 9/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDAvatarView : UIImageView

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *imagePath;

+ (CGSize)defaultSize;
+ (CGSize)bigSize;

@end
