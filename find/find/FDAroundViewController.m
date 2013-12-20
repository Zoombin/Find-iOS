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
#import "FDAskForMoreCollectionSupplementaryView.h"

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
		NSString *identifier = NSLocalizedString(@"Around", nil);
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
	self.view.backgroundColor = [UIColor whiteColor];

	_photosCollectionView = [[PSUICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSUICollectionViewFlowLayout aroundPhotoLayout]];
	_photosCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photosCollectionView.backgroundColor = [UIColor clearColor];
	[_photosCollectionView registerClass:[FDPhotoCollectionViewCell class] forCellWithReuseIdentifier:kFDPhotoCollectionViewCellIdentifier];
	[_photosCollectionView registerClass:[FDAskForMoreCollectionSupplementaryView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionFooter withReuseIdentifier:kFDAskForMoreCollectionSupplementaryViewIdentifier];
	_photosCollectionView.delegate = self;
	_photosCollectionView.dataSource = self;
	[self.view addSubview:_photosCollectionView];
	
	_locationManager = [[CLLocationManager alloc] init];
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	_locationManager.delegate = self;
	[_locationManager startUpdatingLocation];
}

- (void)fetchAroundPhotos
{
	if (_noMore) return;
	if (!_spinner) {
		_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		_spinner.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.view.bounds) - 25);
		[self.view addSubview:_spinner];
	}
	[_spinner startAnimating];
	NSInteger currentCount = _tweets.count;
	[[FDAFHTTPClient shared] aroundPhotosAtLocation:_location limit:@(_tweets.count + 30) distance:nil withCompletionBlock:^(BOOL success, NSString *message, NSArray *tweetsData, NSNumber *distance) {
		if (success) {
			if (tweetsData.count == currentCount) {
				_noMore = YES;
			}
			_tweets = [FDTweet createMutableWithData:tweetsData];
			[_photosCollectionView reloadData];
			[_spinner stopAnimating];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
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

- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	NSString *identifier = nil;
	if ([kind isEqualToString:PSTCollectionElementKindSectionFooter]) {
		identifier = kFDAskForMoreCollectionSupplementaryViewIdentifier;
	}
    PSUICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
	if ([supplementaryView isKindOfClass:[FDAskForMoreCollectionSupplementaryView class]]) {
		FDAskForMoreCollectionSupplementaryView *askForMoreView = (FDAskForMoreCollectionSupplementaryView *)supplementaryView;
	}
    return supplementaryView;
}

//- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//	return CGSizeMake(_photosCollectionView.frame.size.width, [FDAskForMoreCollectionSupplementaryView height]);
//}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//	if (scrollView.contentOffset.y > scrollView.bounds.origin.y) {
//		NSLog(@"hello");
//	}
//	NSLog(@"scrollView.contentOffset.y: %f", scrollView.contentOffset.y);
//	NSLog(@"bounds: %@", NSStringFromCGRect(scrollView.bounds));
////	if (scrollView.contentOffset.y < CGRectGetHeight(scrollView.bounds)) {
////		//NSLog(@"contentOffset less than bounds");
////		//self.preShopCollectionViewController.collection = self.preCollection;
////	} else if (scrollView.contentOffset.y == CGRectGetHeight(scrollView.bounds)) {
////		//self.nextShopCollectionViewController.collection = self.nextCollection;
////		NSLog(@"scrollView.contentOffset.y: %f", scrollView.contentOffset.y);
////	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.y == scrollView.bounds.origin.y) {
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
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location Service Is Not Available", nil) message:NSLocalizedString(@"You need open location service in Settings.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:NSLocalizedString(@"View Details", nil), nil];
		alertView.delegate = self;
		[alertView show];
	}
	
	[self fetchAroundPhotos];
}

@end
