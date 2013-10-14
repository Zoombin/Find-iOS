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

+ (UIImage *)heartGray
{
	static UIImage *heartGray;
	if (!heartGray) {
		heartGray = [UIImage imageNamed:@"HeartGray"];
	}
	return heartGray;
}

+ (UIImage *)heartRed
{
	static UIImage *heartRed;
	if (!heartRed) {
		heartRed = [UIImage imageNamed:@"HeartRed"];
	}
	return heartRed;
}

+ (CGSize)heartSize
{
	UIImage *heart = [self heartGray];
	return heart.size;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.contentMode = UIViewContentModeScaleAspectFit;
	
		CGSize heartSize = CGSizeMake(25, 25);
		
		heartView = [[UIImageView alloc] initWithImage:[[self class] heartGray]];
		heartView.contentMode = UIViewContentModeScaleAspectFit;
		heartView.frame = CGRectMake((frame.size.width - heartSize.width) / 2, (frame.size.height - heartSize.height) / 2, heartSize.width, heartSize.height);
		[self addSubview:heartView];
		
		likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, heartSize.width, heartSize.height)];
		likesLabel.adjustsFontSizeToFitWidth = YES;
		likesLabel.textColor = [UIColor whiteColor];
		likesLabel.textAlignment = NSTextAlignmentCenter;
		likesLabel.backgroundColor = [UIColor clearColor];
		likesLabel.font = [UIFont fdThemeFontWithSize:12];
		[heartView addSubview:likesLabel];
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(willLikeOrUnlike)];
		[self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setLikes:(NSNumber *)likes
{
	_likes = likes;
	likesLabel.text = [_likes stringValue];
}

- (void)setLiked:(NSNumber *)liked
{
	_liked = liked;
	heartView.image = _liked.boolValue ? [[self class] heartRed] : [[self class] heartGray];
}

- (void)willLikeOrUnlike
{
	[_delegate willLikeOrUnlike];
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
