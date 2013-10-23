//
//  FDAvatarView.m
//  find
//
//  Created by zhangbin on 9/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAvatarView.h"

@implementation FDAvatarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.layer.cornerRadius = 4;
		self.backgroundColor = [UIColor randomColor];//TODO:test
    }
    return self;
}

- (void)setUserID:(NSNumber *)userID
{
	if (_userID == userID) return;
	_userID = userID;
	
	//NSInteger idx = arc4random() % 50 + 1;//TODO: test
	NSString *path = [NSString stringWithFormat:@"%@%d.jpg", QINIU_FIND, 1];
	[self setImageWithURL:[NSURL URLWithString:path]];
}

+ (CGSize)defaultSize
{
	return CGSizeMake(35, 35);
}

@end
