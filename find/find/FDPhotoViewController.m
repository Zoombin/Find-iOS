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
#import "FDCommentCell.h"

@interface FDPhotoViewController () <PSTCollectionViewDelegate, PSTCollectionViewDataSource>

@end

@implementation FDPhotoViewController
{
	NSArray *photoComments;
	PSTCollectionView *photosCollectionView;
}

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
	
	photosCollectionView = [[PSTCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSTCollectionViewFlowLayout smallSquaresLayout]];
	photosCollectionView.backgroundColor = [UIColor clearColor];
	[photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDMainPhotoCellIdentifier];
	[photosCollectionView registerClass:[FDCommentCell class] forCellWithReuseIdentifier:kFDCommentCellIdentifier];
	photosCollectionView.delegate = self;
	photosCollectionView.dataSource = self;
	[self.view addSubview:photosCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[FDAFHTTPClient shared] commentsOfPhoto:_photo.ID limit:@(9999) published:nil withCompletionBlock:^(BOOL success, NSArray *comments, NSNumber *lastestPublishedTimestamp) {
		if (success) {
			photoComments = comments;
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
//	FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDMainPhotoCellIdentifier forIndexPath:indexPath];
//	if (CGSizeEqualToSize(cell.displaySize, CGSizeZero))
//		return kBigSquareSize;
//	else
//		return cell.displaySize;
	if (indexPath.section == 0) {
		return kBigSquareSize;
	} else
		return CGSizeMake(CGRectGetWidth(self.view.frame), 40);
}

- (NSInteger)numberOfSectionsInCollectionView:(PSTCollectionView *)collectionView
{
	return 2;
}

- (NSInteger)collectionView:(PSTCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	if (section == 0) {
		return 1;
	} else {
		return photoComments.count;
	}
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PSTCollectionViewCell *)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDMainPhotoCellIdentifier forIndexPath:indexPath];
		[cell setPhoto:_photo scaleFitWidth:collectionView.bounds.size.width completionBlock:^(void) {
			[collectionView reloadData];
		}];
		return cell;
	} else {
		FDCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDCommentCellIdentifier forIndexPath:indexPath];
		cell.comment = photoComments[indexPath.row];
		return cell;
	}
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
