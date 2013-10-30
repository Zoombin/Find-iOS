//
//  FDPhotoDetailsViewController.h
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhotoDetailsViewController.h"
#import "FDPhotoCell.h"
#import "FDCommentCell.h"

@interface FDPhotoDetailsViewController () <UITableViewDelegate, UITableViewDataSource, FDCommentCellDelegate>

@property (readwrite) NSArray *comments;
@property (readwrite) UITableView *kTableView;
@property (readwrite) CGFloat heightOfPhoto;

@end

@implementation FDPhotoDetailsViewController

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
	
	CGSize fullSize = self.view.bounds.size;
	
	_kTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, fullSize.width, fullSize.height) style:UITableViewStylePlain];
	_kTableView.delegate = self;
	_kTableView.dataSource = self;
	[self.view addSubview:_kTableView];
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
			self.navigationItem.title = @"hello";//TODO set username
			_comments = [FDComment createMutableWithData:commentsData];
			[_kTableView reloadData];
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
	return _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
		if (!cell) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PhotoCell"];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			NSURLRequest *request = [NSURLRequest requestWithURL:[_photo urlScaleFitWidth:self.view.bounds.size.width * 2]];
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
			imageView.contentMode = UIViewContentModeTop | UIViewContentModeCenter | UIViewContentModeScaleAspectFit;
			[imageView setImageWithURLRequest:request placeholderImage:nil success:nil failure:nil];
			[[[UIImageView alloc] init] setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
				imageView.image = image;
				CGRect newFrame = imageView.frame;
				if (image.size.width < imageView.bounds.size.width) {
					CGFloat ratio = imageView.bounds.size.width / image.size.width;
					newFrame.size.height = image.size.height * ratio;
				} else {
					newFrame.size.height = image.size.height;
				}
				imageView.frame = newFrame;
				_heightOfPhoto = newFrame.size.height;
				[tableView reloadData];
			} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
				
			}];
			[cell.contentView addSubview:imageView];
		}
		return cell;
	} else {
		FDCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kFDCommentCellIdentifier];
		if (!cell) {
			cell = [[FDCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFDCommentCellIdentifier];
			cell.delegate = self;
		}
		cell.comment = _comments[indexPath.row];
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		return _heightOfPhoto;
	} else {
		FDComment *comment = _comments[indexPath.row];
		return [FDCommentCell heightForComment:comment];
	}
}


@end
