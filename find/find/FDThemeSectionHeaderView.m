//
//  FDThemeHeader.m
//  find
//
//  Created by zhangbin on 10/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDThemeSectionHeaderView.h"
#import "FDThemeSection.h"

@implementation FDThemeSectionHeaderView
{
	UILabel *titleLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CELL_LEFT_MARGIN, 0, self.bounds.size.width, self.bounds.size.height)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont fdThemeFontOfSize:16];
		[self addSubview:titleLabel];
		
		UILabel *showAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - CELL_LEFT_MARGIN, self.bounds.size.height)];
		showAllLabel.backgroundColor = [UIColor clearColor];
		showAllLabel.text = @"显示全部>";//TODO: 国际化
		showAllLabel.textAlignment = NSTextAlignmentRight;
		showAllLabel.textColor = [UIColor grayColor];
		showAllLabel.font = [UIFont fdThemeFontOfSize:14];
		[self addSubview:showAllLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
	if ([_title isEqualToString:title]) return;
	_title = title;
	
	titleLabel.text = _title;
}

+ (CGFloat)height
{
	return 40.0f;
}

@end
