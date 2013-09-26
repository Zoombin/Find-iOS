//
//  FDPhotoCell.m
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhotoCell.h"
#import "UIImageView+AFNetworking.h"

@interface FDPhotoCell () <FDLikesViewDelegate>

@end

@implementation FDPhotoCell
{
	UIImageView *photoView;
	UILabel *distanceLabel;
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
		
		_likesView = [[FDLikesView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - [FDLikesView size].width, 0, [FDLikesView size].width, [FDLikesView size].height)];
		_likesView.delegate = self;
		[self addSubview:_likesView];
		
		distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 20, frame.size.width, 20)];
		distanceLabel.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
		distanceLabel.textColor = [UIColor whiteColor];
		distanceLabel.font = [UIFont boldSystemFontOfSize:12];
		distanceLabel.adjustsFontSizeToFitWidth = YES;
		distanceLabel.textAlignment = NSTextAlignmentRight;
		[self addSubview:distanceLabel];
    }
    return self;
}

- (void)setTweet:(FDTweet *)tweet
{
	if (_tweet == tweet) return;
	_tweet = tweet;
	
	if (_tweet.distance) {
		distanceLabel.text = [_tweet.distance printableDistance];
	}
	
	if (_tweet.photos.count) {
		self.photo = _tweet.photos[0];//TODO: take the most likes photo better
	}
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
	
	if (_photo.likes) {
		_likesView.likes = _photo.likes;
	}
	
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
	
	if (_photo.likes) {
		_likesView.likes = _photo.likes;
	}
}

#pragma mark - FDLikesViewDelegate

- (void)willLikeOrUnlike
{
	[_delegate photoCell:self willLikeOrUnlikePhoto:_photo];
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
