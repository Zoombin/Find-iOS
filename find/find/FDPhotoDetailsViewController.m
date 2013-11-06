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
#import "FDVoteCell.h"
#import "FDVote.h"

static NSInteger kSectionOfPhoto = 0;
static NSInteger kSectionOfComments = 1;
static NSInteger kIndexOfReportButtonInActionSheet = 0;
static NSInteger kHeightOfSegmentedControl = 30;

static NSInteger kSegmentedControlIndexComments = 0;
static NSInteger kSegmentedControlIndexTags = 1;
static NSInteger kSegmentedControlIndexRegions = 2;
static NSInteger kSegmentedControlIndexShareAndGifts = 3;

@interface FDPhotoDetailsViewController () <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, FDCommentCellDelegate, HPGrowingTextViewDelegate>

@property (readwrite) NSArray *comments;
@property (readwrite) UITableView *kTableView;
@property (readwrite) CGFloat heightOfPhoto;
@property (readwrite) NSNumber *reportCommentID;
@property (readwrite) UIView *containerView;
@property (readwrite) HPGrowingTextView *growingTextView;
@property (readwrite) UIButton *sendButton;
@property (readwrite) UISegmentedControl *segmentedControl;
@property (readwrite) NSArray *tags;
@property (readwrite) NSMutableDictionary *dataSourceMap;

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
	_heightOfPhoto = fullSize.height;
	CGFloat heightOfGrowingTextView = 40;
	
	_kTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, fullSize.width, fullSize.height - heightOfGrowingTextView) style:UITableViewStylePlain];
	_kTableView.delegate = self;
	_kTableView.dataSource = self;
	[self.view addSubview:_kTableView];
	
	_containerView = [[UIView alloc] initWithFrame:CGRectMake(0, fullSize.height - heightOfGrowingTextView, fullSize.width, heightOfGrowingTextView)];
	_containerView.layer.borderWidth = 1;
	_containerView.layer.borderColor = [[UIColor grayColor] CGColor];
	_containerView.backgroundColor = [UIColor randomColor];
	_containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	[self.view addSubview:_containerView];
	
	_sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
	_sendButton.backgroundColor = [UIColor randomColor];
	_sendButton.frame = CGRectMake(fullSize.width - 50, 0, 50, _containerView.frame.size.height);
	_sendButton.titleLabel.font = [UIFont fdThemeFontOfSize:13];
	_sendButton.titleLabel.adjustsFontSizeToFitWidth = YES;
	[_containerView addSubview:_sendButton];
	
	_growingTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 2, 230, heightOfGrowingTextView - 4)];
	_growingTextView.layer.cornerRadius = 5;
	_growingTextView.layer.borderWidth = 0.5;
	_growingTextView.layer.borderColor = [[UIColor grayColor] CGColor];
	_growingTextView.isScrollable = NO;
    _growingTextView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	_growingTextView.minNumberOfLines = 1;
    _growingTextView.maxHeight = 150.0f;//if large than 150 growingTextView will cover navigation
	_growingTextView.returnKeyType = UIReturnKeyDefault;
	_growingTextView.font = [UIFont fdThemeFontOfSize:17.0f];
	_growingTextView.delegate = self;
    _growingTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _growingTextView.backgroundColor = [UIColor randomColor];
    _growingTextView.placeholder = NSLocalizedString(@"Comment This Photo", nil);
	[_containerView addSubview:_growingTextView];
	
	_dataSourceMap = [NSMutableDictionary dictionary];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (!_comments) {
		[self fetchComments:^{
			[_kTableView reloadData];
		}];
	}
	
	if (!_tags) {
		[self fetchTags:nil];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)fetchComments:(dispatch_block_t)block
{
	[[FDAFHTTPClient shared] commentsOfPhoto:_photo.ID limit:@(9999) published:nil withCompletionBlock:^(BOOL success, NSString *message, NSArray *commentsData, NSNumber *total, NSNumber *lastestPublishedTimestamp) {
		if (success) {
			self.navigationItem.title = @"hello";//TODO set username
			_comments = [FDComment createMutableWithData:commentsData];
			_dataSourceMap[@(kSegmentedControlIndexComments)] = _comments;
			NSString *title = [NSString stringWithFormat:@"%@(%@)", NSLocalizedString(@"Comments", nil), total];
			[_segmentedControl setTitle:title forSegmentAtIndex:0];
			if (block) block ();
		}
	}];
}

