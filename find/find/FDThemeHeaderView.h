//
//  FDThemeHeaderView.h
//  find
//
//  Created by zhangbin on 10/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDThemeHeaderViewDelegate <NSObject>

- (void)didTapShowAll;

@end

@interface FDThemeHeaderView : UIView

@property (nonatomic, weak) id<FDThemeHeaderViewDelegate> delegate;
@property (nonatomic, strong) NSString *title;

+ (CGFloat)height;

@end
