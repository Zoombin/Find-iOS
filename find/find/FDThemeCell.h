//
//  FDThemeCell.h
//  find
//
//  Created by zhangbin on 9/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "PSTCollectionViewCell.h"
#import "FDThemeSection.h"

extern NSString *kThemeCellAttributeKeyBounds;
extern NSString *kThemeCellAttributeKeyItemWidth;
extern NSString *kThemeCellAttributeKeyPagingEnabled;
extern NSString *kThemeCellAttributeKeyShowsHorizontalScrollIndicator;
extern NSString *kThemeCellAttributeKeyAutoScrollEnabled;
extern NSString *kThemeCellAttributeKeyHeaderTitle;
extern NSString *kThemeCellAttributeKeyHasSeparateLine;

#define kFDThemeCellIdentifier @"kFDThemeCellIdentifier"

@interface FDThemeCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FDThemeSection *themeSection;

+ (NSDictionary *)attributesOfStyle:(NSString *)themeStyle;

@end
