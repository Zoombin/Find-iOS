//
//  FDFirstViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDNearbyViewController.h"
#import "PSTCollectionView.h"
#import "FDPhotoCell.h"
#import "FDUserProfileViewController.h"
#import "FDUser.h"

@interface FDNearbyViewController () <PSTCollectionViewDelegate, PSTCollectionViewDataSource>

@end

@implementation FDNearbyViewController
{
	NSArray *users;
	NSArray *photos;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"Nearby";
//		[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabAccountActive"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabAccount"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	PSTCollectionView *photosCollectionView = [[PSTCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSTCollectionViewFlowLayout squaresLayout]];
	
	photosCollectionView.showsVerticalScrollIndicator = NO;
	photosCollectionView.backgroundColor = [UIColor clearColor];
	[photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDPhotoCellIdentifier];
	photosCollectionView.delegate = self;
	photosCollectionView.dataSource = self;
	[self.view addSubview:photosCollectionView];
	
	
	users = [FDUser createTest:1000];
//	photos = [FDPhoto createTest:1000];
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
	return users.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PSTCollectionViewCell *)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCellIdentifier forIndexPath:indexPath];
	FDUser *user = users[indexPath.row];
	cell.user = user;
	FDPhoto *photo = [user mainPhoto];
	cell.photo = photo;
	return cell;
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDUserProfileViewController *userProfileViewController = [[FDUserProfileViewController alloc] init];
	userProfileViewController.user = users[indexPath.row];
	[self.navigationController pushViewController:userProfileViewController animated:YES];
}





@end
