//
//  FDForthViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDCameraViewController.h"
#import "FDPhotoCollectionViewCell.h"
#import "FDAddTweetCollectionViewCell.h"
#import "FDWebViewController.h"

static NSInteger indexOfAlertDetails = 1;

@interface FDCameraViewController ()
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

@end

@implementation FDCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *identifier = NSLocalizedString(@"Camera", nil);
		self.title = identifier;
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
			[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"CameraHighlighted"] withFinishedUnselectedImage:[UIImage imageNamed:@"Camera"]];
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:@"Camera"] tag:0];
		}
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	_photosCollectionView = [[PSUICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSUICollectionViewFlowLayout smallSquaresLayout]];
	_photosCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photosCollectionView.backgroundColor = [UIColor clearColor];
	[_photosCollectionView registerClass:[FDPhotoCollectionViewCell class] forCellWithReuseIdentifier:kFDPhotoCollectionViewCellIdentifier];
	[_photosCollectionView registerClass:[FDAddTweetCollectionViewCell class] forCellWithReuseIdentifier:kFDAddTweetCollectionViewCellIdentifier];
	_photosCollectionView.delegate = self;
	_photosCollectionView.dataSource = self;
	[self.view addSubview:_photosCollectionView];
	
	if ([[FDAFHTTPClient shared] isSessionValid]) {
		[[FDAFHTTPClient shared] tweetsPublished:nil limit:@(20) withCompletionBlock:^(BOOL success, NSString *message, NSNumber *published, NSArray *tweetsData) {
			if (success) {
				_tweets = [FDTweet createMutableWithData:tweetsData];
				[_photosCollectionView reloadData];
			}
		}];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTweet
{
	[self choosePickerWithDelegate:self];
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
		[self startCameraWithDelegate:self allowsEditing:NO];
	} else if (buttonIndex == 1) {
		[self startPhotoLibraryWithDelegate:self allowsEditing:NO];
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
					[self displayHUDTitle:@"Upload successfully" message:nil];
					
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

@end
