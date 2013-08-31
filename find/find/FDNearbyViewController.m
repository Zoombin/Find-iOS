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

@interface FDNearbyViewController () <PSTCollectionViewDelegate, PSTCollectionViewDataSource>

@end

@implementation FDNearbyViewController
{
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
	
	PSTCollectionViewFlowLayout *layout = [[PSTCollectionViewFlowLayout alloc] init];
	layout.itemSize = CGSizeMake(144, 175);
	layout.minimumInteritemSpacing = 12;
	layout.minimumLineSpacing = 10;
	layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
	
	PSTCollectionView *photosCollectionView = [[PSTCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
	
	photosCollectionView.showsVerticalScrollIndicator = NO;
	photosCollectionView.backgroundColor = [UIColor clearColor];
	[photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDPhotoCellIdentifier];
	photosCollectionView.delegate = self;
	photosCollectionView.dataSource = self;
	[self.view addSubview:photosCollectionView];
	
	photos = [FDPhoto creatTest:1000];
}

- (NSInteger)collectionView:(PSTCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return photos.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PSTCollectionViewCell *)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCellIdentifier forIndexPath:indexPath];
	[cell setPhoto:photos[indexPath.row]];
	return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
