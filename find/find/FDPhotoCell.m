//
//  FDPhotoCell.m
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhotoCell.h"

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
		self.layer.borderWidth = 0.5;
		self.layer.borderColor = [[UIColor grayColor] CGColor];
		self.backgroundColor = [UIColor whiteColor];
		
		CGPoint start = CGPointZero;
		
		photoView = [[UIImageView alloc] initWithFrame:CGRectMake(start.x, start.y, self.bounds.size.width, self.bounds.size.width)];
		_displaySize = photoView.frame.size;
		photoView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:photoView];
		
		start = CGPointMake(5, CGRectGetMaxY(photoView.frame));
		
		UIImageView *distanceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Around"]];
		distanceIcon.contentMode = UIViewContentModeScaleAspectFit;
		distanceIcon.frame = CGRectMake(start.x, start.y, 22, 27);
		[self addSubview:distanceIcon];
		
		start = CGPointMake(CGRectGetMaxX(distanceIcon.frame), CGRectGetMaxY(photoView.frame));
		
		distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, self.bounds.size.width - start.x, self.bounds.size.height - start.y)];
		distanceLabel.backgroundColor = [UIColor clearColor];
		distanceLabel.font = [UIFont fdThemeFontOfSize:18];
		distanceLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview:distanceLabel];
		
		start = CGPointMake(CGRectGetMaxX(self.bounds) - [FDLikesView size].width, CGRectGetMaxY(photoView.frame) - 7);
		
		_likesView = [[FDLikesView alloc] initWithFrame:CGRectMake(start.x, start.y, [FDLikesView size].width, [FDLikesView size].height)];
		_likesView.delegate = self;
		[self addSubview:_likesView];
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
	
	[self setPhotoInfo];
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
	
	[self setPhotoInfo];
}

- (void)setPhotoInfo
{
	_likesView.likes = _photo.likes;
	_likesView.liked = _photo.liked;
	
	//TODO: for test. displaying photo id
	//NSString *displayedInfo = [NSString stringWithFormat:@"%@ pid: %@", [_tweet.distance printableDistance], _photo.ID];
	NSString *displayedInfo = [_tweet.distance printableDistance];
	distanceLabel.text = displayedInfo;
}

#pragma mark - FDLikesViewDelegate

- (void)willLikeOrUnlike
{
	[_delegate photoCell:self willLikeOrUnlikePhoto:_photo];
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	_photo = nil;
	_tweet = nil;
	photoView.image = nil;
}

@end
