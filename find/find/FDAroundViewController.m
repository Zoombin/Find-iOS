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

@interface FDAroundViewController () <PSTCollectionViewDelegate, PSTCollectionViewDataSource>

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
		self.title = @"Around";
//		[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabAccountActive"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabAccount"]];
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
	FDPhoto *photo = tweet.photos.firstObject;
//	FDUser *user = users[indexPath.row];
//	cell.user = user;
//	FDPhoto *photo = [user mainPhoto];
	cell.photo = photo;
	return cell;
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//	FDUserProfileViewController *userProfileViewController = [[FDUserProfileViewController alloc] init];
//	userProfileViewController.user = users[indexPath.row];
//	[self.navigationController pushViewController:userProfileViewController animated:YES];
}





@end
