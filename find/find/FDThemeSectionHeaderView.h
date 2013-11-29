//
//  FDThemeHeader.h
//  find
//
//  Created by zhangbin on 10/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDThemeSectionHeaderViewDelegate <NSObject>

- (void)didTapShowAll;

@end

@interface FDThemeSectionHeaderView : UIView

@property (nonatomic, weak) id<FDThemeSectionHeaderViewDelegate> delegate;
@property (nonatomic, strong) NSString *title;

+ (CGFloat)height;

@end
