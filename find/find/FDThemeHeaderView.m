//
//  FDThemeHeaderView.m
//  find
//
//  Created by zhangbin on 10/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDThemeHeaderView.h"
#import "FDThemeSection.h"

@implementation FDThemeHeaderView
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
		
		CGFloat widthOfShowAll = 100;
		UILabel *showAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - widthOfShowAll - CELL_LEFT_MARGIN, 0, widthOfShowAll, self.bounds.size.height)];
		showAllLabel.backgroundColor = [UIColor clearColor];
		//showAllLabel.backgroundColor = [UIColor randomColor];
		showAllLabel.text = NSLocalizedString(@"See All >", nil);
		showAllLabel.textAlignment = NSTextAlignmentRight;
		showAllLabel.textColor = [UIColor grayColor];
		showAllLabel.font = [UIFont fdThemeFontOfSize:14];
		showAllLabel.userInteractionEnabled = YES;
		[self addSubview:showAllLabel];
		
		UITapGestureRecognizer *tapGestureRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedShowAll)];
		[showAllLabel addGestureRecognizer:tapGestureRecoginzer];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
	if ([_title isEqualToString:title]) return;
	_title = title;
	
	titleLabel.text = _title;
}

- (void)tappedShowAll
{
	[_delegate didTapShowAll];
}

+ (CGFloat)height
{
	return 30.0f;
}

@end
