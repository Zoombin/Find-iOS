//
//  FDFirstViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAroundViewController.h"
#import "PSTCollectionView.h"
#import "FDPhotoCell.h"
#import "FDUserProfileViewController.h"
#import "FDUser.h"
#import "FDLikesView.h"
#import "FDPhotoViewController.h"

@interface FDAroundViewController () <PSTCollectionViewDelegate, PSTCollectionViewDataSource, FDPhotoCellDelegate>

@end

@implementation FDAroundViewController
{
	NSArray *users;
	NSArray *photos;
	NSArray *tweets;
	PSTCollectionView *photosCollectionView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"Around", nil);
		self.title = identifier;
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:identifier] selectedImage:[UIImage imageNamed:identifier]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];

	photosCollectionView = [[PSTCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSTCollectionViewFlowLayout squaresLayout]];
	photosCollectionView.backgroundColor = [UIColor clearColor];
	[photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDPhotoCellIdentifier];
	photosCollectionView.delegate = self;
	photosCollectionView.dataSource = self;
	[self.view addSubview:photosCollectionView];
	
	
	users = [FDUser createTest:100];
	
	[[FDAFHTTPClient shared] aroundPhotosAtLocation:[CLLocation fakeLocation] limit:@(9999) distance:nil withCompletionBlock:^(BOOL success, NSArray *ts, NSNumber *distance) {
		if (success) {
			tweets = ts;
			[photosCollectionView reloadData];
		}
	}];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FDPhotoCellDelegate

- (void)photoCell:(FDPhotoCell *)photoCell willLikePhoto:(FDPhoto *)photo
{
	[[FDAFHTTPClient shared] likePhoto:photo.ID withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			photoCell.photo.likes = @(photoCell.photo.likes.integerValue + 1);
			photoCell.likesView.liked = @(YES);
			photoCell.likesView.likes = @(photoCell.likesView.likes.integerValue + 1);
		}
	}];
}

- (void)photoCell:(FDPhotoCell *)photoCell willUnlikePhoto:(FDPhoto *)photo
{
	[[FDAFHTTPClient shared] unlikePhoto:photo.ID withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			photoCell.photo.likes = @(photoCell.photo.likes.integerValue - 1);
			photoCell.likesView.liked = @(NO);
			photoCell.likesView.likes = @(photoCell.likesView.likes.integerValue - 1);
		}
	}];
}

#pragma mark - PSTCollectionViewDelegate

- (CGSize)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return kThumbnailSquareSize;
}

- (NSInteger)collectionView:(PSTCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return tweets.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PSTCollectionViewCell *)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCellIdentifier forIndexPath:indexPath];
	FDTweet *tweet = tweets[indexPath.row];
	cell.tweet = tweet;
	cell.delegate = self;
	return cell;
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDPhotoViewController *photoViewController = [[FDPhotoViewController alloc] init];
	FDTweet *tweet = tweets[indexPath.row];
	if (tweet.photos.count) {
		photoViewController.photo = tweet.photos[0];
	}
	[self.navigationController pushViewController:photoViewController animated:YES];
	
}





@end
