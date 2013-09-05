//
//  FDPhotoViewController.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhotoViewController.h"
#import "PSTCollectionView.h"
#import "FDPhotoCell.h"

@interface FDPhotoViewController () <PSTCollectionViewDelegate, PSTCollectionViewDataSource>

@end

@implementation FDPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	PSTCollectionView *photosCollectionView = [[PSTCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSTCollectionViewFlowLayout smallSquaresLayout]];
	photosCollectionView.backgroundColor = [UIColor clearColor];
	[photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDPhotoCellIdentifier];
	[photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDMainPhotoCellIdentifier];
	photosCollectionView.delegate = self;
	photosCollectionView.dataSource = self;
	[self.view addSubview:photosCollectionView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PSTCollectionViewDelegate

- (CGSize)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return kBigSquareSize;
	} else {
		return kThumbnailSmallSquareSize;
	}
}

- (NSInteger)numberOfSectionsInCollectionView:(PSTCollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(PSTCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PSTCollectionViewCell *)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDMainPhotoCellIdentifier forIndexPath:indexPath];
		cell.user = _user;
		FDPhoto *photo = [_user mainPhoto];
//		cell.size = //CGSizeMake(self.view.bounds.size.width, )
		cell.photo = photo;
		return cell;
	}
	else {
		FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCellIdentifier forIndexPath:indexPath];
		cell.user = _user;
		FDPhoto *photo = _user.photos[indexPath.row];
		cell.photo = photo;
		return cell;
	}
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//	if (indexPath.section == 1) {
//		FDPhotoViewController *photoViewController = [[FDPhotoViewController alloc] init];
//		photoViewController.user = _user;
//		photoViewController.photo = _user.photos[indexPath.row];
//		[self.navigationController pushViewController:photoViewController animated:YES];
//	}
}

@end
