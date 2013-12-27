//
//  FDFirstViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAroundViewController.h"
#import "FDPhotoCollectionViewCell.h"
#import "FDUser.h"
#import "FDLikesView.h"
#import "FDDetailsViewController.h"

@interface FDAroundViewController () <PSUICollectionViewDelegate, PSUICollectionViewDataSource, FDPhotoCollectionViewCellDelegate, CLLocationManagerDelegate>

@property (readwrite) NSArray *tweets;
@property (readwrite) PSUICollectionView *photosCollectionView;
@property (readwrite) CLLocationManager *locationManager;
@property (readwrite) CLLocation *location;
@property (readwrite) BOOL noMore;
@property (readwrite) UIActivityIndicatorView *spinner;

@end

@implementation FDAroundViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"附近", nil);
		self.title = identifier;
		
		UIImage *normalImage = [UIImage imageNamed:@"Around"];
		UIImage *selectedImage = [UIImage imageNamed:@"AroundHighlighted"];
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
			[self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:normalImage tag:0];
			[self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
		}
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//self.view.backgroundColor = [UIColor whiteColor];

	CGRect frame = self.view.bounds;
	frame.size.height += 30;//故意的，这样拉不到底，用户会尝试去拉到底，然后就会刷新
	_photosCollectionView = [[PSUICollectionView alloc] initWithFrame:frame collectionViewLayout:[PSUICollectionViewFlowLayout aroundPhotoLayout]];
	_photosCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photosCollectionView.backgroundColor = [UIColor clearColor];
	[_photosCollectionView registerClass:[FDPhotoCollectionViewCell class] forCellWithReuseIdentifier:kFDPhotoCollectionViewCellIdentifier];
	_photosCollectionView.delegate = self;
	_photosCollectionView.dataSource = self;
	[self.view addSubview:_photosCollectionView];
	
	_locationManager = [[CLLocationManager alloc] init];
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	_locationManager.delegate = self;
	[_locationManager startUpdatingLocation];
	
#if TARGET_IPHONE_SIMULATOR
	[self fetchAroundPhotos];
#endif
}

- (void)fetchAroundPhotos
{
	if (_noMore) return;
	if (!_spinner) {
		_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		_spinner.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.view.bounds) - 25);
		[self.view addSubview:_spinner];
	}
	[_spinner startAnimating];
	NSInteger currentCount = _tweets.count;

#if TARGET_IPHONE_SIMULATOR
	_location = [CLLocation fakeLocation];
#endif
	[[FDAFHTTPClient shared] aroundPhotosAtLocation:_location limit:@(_tweets.count + 8) distance:nil withCompletionBlock:^(BOOL success, NSString *message, NSArray *tweetsData, NSNumber *distance) {
		if (success) {
			if (tweetsData.count == currentCount) {
				[self displayHUDTitle:NSLocalizedString(@"已经显示全部", nil) message:nil duration:0.5];
				_noMore = YES;
				_photosCollectionView.frame = self.view.bounds;
			}
			_tweets = [FDTweet createMutableWithData:tweetsData];
			[_photosCollectionView reloadData];
		}
		[_spinner stopAnimating];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - FDPhotoCollectionViewCellDelegate

- (void)photoCell:(FDPhotoCollectionViewCell *)photoCell willLikeOrUnlikePhoto:(FDPhoto *)photo
{
	[[FDAFHTTPClient shared] likeOrUnlikePhoto:photo.ID withCompletionBlock:^(BOOL success, NSString *message, NSNumber *liked, NSNumber *likes) {
		if (success) {
			photoCell.photo.likes = likes;
			photoCell.likesView.likes = likes;
			photoCell.likesView.liked = liked;
		}
	}];
}

#pragma mark - PSUICollectionViewDelegate

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [FDSize aroundPhotoSize];
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return _tweets.count;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
	FDTweet *tweet = _tweets[indexPath.row];
	cell.tweet = tweet;
	cell.delegate = self;
	return cell;
}

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDDetailsViewController *detailsViewController = [[FDDetailsViewController alloc] init];
	detailsViewController.hidesBottomBarWhenPushed = YES;
	FDTweet *tweet = _tweets[indexPath.row];
	if (tweet.photos.count) {
		detailsViewController.photo = tweet.photos[0];
	}
	[self.navigationController pushViewController:detailsViewController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height) {
		[self fetchAroundPhotos];
	}
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	if (_location) return;
	if (locations.count) {
		_location = locations[0];
		[self fetchAroundPhotos];
	}
}

//ios6
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	if (_location) return;
	_location = newLocation;
	[self fetchAroundPhotos];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	[manager stopUpdatingLocation];
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"定位服务不可用", nil) message:NSLocalizedString(@"去设置定位服务", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:NSLocalizedString(@"详情", nil), nil];
		alertView.delegate = self;
		[alertView show];
	}
	
	[self fetchAroundPhotos];
}

@end
