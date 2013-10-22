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

@interface FDAroundViewController () <PSUICollectionViewDelegate, PSUICollectionViewDataSource, FDPhotoCellDelegate>

@end

@implementation FDAroundViewController
{
	NSArray *tweets;
	PSUICollectionView *photosCollectionView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"Around", nil);
		self.title = identifier;
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:identifier] tag:0];
		//self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:identifier] selectedImage:[UIImage imageNamed:identifier]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];

	photosCollectionView = [[PSUICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSUICollectionViewFlowLayout aroundPhotoLayout]];
	photosCollectionView.backgroundColor = [UIColor clearColor];
	[photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDPhotoCellIdentifier];
	photosCollectionView.delegate = self;
	photosCollectionView.dataSource = self;
	[self.view addSubview:photosCollectionView];
	
	//TODO: 9999 is a test number
	[[FDAFHTTPClient shared] aroundPhotosAtLocation:[CLLocation fakeLocation] limit:@(9999) distance:nil withCompletionBlock:^(BOOL success, NSString *message, NSArray *tweetsData, NSNumber *distance) {
		if (success) {
			tweets = [FDTweet createMutableWithData:tweetsData];
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

- (void)photoCell:(FDPhotoCell *)photoCell willLikeOrUnlikePhoto:(FDPhoto *)photo
{
	[[FDAFHTTPClient shared] likeOrUnlikePhoto:photo.ID withCompletionBlock:^(BOOL success, NSString *message, NSNumber *liked, NSNumber *likes) {
		if (success) {
			photoCell.photo.likes = likes;
			photoCell.likesView.likes = likes;
			photoCell.likesView.liked = liked;
		}
	}];
}

#pragma mark - PSTCollectionViewDelegate

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [FDSize aroundPhotoSize];
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return tweets.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCellIdentifier forIndexPath:indexPath];
	//FDTweet *tweet = tweets[indexPath.row];
	//cell.tweet = tweet;
	//cell.delegate = self;
	return cell;
}

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDPhotoViewController *photoViewController = [[FDPhotoViewController alloc] init];
	FDTweet *tweet = tweets[indexPath.row];
	if (tweet.photos.count) {
		photoViewController.photo = tweet.photos[0];
	}
	[self.navigationController pushViewController:photoViewController animated:YES];
}

@end
