//
//  FDAskForMoreCollectionSupplementaryView.m
//  find
//
//  Created by zhangbin on 12/13/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAskForMoreCollectionSupplementaryView.h"

@interface FDAskForMoreCollectionSupplementaryView ()

@property (readwrite) UILabel *moreLabel;

@end

@implementation FDAskForMoreCollectionSupplementaryView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		
		_moreLabel = [[UILabel alloc] initWithFrame:self.bounds];
		_moreLabel.text = NSLocalizedString(@"点击查看更多", nil);
		_moreLabel.textColor = [UIColor grayColor];
		_moreLabel.textAlignment = NSTextAlignmentCenter;
		_moreLabel.userInteractionEnabled = YES;
		[self addSubview:_moreLabel];
		
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
		[_moreLabel addGestureRecognizer:tapGestureRecognizer];
	}
	return self;
}

+ (CGFloat)height
{
	return 50;
}

- (void)tapped
{
	[_delegate askForMore];
}

@end
