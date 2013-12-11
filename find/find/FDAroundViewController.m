//
//  FDFirstViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAroundViewController.h"
#import "FDPhotoCell.h"
#import "FDUser.h"
#import "FDLikesView.h"
#import "FDDetailsViewController.h"

@interface FDAroundViewController () <PSUICollectionViewDelegate, PSUICollectionViewDataSource, FDPhotoCellDelegate>

@property (readwrite) NSArray *tweets;
@property (readwrite) PSUICollectionView *photosCollectionView;

@end

@implementation FDAroundViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"Around", nil);
		self.title = identifier;
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
			[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"AroundHighlighted"] withFinishedUnselectedImage:[UIImage imageNamed:@"Around"]];
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:@"Around"] tag:0];
		}
		
		//self.navigationController.hidesBottomBarWhenPushed = YES;
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
	[_photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDPhotoCellIdentifier];
	_photosCollectionView.delegate = self;
	_photosCollectionView.dataSource = self;
	[self.view addSubview:_photosCollectionView];
	
	//TODO: 9999 is a test number
	[[FDAFHTTPClient shared] aroundPhotosAtLocation:[CLLocation fakeLocation] limit:@(9999) distance:nil withCompletionBlock:^(BOOL success, NSString *message, NSArray *tweetsData, NSNumber *distance) {
		if (success) {
			_tweets = [FDTweet createMutableWithData:tweetsData];
			[_photosCollectionView reloadData];
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
	FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCellIdentifier forIndexPath:indexPath];
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

@end
