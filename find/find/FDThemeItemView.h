//
//  FDThemeItemView.h
//  find
//
//  Created by zhangbin on 9/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FDThemeItemViewDelegate <NSObject>

- (void)didSelectTheme:(FDTheme *)theme;

@end

@interface FDThemeItemView : UIView

@property (nonatomic, weak) id<FDThemeItemViewDelegate> delegate;
@property (nonatomic, strong) FDTheme *theme;

@end
