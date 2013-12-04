//
//  FDForthViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDCameraViewController.h"
#import "FDPhotoCell.h"
#import "FDAddTweetCell.h"

@interface FDCameraViewController ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
PSUICollectionViewDelegate,
PSUICollectionViewDataSource,
FDAddTweetCellDelegate
>

@property (readwrite) PSUICollectionView *photosCollectionView;
@property (readwrite) NSArray *tweets;

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
		
		//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startCamera)];
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
	[_photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDPhotoCellIdentifier];
	[_photosCollectionView registerClass:[FDAddTweetCell class] forCellWithReuseIdentifier:kFDAddTweetCellIdentifier];
	_photosCollectionView.delegate = self;
	_photosCollectionView.dataSource = self;
	[self.view addSubview:_photosCollectionView];
	
	if ([[FDAFHTTPClient shared] isSessionValid]) {
		[[FDAFHTTPClient shared] tweetsByPublished:nil WithCompletionBlock:^(BOOL success, NSString *message, NSNumber *published, NSArray *tweetsData) {
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
		FDAddTweetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDAddTweetCellIdentifier forIndexPath:indexPath];
		cell.delegate = self;
		return cell;
	} else {
		FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCellIdentifier forIndexPath:indexPath];
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

#pragma mark - FDAddTweetCellDelegate

- (void)willAddTweet
{
	NSLog(@"add tweet");
	if ([[FDAFHTTPClient shared] isSessionValid]) {
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
	[picker dismissViewControllerAnimated:YES completion:^{
	}];
//	[self displayHUD:NSLocalizedString(@"Uploading Avatar", nil)];
//	[picker dismissViewControllerAnimated:YES completion:^{
//		UIImage *avatarImage = info[UIImagePickerControllerEditedImage];
//		NSString *avatarPath = [NSString avatarPathWithUserID:[[FDAFHTTPClient shared] userID]];
//		NSData *imageData = UIImagePNGRepresentation(avatarImage);
//		[[ZBQNAFHTTPClient shared] uploadData:imageData name:avatarPath withCompletionBlock:^(BOOL success) {
//			if (success) {
//				[[FDAFHTTPClient shared] editAvatarPath:avatarPath withCompletionBlock:^(BOOL success, NSString *message) {
//					if (success) {
//						[self displayHUDTitle:nil message:NSLocalizedString(@"Update Succeed!", nil) duration:1];
//						_userProfile.avatarPath = avatarPath;
//						_avatarView.image = avatarImage;
//					} else {
//						[self displayHUDTitle:nil message:message];
//					}
//				}];
//			} else {
//				[self hideHUD:YES];
//			}
//		}];
//	}];
}



@end
