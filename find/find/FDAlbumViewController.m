//
//  FDAlbumViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAlbumViewController.h"
#import "FDPhotoCollectionViewCell.h"
#import "FDAddTweetCollectionViewCell.h"
#import "FDWebViewController.h"

static NSInteger indexOfAlertDetails = 1;
static NSInteger numberOfTweetsPerLine = 3;

@interface FDAlbumViewController ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
PSUICollectionViewDelegate,
PSUICollectionViewDataSource,
FDAddTweetCollectionViewCellDelegate,
CLLocationManagerDelegate
>

@property (readwrite) PSUICollectionView *photosCollectionView;
@property (readwrite) NSArray *tweets;
@property (readwrite) CLLocationManager *locationManager;
@property (readwrite) CLLocation *location;
@property (readwrite) NSString *address;
@property (readwrite) NSInteger tweetsCount;
@property (readwrite) BOOL noMore;
@property (readwrite) UIActivityIndicatorView *spinner;

@end

@implementation FDAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *identifier = NSLocalizedString(@"Album", nil);
		self.title = identifier;
		
		UIImage *normalImage = [UIImage imageNamed:@"Camera"];
		UIImage *selectedImage = [UIImage imageNamed:@"CameraHighlighted"];
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
			[self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:normalImage tag:0];
			[self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
		}
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(fetchTweets)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//self.view.backgroundColor = [UIColor whiteColor];
	
	CGRect frame = self.view.bounds;
	frame.size.height += 30;//故意的，这样拉不到底，用户会尝试去拉到底，然后就会刷新
	_photosCollectionView = [[PSUICollectionView alloc] initWithFrame:frame collectionViewLayout:[PSUICollectionViewFlowLayout smallSquaresLayout]];
	_photosCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photosCollectionView.backgroundColor = [UIColor clearColor];
	[_photosCollectionView registerClass:[FDPhotoCollectionViewCell class] forCellWithReuseIdentifier:kFDPhotoCollectionViewCellIdentifier];
	[_photosCollectionView registerClass:[FDAddTweetCollectionViewCell class] forCellWithReuseIdentifier:kFDAddTweetCollectionViewCellIdentifier];
	_photosCollectionView.delegate = self;
	_photosCollectionView.dataSource = self;
	[self.view addSubview:_photosCollectionView];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSignout) name:SIGNOUT_NOTIFICATION_IDENTIFIER object:nil];
	
	NSInteger firstLoadNumber = 14;
	_tweetsCount = firstLoadNumber;
	[self fixAskMoreTweetsCount];
	[self fetchTweets];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)addTweet
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Snap a New", @"Pick From Photo Library", nil];
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)fetchTweets
{
	if (_noMore) return;
	if (!_spinner) {
		_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		_spinner.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.view.bounds) - 25);
		_spinner.backgroundColor = [UIColor randomColor];
		[self.view addSubview:_spinner];
	}
	//[self.view bringSubviewToFront:_spinner];
	[_spinner startAnimating];
	NSInteger currentCount = _tweets.count;
	_tweetsCount += 9;
	[self fixAskMoreTweetsCount];
	if ([[FDAFHTTPClient shared] isSessionValid]) {
		[[FDAFHTTPClient shared] tweetsPublished:nil limit:@(_tweetsCount) withCompletionBlock:^(BOOL success, NSString *message, NSNumber *published, NSArray *tweetsData) {
			if (success) {
				if (tweetsData.count == currentCount) {
					[self displayHUDTitle:NSLocalizedString(@"已经显示全部", nil) message:nil duration:0.5];
					_noMore = YES;
					_photosCollectionView.frame = self.view.bounds;
				}
				_tweets = [FDTweet createMutableWithData:tweetsData];
				_tweetsCount = _tweets.count;
				[_photosCollectionView reloadData];
			}
			[_spinner stopAnimating];
		}];
	}
}

- (void)fixAskMoreTweetsCount
{
	NSInteger m = (_tweetsCount + 1) % numberOfTweetsPerLine;//+1 means add tweet button
	if (m != 0) {
		_tweetsCount += numberOfTweetsPerLine - m;
	}
}

