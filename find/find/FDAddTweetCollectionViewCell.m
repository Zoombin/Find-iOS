//
//  FDAddTweetCollectionViewCell.m
//  find
//
//  Created by zhangbin on 12/4/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAddTweetCollectionViewCell.h"

@implementation FDAddTweetCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.layer.borderWidth = 0.5;
		self.layer.borderColor = [[UIColor grayColor] CGColor];
		self.backgroundColor = [UIColor whiteColor];
		
		UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
		addButton.frame = self.bounds;
		[addButton setImage:[UIImage imageNamed:@"AlbumListCamera"] forState:UIControlStateNormal];
		[addButton setImage:[UIImage imageNamed:@"AlbumListCameraHL"] forState:UIControlStateHighlighted];
		[addButton addTarget:self action:@selector(addTweet) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:addButton];
		
		//CGPoint start = CGPointZero;
		
//		_photoView = [[UIImageView alloc] initWithFrame:CGRectMake(start.x, start.y, self.bounds.size.width, self.bounds.size.width)];
//		_photoView.contentMode = UIViewContentModeScaleAspectFit;
//		_photoView.userInteractionEnabled = YES;
//		[self addSubview:_photoView];
//		
//		start = CGPointMake(5, CGRectGetMaxY(_photoView.frame));
//		
//		_distanceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Location"]];
//		_distanceIcon.contentMode = UIViewContentModeScaleAspectFit;
//		_distanceIcon.frame = CGRectMake(start.x, start.y, 22, 27);
//		[self addSubview:_distanceIcon];
//		
//		start = CGPointMake(CGRectGetMaxX(_distanceIcon.frame), CGRectGetMaxY(_photoView.frame));
//		
//		_distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, self.bounds.size.width - start.x, self.bounds.size.height - start.y)];
//		_distanceLabel.backgroundColor = [UIColor clearColor];
//		_distanceLabel.font = [UIFont fdThemeFontOfSize:18];
//		_distanceLabel.adjustsFontSizeToFitWidth = YES;
//		[self addSubview:_distanceLabel];
//		
//		start = CGPointMake(CGRectGetMaxX(self.bounds) - [FDLikesView size].width, CGRectGetMaxY(_photoView.frame) - 7);
//		
//		_likesView = [[FDLikesView alloc] initWithFrame:CGRectMake(start.x, start.y, [FDLikesView size].width, [FDLikesView size].height)];
//		_likesView.delegate = self;
//		[self addSubview:_likesView];
    }
    return self;
}

- (void)addTweet
{
	[_delegate willAddTweet];
}

@end
