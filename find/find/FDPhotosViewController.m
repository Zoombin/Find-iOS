//
//  FDPhotosViewController.m
//  find
//
//  Created by zhangbin on 10/28/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhotosViewController.h"
#import "FDPhotoCell.h"

@interface FDPhotosViewController () <PSUICollectionViewDelegate, PSUICollectionViewDataSource>

@property (readwrite) PSUICollectionView *photosCollectionView;

@property (readwrite) NSArray *photos;

@end

@implementation FDPhotosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self setLeftBarButtonItemAsBackButton];
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
	
	
	[[FDAFHTTPClient shared] themeContent:_themeID withCompletionBlock:^(BOOL success, NSString *message, NSArray *themeContentData, NSDictionary *themeAttributes) {
		if (success) {
			if (themeContentData.count) {
				_photos = [FDPhoto createMutableWithData:themeContentData];
				[_photosCollectionView reloadData];
			}
			
			if (themeAttributes) {
				FDTheme *theme = [FDTheme createWithAttributes:themeAttributes];
				self.title = theme.title;
			}
		};
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PSUICollectionViewDelegate

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [FDSize aroundPhotoSize];
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return _photos.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCellIdentifier forIndexPath:indexPath];
	FDPhoto *photo = _photos[indexPath.row];
	cell.photo = photo;
	//FDTweet *tweet = tweets[indexPath.row];
	//cell.tweet = tweet;
	//cell.delegate = self;
	return cell;
}

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//	FDPhotoDetailsViewController *photoDetailsViewController = [[FDPhotoDetailsViewController alloc] init];
//	FDTweet *tweet = tweets[indexPath.row];
//	if (tweet.photos.count) {
//		photoDetailsViewController.photo = tweet.photos[0];
//	}
//	[self.navigationController pushViewController:photoDetailsViewController animated:YES];
}


@end
