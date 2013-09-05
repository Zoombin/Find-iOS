//
//  FDPhotoCell.m
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhotoCell.h"
#import "UIImageView+AFNetworking.h"

@implementation FDPhotoCell
{
	UIImageView *photoView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blueColor];
		photoView = [[UIImageView alloc] initWithFrame:self.bounds];
		_displaySize = self.bounds.size;
		photoView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:photoView];
    }
    return self;
}

- (void)setUser:(FDUser *)user
{
	if (_user == user) return;
	_user = user;
}

- (void)setPhoto:(FDPhoto *)photo
{
	if (_photo == photo) return;
	_photo = photo;
	[photoView setImageWithURL:[NSURL URLWithString:[_photo urlStringScaleAspectFit:_displaySize]]];
}

- (void)setPhoto:(FDPhoto *)photo scaleFitWidth:(CGFloat)width completionBlock:(dispatch_block_t)block
{
	if (_photo == photo) return;
	_photo = photo;
	UIImageView *iView = [[UIImageView alloc] init];
	
	NSURL *url = [NSURL URLWithString:[_photo urlStringScaleFitWidth:width]];
	[iView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
		photoView.image = image;
		_displaySize = image.size;
		if (block) block();
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
		if (block) block();
	}];
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
