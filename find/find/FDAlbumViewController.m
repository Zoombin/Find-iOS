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
#import "FDAskForMoreCollectionSupplementaryView.h"

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
CLLocationManagerDelegate,
FDAskForMoreCollectionSupplementaryViewDelegate
>

@property (readwrite) PSUICollectionView *photosCollectionView;
@property (readwrite) NSArray *tweets;
@property (readwrite) CLLocationManager *locationManager;
@property (readwrite) CLLocation *location;
@property (readwrite) NSString *address;
@property (readwrite) NSInteger tweetsCount;

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
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:normalImage selectedImage:selectedImage];
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:normalImage tag:0];
			[self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
		}
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshMyTweets)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	NSInteger firstLoadNumber = 20;
	_tweetsCount = firstLoadNumber;
	[self fixAskMoreTweetsCount];
	
	_photosCollectionView = [[PSUICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSUICollectionViewFlowLayout smallSquaresLayout]];
	_photosCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photosCollectionView.backgroundColor = [UIColor clearColor];
	[_photosCollectionView registerClass:[FDPhotoCollectionViewCell class] forCellWithReuseIdentifier:kFDPhotoCollectionViewCellIdentifier];
	[_photosCollectionView registerClass:[FDAddTweetCollectionViewCell class] forCellWithReuseIdentifier:kFDAddTweetCollectionViewCellIdentifier];
	[_photosCollectionView registerClass:[FDAskForMoreCollectionSupplementaryView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionFooter withReuseIdentifier:kFDAskForMoreCollectionSupplementaryViewIdentifier];
	_photosCollectionView.delegate = self;
	_photosCollectionView.dataSource = self;
	[self.view addSubview:_photosCollectionView];

	[self fetchTweets:^{
		[_photosCollectionView reloadData];
	}];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)addTweet
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Snap a New", @"Pick From Photo Library", nil];
	[actionSheet showInView:self.view];
}

- (void)refreshMyTweets
{
	[self fetchTweets:^{
		[_photosCollectionView reloadData];
	}];
}

- (void)fixAskMoreTweetsCount
{
	NSInteger m = (_tweetsCount + 1) % numberOfTweetsPerLine;//+1 means add tweet button
	if (m != 0) {
		_tweetsCount += numberOfTweetsPerLine - m;
	}
}

- (void)fetchTweets:(dispatch_block_t)block
{
	if ([[FDAFHTTPClient shared] isSessionValid]) {
		[[FDAFHTTPClient shared] tweetsPublished:nil limit:@(_tweetsCount) withCompletionBlock:^(BOOL success, NSString *message, NSNumber *published, NSArray *tweetsData) {
			if (success) {
				_tweets = [FDTweet createMutableWithData:tweetsData];
				_tweetsCount = _tweets.count;
			}
			if (block) block ();
		}];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
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
		return cell;
	}
	//cell.delegate = self;
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
		askForMoreView.delegate = self;
	}
    return supplementaryView;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
	return CGSizeMake(_photosCollectionView.frame.size.width, [FDAskForMoreCollectionSupplementaryView height]);
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
		NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
		[[ZBQNAFHTTPClient shared] uploadData:imageData name:path withCompletionBlock:^(BOOL success) {
			if (success) {
				[[FDAFHTTPClient shared] tweetPhotos:@[path] atLocation:_location address:_address withCompletionBlock:^(BOOL success, NSString *message) {
					[self displayHUDTitle:@"Upload successfully" message:nil duration:1.0];
					_tweetsCount++;
					[self fetchTweets:^{
						[_photosCollectionView reloadData];
					}];
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

#pragma mark - FDAskForMoreCollectionSupplementaryViewDelegate

- (void)askForMore
{
	NSLog(@"ask for more");
	NSInteger erveryAskNumber = 21;
	_tweetsCount += erveryAskNumber;
	[self fixAskMoreTweetsCount];
	[self fetchTweets:^{
		[_photosCollectionView reloadData];
	}];
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
