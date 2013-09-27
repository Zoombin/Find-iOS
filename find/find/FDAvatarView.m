//
//  FDAvatarView.m
//  find
//
//  Created by zhangbin on 9/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAvatarView.h"

@implementation FDAvatarView
{
	UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.layer.cornerRadius = 5;
		
        imageView = [[UIImageView alloc] initWithFrame:frame];
		imageView.layer.cornerRadius = 5;
		//imageView.layer.masksToBounds = YES;
		[self addSubview:imageView];
    }
    return self;
}

- (void)setUserID:(NSNumber *)userID
{
	if (_userID == userID) return;
	_userID = userID;
	
	NSString *path = [NSString stringWithFormat:@"%@%@", QINIU_HOST, @"1.jpg"];//TODO: test
	[imageView setImageWithURL:[NSURL URLWithString:path]];
}

+ (CGSize)defaultSize
{
	return CGSizeMake(35, 35);
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