- (void)fetchTags:(dispatch_block_t)block
{
	[[FDAFHTTPClient shared] tagsOfPhoto:_photo.ID withCompletionBlock:^(BOOL success, NSString *message, NSArray *votesData) {
		if (success) {
			_tags = [FDVote createTest:10];
			_dataSourceMap[@(kSegmentedControlIndexTags)] = _tags;
			if (block) block ();
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
	
//	[[FDAFHTTPClient shared] commentPhoto:_photo.ID content:tweetString withCompletionBlock:^(BOOL success, NSString *message) {
//		if (success) {
//			[self fetchComments];
//		}
//	}];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
	
	// get a rect for the textView frame
	CGRect containerFrame = _containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	_containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = _containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	_containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}


- (void)willReport:(FDComment *)comment
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Report Bad Comment", nil), nil];
	[actionSheet showInView:self.view];
	_reportCommentID = comment.ID;
}

- (void)selectedSegment:(UISegmentedControl *)segmentedControl
{
	NSLog(@"selectedSegment: %@", [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]);
	[_kTableView reloadData];
//	if (segmentedControl.selectedSegmentIndex == kSegmentedControlIndexComments) {
//		
//	} else if (segmentedControl.selectedSegmentIndex == kSegmentedControlIndexRegions) {
//
//	} else if (segmentedControl.selectedSegmentIndex == kSegmentedControlIndexTags) {
//
//	} else if (segmentedControl.selectedSegmentIndex == kSegmentedControlIndexShareAndGifts) {
//		
//	}
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == kSectionOfPhoto) {
		return 0;
	}
	return kHeightOfSegmentedControl;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == kSectionOfPhoto) {
		return nil;
	}
	NSString *comments = NSLocalizedString(@"Comments", nil);
	NSString *tags = NSLocalizedString(@"Tags", nil);
	NSString *regions = NSLocalizedString(@"Regions", nil);
	NSString *sharAndGifts = NSLocalizedString(@"Share&Gifts", nil);
	if (!_segmentedControl) {
		_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[comments, tags, regions, sharAndGifts]];
		_segmentedControl.selectedSegmentIndex = 0;
		_segmentedControl.backgroundColor = _kTableView.backgroundColor;
		_segmentedControl.tintColor = [UIColor fdThemeRed];
		[_segmentedControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
	}
	return _segmentedControl;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == kSectionOfPhoto) {
		return 1;
	}
	NSArray *dataSource = _dataSourceMap[@(_segmentedControl.selectedSegmentIndex)];
	return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == kSectionOfPhoto) {
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
		if (_segmentedControl.selectedSegmentIndex == kSegmentedControlIndexComments) {
			FDCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kFDCommentCellIdentifier];
			if (!cell) {
				cell = [[FDCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFDCommentCellIdentifier];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.delegate = self;
			}
			cell.comment = _comments[indexPath.row];
			cell.bMine = [[FDAFHTTPClient shared] userID] == cell.comment.userID;
			return cell;
		} else {
			FDVoteCell *cell = [tableView dequeueReusableCellWithIdentifier:kFDVoteCellIdentifier];
			if (!cell) {
				cell = [[FDVoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFDVoteCellIdentifier];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				//cell.delegate = self;
			}
			cell.vote = _tags[indexPath.row];
			return cell;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == kSectionOfPhoto) {
		return _heightOfPhoto + 10;
	} else {
		if (_segmentedControl.selectedSegmentIndex == kSegmentedControlIndexComments) {
			FDComment *comment = _comments[indexPath.row];
			return [FDCommentCell heightForComment:comment];
		} else
		{
			return [FDVoteCell height];
		}
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([_growingTextView resignFirstResponder]) {
		NSLog(@"resign");
		return;
	}
	if (indexPath.section == kSectionOfComments) {
		FDCommentCell *cell = (FDCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
		[cell showOrHideMoreActions];
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == kSectionOfComments) {
		FDCommentCell *cell = (FDCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
		[cell hideMoreActions];
	}
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == kIndexOfReportButtonInActionSheet) {
		if (_reportCommentID) {
			[[FDAFHTTPClient shared] reportComment:_reportCommentID withCompletionBlock:^(BOOL success, NSString *message) {
				if (success) {
					[self displayHUDTitle:nil message:NSLocalizedString(@"Report successfully, we will handle it ASAP!", nil)];
				} else {
					[self displayHUDTitle:nil message:message];
				}
			}];
		}
	}
}

#pragma mark - HPGrowingTextViewDelegate

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect frame = _containerView.frame;
    frame.size.height -= diff;
    frame.origin.y += diff;
	_containerView.frame = frame;
	
	frame = _sendButton.frame;
	frame.origin.y = _containerView.frame.size.height - frame.size.height;
	_sendButton.frame = frame;
}


@end
