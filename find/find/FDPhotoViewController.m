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

@interface FDPhotoViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FDPhotoViewController
{
	NSArray *photoComments;
	PSTCollectionView *photosCollectionView;
	UITableView *_tableView;
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
	
	CGSize fullSize = self.view.bounds.size;
	
	photosCollectionView = [[PSTCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSTCollectionViewFlowLayout smallSquaresLayout]];
	photosCollectionView.backgroundColor = [UIColor clearColor];
	[photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDMainPhotoCellIdentifier];
	[photosCollectionView registerClass:[FDCommentCell class] forCellWithReuseIdentifier:kFDCommentCellIdentifier];
//	photosCollectionView.delegate = self;
//	photosCollectionView.dataSource = self;
	[self.view addSubview:photosCollectionView];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + 20, fullSize.width, fullSize.height) style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[FDAFHTTPClient shared] commentsOfPhoto:_photo.ID limit:@(9999) published:nil withCompletionBlock:^(BOOL success, NSArray *comments, NSNumber *lastestPublishedTimestamp) {
		if (success) {
			photoComments = comments;
			[_tableView reloadData];
			//[photosCollectionView reloadData];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PSTCollectionViewDelegate

- (CGSize)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return kBigSquareSize;
	} else {
		FDCommentCell *cell = (FDCommentCell *)[collectionView cellForItemAtIndexPath:indexPath];
		//NSLog(@"cell's comment: %@", cell.comment);
		NSLog(@"cell: %@", NSStringFromCGRect(cell.frame));
		return cell.frame.size;
	}
		
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
//- (PSTCollectionViewCell *)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	if (indexPath.section == 0) {
//		FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDMainPhotoCellIdentifier forIndexPath:indexPath];
//		[cell setPhoto:_photo scaleFitWidth:collectionView.bounds.size.width completionBlock:^(void) {
//			[collectionView reloadData];
//		}];
//		return cell;
//	} else {
//		FDCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDCommentCellIdentifier forIndexPath:indexPath];
//		cell.comment = photoComments[indexPath.row];
//		return cell;
//	}
//}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	if (section == 0) {
//		return 0;
//	} else return 40;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	NSDictionary *attributes = sectionsAttributesMap[@(section)];
//	if (attributes[kThemeCellAttributeKeyHeaderTitle]) {
//		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
//		label.text = attributes[kThemeCellAttributeKeyHeaderTitle];
//		return label;
//	}
//	return nil;
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//	return 1;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	NSDictionary *attributes = sectionsAttributesMap[@(indexPath.section)];
//	return CGRectFromString(attributes[kThemeCellAttributeKeyBounds]).size.height;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return photoComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FDCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kFDCommentCellIdentifier];
	if (!cell) {
		cell = [[FDCommentCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:kFDCommentCellIdentifier];
		cell.comment = photoComments[indexPath.row];
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	return 100;
	FDCommentCell *cell = (FDCommentCell *)[_tableView cellForRowAtIndexPath:indexPath];
	return 100;
}


@end
