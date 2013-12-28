//
//  FDThemeCell.h
//  find
//
//  Created by zhangbin on 9/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDThemeSection.h"

extern NSString *kThemeCellAttributeKeyHeight;
extern NSString *kThemeCellAttributeKeyItemWidth;
extern NSString *kThemeCellAttributeKeyPagingEnabled;
extern NSString *kThemeCellAttributeKeyShowsHorizontalScrollIndicator;
extern NSString *kThemeCellAttributeKeyAutoScrollEnabled;
extern NSString *kThemeCellAttributeKeyHeaderTitle;
extern NSString *kThemeCellAttributeKeyHasSeparateLine;

@protocol FDThemeCellDelegate <NSObject>

- (void)didSelectTheme:(FDTheme *)theme inThemeSection:(FDThemeSection *)themeSection;
- (void)didSelectShowAllInThemeSection:(FDThemeSection *)themeSection;

@end

@interface FDThemeCell : UITableViewCell

@property (nonatomic, weak) id<FDThemeCellDelegate> delegate;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FDThemeSection *themeSection;

+ (NSDictionary *)attributesOfStyle:(NSString *)themeStyle;
+ (NSString *)identifier;

@end