- (void)parseToAddressWithLocation:(CLLocation *)loation
{
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	[geocoder reverseGeocodeLocation:loation completionHandler:^(NSArray *placemarks, NSError *error) {
		NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
		if (error){
			NSLog(@"Geocode failed with error: %@", error);
			return;
		}
		if(placemarks.count) {
			CLPlacemark *topResult = placemarks[0];
			
			NSLog(@"name: %@", [topResult name]);
			NSLog(@"thoroughfare: %@", [topResult thoroughfare]);
			NSLog(@"subThoroughfare: %@", [topResult subThoroughfare]);
			NSLog(@"locality: %@", [topResult locality]);
			NSLog(@"subLocality: %@", [topResult subLocality]);
			NSLog(@"administrativeArea: %@", [topResult administrativeArea]);
			NSLog(@"subAdministrativeArea: %@", [topResult subAdministrativeArea]);
			NSLog(@"postalCode: %@", [topResult postalCode]);
			NSLog(@"ISOcountryCode: %@", [topResult ISOcountryCode]);
			NSLog(@"country: %@", [topResult country]);
			NSLog(@"inlandWater: %@", [topResult inlandWater]);
			NSLog(@"ocean: %@", [topResult ocean]);
			NSLog(@"areasOfInterest: %@", [topResult areasOfInterest]);
			
			NSMutableString *addr = [NSMutableString stringWithFormat:@""];
			if ([topResult subLocality]) {
				[addr appendFormat:@"%@", [topResult subLocality]];
			}
			if ([topResult thoroughfare]) {
				[addr appendFormat:@" %@", [topResult thoroughfare]];
			}
			if ([topResult name]) {
				if ([[topResult name] interestingPlace]) {
					[addr appendFormat:@" %@", [topResult name]];
				}
			}
			_address = addr;
			NSLog(@"_address: %@", _address);
		}
	}];
}

- (void)didSignout
{
	_tweets = nil;
	_tweetsCount = 0;
	_noMore = NO;
	[_photosCollectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SIGNOUT_NOTIFICATION_IDENTIFIER object:nil];
}

#pragma mark - PSUICollectionViewDelegate

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [FDSize tweetPhotoSize];
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return _tweets.count + 1;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		FDAddTweetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDAddTweetCollectionViewCellIdentifier forIndexPath:indexPath];
		cell.delegate = self;
		return cell;
	} else {
		FDPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCollectionViewCellIdentifier forIndexPath:indexPath];
		[cell hideDetails];
		FDTweet *tweet = _tweets[indexPath.row - 1];
		cell.tweet = tweet;
		//cell.delegate = self;
		return cell;
	}
}

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	//	FDPhotoDetailsViewController *photoDetailsViewController = [[FDPhotoDetailsViewController alloc] init];
	//	FDTweet *tweet = tweets[indexPath.row];
	//	if (tweet.photos.count) {
	//		photoDetailsViewController.photo = tweet.photos[0];
	//	}
	//	[self.navigationController pushViewController:photoDetailsViewController animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height) {
		[self fetchTweets];
	}
}

#pragma mark - FDAddTweetCollectionViewCellDelegate

- (void)willAddTweet
{
	NSLog(@"add tweet");
	if ([[FDAFHTTPClient shared] isSessionValid]) {
		if (!_locationManager) {
			_locationManager = [[CLLocationManager alloc] init];
			_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
			_locationManager.delegate = self;
			[_locationManager startUpdatingLocation];
		}
		[self addTweet];
	} else {
		[self displayHUDTitle:NSLocalizedString(@"Need Login", nil) message:NSLocalizedString(@"You must login first.", nil)];
	}
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.delegate = self;
			imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
			if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
				imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
			}
			[self presentViewController:imagePickerController animated:YES completion:nil];
		}
	} else if (buttonIndex == 1) {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
			UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
			imagePickerController.delegate = self;
			[self presentViewController:imagePickerController animated:YES completion:nil];
		}
	}
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self displayHUD:NSLocalizedString(@"Uploading", nil)];
	[picker dismissViewControllerAnimated:YES completion:^{
		UIImage *image = info[UIImagePickerControllerOriginalImage];
		NSString *path = [NSString photoPathWithUserID:[[FDAFHTTPClient shared] userID]];
		NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
		[[ZBQNAFHTTPClient shared] uploadData:imageData name:path withCompletionBlock:^(BOOL success) {
			if (success) {
				[[FDAFHTTPClient shared] tweetPhotos:@[path] atLocation:_location address:_address withCompletionBlock:^(BOOL success, NSString *message) {
					[self displayHUDTitle:@"Upload successfully" message:nil duration:1.0];
					_tweetsCount++;
					[self fetchTweets];
				}];
			} else {
				[self hideHUD:YES];
			}
		}];
	}];
}
		 
#pragma mark - CLLocationManagerDelegate
		 
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	if (_location) return;
	if (locations.count) {
		NSLog(@"first location: %@", [locations[0] coordinateString]);
		_location = locations[0];
		[self parseToAddressWithLocation:_location];
		[manager stopUpdatingLocation];
	}
}
 
//ios6
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	if (_location) return;
	_location = newLocation;
	[self parseToAddressWithLocation:_location];
	[manager stopUpdatingLocation];
	NSLog(@"newLocation: %@", [newLocation coordinateString]);
}
 
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	[manager stopUpdatingLocation];
	_location = nil;
	_address = nil;
	
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location Service Is Not Available", nil) message:NSLocalizedString(@"You need open location service in Settings.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:NSLocalizedString(@"View Details", nil), nil];
		alertView.delegate = self;
		[alertView show];
	}
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == indexOfAlertDetails) {
		FDWebViewController *webViewController = [[FDWebViewController alloc] init];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
		[self.navigationController presentViewController:navigationController animated:YES completion:nil];
	}
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
		if (((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
			[[UIApplication sharedApplication] setStatusBarHidden:NO];
			[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
		}
    }
}
@end
