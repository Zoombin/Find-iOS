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

@interface FDPhotoViewController () <UITableViewDelegate, UITableViewDataSource, FDCommentCellDelegate>

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
	[self fetchComments];
}

- (void)fetchComments
{
	[[FDAFHTTPClient shared] commentsOfPhoto:_photo.ID limit:@(9999) published:nil withCompletionBlock:^(BOOL success, NSString *message, NSArray *commentsData, NSNumber *lastestPublishedTimestamp) {
		if (success) {
			photoComments = [FDComment createMutableWithData:commentsData];
			[commentsTableView reloadData];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FDCommentCellDelegate

- (void)willCommentOrReply:(FDComment *)comment
{
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"YYYY-mm-dd HH:MM:SS";
	NSString *tweetString = [NSString stringWithFormat:@"comment at:%@", [dateFormatter stringFromDate:now]];

	[[FDAFHTTPClient shared] commentPhoto:_photo.ID content:tweetString withCompletionBlock:^(BOOL success, NSString *message) {
		if (success) {
			[self fetchComments];
		}
	}];
}

- (void)willReport:(FDComment *)comment
{
	NSLog(@"will report comment: %@", comment);
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		return 1;
	}
	return photoComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		FDCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kFDCommentCellIdentifier];
		if (!cell) {
			cell = [[FDCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFDCommentCellIdentifier];
			cell.delegate = self;
		}
		return cell;
	} else {
		FDCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kFDCommentCellIdentifier];
		if (!cell) {
			cell = [[FDCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFDCommentCellIdentifier];
			cell.delegate = self;
		}
		cell.comment = photoComments[indexPath.row];
		//[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return 100;
	} else {
		FDComment *comment = photoComments[indexPath.row];
		return [FDCommentCell heightForComment:comment];
	}
}


@end
