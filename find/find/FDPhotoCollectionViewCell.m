//
//  FDPhotoCollectionViewCell.m
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhotoCollectionViewCell.h"

@interface FDPhotoCollectionViewCell () <FDLikesViewDelegate>

@property (readwrite) UIImageView *photoView;
@property (readwrite) UILabel *distanceLabel;
@property (readwrite) UIImageView *distanceIcon;

@end

@implementation FDPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.layer.borderWidth = 0.5;
		self.layer.borderColor = [[UIColor grayColor] CGColor];
		self.backgroundColor = [UIColor whiteColor];
		
		CGPoint start = CGPointZero;
		
		_photoView = [[UIImageView alloc] initWithFrame:CGRectMake(start.x, start.y, self.bounds.size.width, self.bounds.size.width)];
		_photoView.contentMode = UIViewContentModeScaleAspectFit;
		_photoView.userInteractionEnabled = YES;
		[self.contentView addSubview:_photoView];
		
		start = CGPointMake(0, CGRectGetMaxY(_photoView.frame) - 20);
		
		_distanceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Around"]];
		_distanceIcon.contentMode = UIViewContentModeScaleAspectFit;
		_distanceIcon.frame = CGRectMake(start.x, start.y, 17, 17);
		[self.contentView addSubview:_distanceIcon];
		
		start = CGPointMake(CGRectGetMaxX(_distanceIcon.frame), CGRectGetMinY(_distanceIcon.frame));
		
		_distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, self.bounds.size.width - start.x, self.bounds.size.height - start.y)];
		_distanceLabel.backgroundColor = [UIColor clearColor];
		_distanceLabel.font = [UIFont fdThemeFontOfSize:13];
		_distanceLabel.textColor = [UIColor fdThemeRed];
		_distanceLabel.adjustsFontSizeToFitWidth = YES;
		[self.contentView addSubview:_distanceLabel];
    }
    return self;
}

- (void)setTweet:(FDTweet *)tweet
{
	if (_tweet == tweet) return;
	_tweet = tweet;
	
	if (_tweet.distance) {
		_distanceLabel.text = [_tweet.distance printableDistance];
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
	CGSize pxSize = CGSizeMake(_photoView.bounds.size.width * 2, _photoView.bounds.size.height * 2);
	[_photoView setImageWithURL:[NSURL URLWithString:[_photo urlstringCropToSize:pxSize]]];
	
	[self setPhotoInfo];
}

//- (void)setPhoto:(FDPhoto *)photo scaleFitWidth:(CGFloat)width completionBlock:(dispatch_block_t)block
//{
//	if (_photo == photo) return;
//	_photo = photo;
//	
//	NSURL *url = [NSURL URLWithString:[_photo urlStringScaleFitWidth:width]];
//	[[UIImageView alloc] setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//		_photoView.image = image;
//		if (block) block();
//	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//		if (block) block();
//	}];
//	[self setPhotoInfo];
//}

- (void)setPhotoInfo
{
	CGPoint start = CGPointMake(CGRectGetMaxX(self.bounds) - [FDLikesView size].width, CGRectGetMaxY(_photoView.frame) - 35);

	_likesView = [[FDLikesView alloc] initWithFrame:CGRectMake(start.x, start.y, [FDLikesView size].width, [FDLikesView size].height)];
	_likesView.delegate = self;
	[self.contentView addSubview:_likesView];
	_likesView.likes = _photo.likes;
	_likesView.liked = _photo.liked;
	
	//TODO: for test. displaying photo id
	//NSString *displayedInfo = [NSString stringWithFormat:@"%@ pid: %@", [_tweet.distance printableDistance], _photo.ID];
	NSString *displayedInfo = [_tweet.distance printableDistance];
	_distanceLabel.text = displayedInfo;
}

- (void)hideDetails
{
	_likesView.hidden = YES;
	_distanceIcon.hidden = YES;
	_distanceLabel.hidden = YES;
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
	_photoView.image = nil;
	_likesView.likes = nil;
	_likesView.liked = nil;
	[_likesView removeFromSuperview];
}

@end
