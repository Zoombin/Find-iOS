//
//  FDLikesView.m
//  find
//
//  Created by zhangbin on 9/17/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDLikesView.h"

@implementation FDLikesView
{
	UIImageView *heartView;
	UILabel *likesLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.contentMode = UIViewContentModeScaleAspectFit;
		
		UIImage *heart = [UIImage imageNamed:@"Heart"];
		
		heartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Heart"]];
		heartView.contentMode = UIViewContentModeScaleAspectFit;
		heartView.frame = CGRectMake((frame.size.width - heart.size.width) / 2, (frame.size.height - heart.size.height) / 2, heart.size.width, heart.size.height);
		[self addSubview:heartView];
		
		likesLabel = [[UILabel alloc] initWithFrame:self.bounds];
		likesLabel.adjustsFontSizeToFitWidth = YES;
		likesLabel.textColor = [UIColor whiteColor];
		likesLabel.textAlignment = NSTextAlignmentCenter;
		likesLabel.backgroundColor = [UIColor clearColor];
		likesLabel.font = [UIFont boldSystemFontOfSize:12];
		[self addSubview:likesLabel];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
		[self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setLikes:(NSNumber *)likes
{
	_likes = likes;
	likesLabel.text = [_likes stringValue];
}

- (void)tapped
{
	if (!_liked.boolValue) {
		[self willLike];
	} else {
		[self willUnlike];
	}
}

- (void)willLike
{
	[_delegate willLike];
}

- (void)willUnlike
{
	[_delegate willUnlike];
}


+ (CGSize)size
{
	return CGSizeMake(45, 45);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
