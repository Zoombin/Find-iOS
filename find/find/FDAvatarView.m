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
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor randomColor];//TODO:test
    }
    return self;
}

- (void)setUserID:(NSNumber *)userID
{
	if (_userID == userID) return;
	_userID = userID;
	
	//NSInteger idx = arc4random() % 50 + 1;//TODO: test
	//NSString *path = [NSString stringWithFormat:@"%@%d.jpg", @"http://find.qiniudn.com/", 1];
	//[self setImageWithURL:[NSURL URLWithString:path]];
}

- (void)setImagePath:(NSString *)imagePath
{
	if (_imagePath == imagePath) {
		return;
	};
	_imagePath = imagePath;
	if (_imagePath) {
		[[[UIImageView alloc] init] setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_imagePath]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
			[self setImage:image];
		} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
		}];
	}
}

+ (CGSize)defaultSize
{
	return CGSizeMake(35, 35);
}

+ (CGSize)bigSize
{
	return CGSizeMake(65, 65);
}

@end
