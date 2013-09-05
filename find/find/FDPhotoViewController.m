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
	[photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDMainPhotoCellIdentifier];
	photosCollectionView.delegate = self;
	photosCollectionView.dataSource = self;
	[self.view addSubview:photosCollectionView];
	
//	[_photo fetchInfoWithCompletionBlock:^(void) {
//		[photosCollectionView reloadData];
//	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PSTCollectionViewDelegate

- (CGSize)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//	FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDMainPhotoCellIdentifier forIndexPath:indexPath];
//	if (CGSizeEqualToSize(cell.displaySize, CGSizeZero))
//		return kBigSquareSize;
//	else
//		return cell.displaySize;
	return kBigSquareSize;
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
	FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDMainPhotoCellIdentifier forIndexPath:indexPath];
	[cell setPhoto:_photo scaleFitWidth:collectionView.bounds.size.width completionBlock:^(void) {
		[collectionView reloadData];
	}];
	return cell;
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
