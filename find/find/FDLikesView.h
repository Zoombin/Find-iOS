//
//  FDLikesView.h
//  find
//
//  Created by zhangbin on 9/17/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDLikesView : UIView

@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSNumber *liked;

+ (CGSize)size;

@end
