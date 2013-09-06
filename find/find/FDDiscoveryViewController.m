//
//  FDSecondViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDDiscoveryViewController.h"
#import "PSTCollectionView.h"
#import "FDThemeCell.h"

@interface FDDiscoveryViewController () <PSTCollectionViewDelegate, PSTCollectionViewDataSource, PSTCollectionViewDelegateFlowLayout>

@end

@implementation FDDiscoveryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"Discovery";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	PSTCollectionViewFlowLayout *layout = [[PSTCollectionViewFlowLayout alloc] init];
	layout.scrollDirection = PSTCollectionViewScrollDirectionHorizontal;
	layout.itemSize = kThemeSize;
	layout.minimumInteritemSpacing = 0;
	layout.minimumLineSpacing = 0;
	layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
	
	PSTCollectionView *themeCollectionView = [[PSTCollectionView alloc] initWithFrame:CGRectMake(0, 100, kThemeSize.width, kThemeSize.height) collectionViewLayout:layout];
	themeCollectionView.backgroundColor = [UIColor grayColor];
	[themeCollectionView registerClass:[FDThemeCell class] forCellWithReuseIdentifier:kFDThemeCellIdentifier];
	themeCollectionView.delegate = self;
	themeCollectionView.dataSource = self;
	themeCollectionView.pagingEnabled = YES;
	[themeCollectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
	[self.view addSubview:themeCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PSTCollectionViewDelegate

//- (CGSize)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	return kThemeSize;
//}

- (NSInteger)collectionView:(PSTCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSLog(@"collectionView's frame: %@", NSStringFromCGRect(collectionView.frame));
	NSLog(@"collectionView's content size: %@", NSStringFromCGSize(collectionView.contentSize));
	return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PSTCollectionViewCell *)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FDThemeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDThemeCellIdentifier forIndexPath:indexPath];
//	FDUser *user = users[indexPath.row];
//	cell.user = user;
//	FDPhoto *photo = [user mainPhoto];
//	cell.photo = photo;
	NSLog(@"collectionView's content size: %@", NSStringFromCGSize(collectionView.contentSize));
	NSLog(@"cell's frame: %@", NSStringFromCGRect(cell.frame));
	return cell;
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//	FDUserProfileViewController *userProfileViewController = [[FDUserProfileViewController alloc] init];
//	userProfileViewController.user = users[indexPath.row];
//	[self.navigationController pushViewController:userProfileViewController animated:YES];
}

@end
