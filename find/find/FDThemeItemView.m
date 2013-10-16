//
//  FDThemeItemView.m
//  find
//
//  Created by zhangbin on 9/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDThemeItemView.h"

@implementation FDThemeItemView
{
	UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor randomColor];
		
		imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:imageView];
    }
    return self;
}

- (void)setTheme:(FDTheme *)theme
{
	if (_theme == theme) return;
	_theme = theme;
	
	if (_theme.imagePath) {
		NSLog(@"imagePath: %@", _theme.imagePath);
		[imageView setImageWithURL:[NSURL URLWithString:_theme.imagePath]];
	}
}

@end
