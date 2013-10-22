//
//  FDUserProfileViewController.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDUserProfileViewController.h"
#import "PSTCollectionView.h"
#import "FDPhotoCell.h"
#import "FDPhotoViewController.h"

@interface FDUserProfileViewController () <PSUICollectionViewDelegate, PSUICollectionViewDataSource>

@end

@implementation FDUserProfileViewController

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
	
	PSUICollectionView *photosCollectionView = [[PSUICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSUICollectionViewFlowLayout smallSquaresLayout]];
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

#pragma mark - PSUICollectionViewDelegate

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return [FDSize profilePhotoSize];
	} else {
		return [FDSize profileOtherPhotoSize];
	}
}

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView
{
	return 2;
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	if (section == 0) {
		return 1;
	} else {
		return _user.photos.count;
	}
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDMainPhotoCellIdentifier forIndexPath:indexPath];
		cell.user = _user;
		FDPhoto *photo = [_user mainPhoto];
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

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 1) {
		FDPhotoViewController *photoViewController = [[FDPhotoViewController alloc] init];
		photoViewController.user = _user;
		photoViewController.photo = _user.photos[indexPath.row];
		[self.navigationController pushViewController:photoViewController animated:YES];
	}
}

@end
