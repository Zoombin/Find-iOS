//
//  FDThemeCell.h
//  find
//
//  Created by zhangbin on 9/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "PSTCollectionViewCell.h"

#define kThemeCellAttributeKeyBounds @"kThemeCellAttributeKeyBounds"
#define kThemeCellAttributeKeyItemWidth @"kThemeCellAttributeKeyItemWidth"
#define kThemeCellAttributeKeyPagingEnabled @"kThemeCellAttributeKeyPagingEnabled"
#define kThemeCellAttributeKeyShowsHorizontalScrollIndicator @"kThemeCellAttributeKeyShowsHorizontalScrollIndicator"
#define kThemeCellAttributeKeyAutoScrollEnabled @"kThemeCellAttributeKeyAutoScrollEnabled"
#define kThemeCellAttributeKeyHeaderTitle @"kThemeCellAttributeKeyHeaderTitle"

#define kFDThemeCellIdentifier @"kFDThemeCellIdentifier"

@interface FDThemeCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *items;


+ (NSDictionary *)attributesOfSlideADStyle;
+ (NSDictionary *)attributesOfIconStyle;
+ (NSDictionary *)attributesOfBrandStyle;

@end
