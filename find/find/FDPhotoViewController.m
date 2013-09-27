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
	UITableView *commentsTableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CGSize fullSize = self.view.bounds.size;
	
	commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, fullSize.width, fullSize.height) style:UITableViewStylePlain];
	commentsTableView.delegate = self;
	commentsTableView.dataSource = self;
	[self.view addSubview:commentsTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[FDAFHTTPClient shared] commentsOfPhoto:_photo.ID limit:@(9999) published:nil withCompletionBlock:^(BOOL success, NSArray *comments, NSNumber *lastestPublishedTimestamp) {
		if (success) {
			photoComments = comments;
			[commentsTableView reloadData];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
		cell = [[FDCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFDCommentCellIdentifier];
	}
	cell.comment = photoComments[indexPath.row];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FDComment *comment = photoComments[indexPath.row];
	return [FDCommentCell heightForComment:comment boundingRectWithWidth:tableView.frame.size.width];
}


@end
