//
//  FDThemeItemView.m
//  find
//
//  Created by zhangbin on 9/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDThemeItemView.h"

#define kCornerRadius 20

@implementation FDThemeItemView
{
	UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor randomColor];
		
		imageView = [[UIImageView alloc] init];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.layer.borderColor = [[UIColor fdSeparateLineColor] CGColor];
		imageView.layer.borderWidth = 1;
		imageView.layer.masksToBounds = YES;
		[self addSubview:imageView];
    }
    return self;
}

- (void)setTheme:(FDTheme *)theme
{
	if (_theme == theme) return;
	_theme = theme;
	
	if (theme.categoryID.integerValue == FDThemeCategorySlideAD) {
		imageView.frame = self.bounds;
	} else if (theme.categoryID.integerValue == FDThemeCategoryIcon) {
		CGSize size = CGSizeMake(72, 72);
		CGPoint start = CGPointMake((self.bounds.size.width - size.width) / 2, 5);
		
		imageView.frame = CGRectMake(start.x, start.y, 70, 70);
		imageView.layer.cornerRadius = kCornerRadius;
		
		start = CGPointMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame) + 5);
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, size.width, 16)];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.textColor = [UIColor blackColor];
		titleLabel.font = [UIFont fdThemeFontWithSize:12];
		titleLabel.textAlignment = NSTextAlignmentCenter;
		titleLabel.text = @"百变美女静";//TODO
		[self addSubview:titleLabel];
		
		start = CGPointMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame));
		
		UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, size.width, 13)];
		subtitleLabel.backgroundColor = [UIColor clearColor];
		subtitleLabel.textColor = [UIColor grayColor];
		subtitleLabel.font = [UIFont fdThemeFontWithSize:12];
		subtitleLabel.textAlignment = NSTextAlignmentCenter;
		subtitleLabel.text = @"上海";//TODO
		[self addSubview:subtitleLabel];
		
	} else if (theme.categoryID.integerValue == FDThemeCategoryBrand) {
		CGSize size = CGSizeMake(150, 72);
		CGPoint start = CGPointMake((self.bounds.size.width - size.width) / 2, (self.bounds.size.height - size.height) / 2);
		imageView.frame = CGRectMake(start.x, start.y, size.width, size.height);
		imageView.layer.cornerRadius = kCornerRadius;
	}
	
	if (_theme.imagePath) {
		[imageView setImageWithURL:[NSURL URLWithString:_theme.imagePath]];
		//[imageView setImage:[UIImage imageFromColor:[UIColor randomColor]]];
	}
}

@end
