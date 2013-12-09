//
//  FDDetailsViewController.h
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDDetailsViewController.h"
#import "FDPhotoCell.h"
#import "FDCommentCell.h"
#import "FDVoteCell.h"
#import "FDVote.h"
#import "FDGiftsCell.h"
#import "FDUserCell.h"
#import "FDMessagesViewController.h"

static NSInteger kSectionOfPhoto = 0;
static NSInteger kIndexOfReportButtonInActionSheet = 0;
static NSInteger kHeightOfSegmentedControl = 30;

static NSString *keyOfClass = @"keyOfClass";
static NSString *keyOfDataSource = @"keyOfDataSource";

@interface FDDetailsViewController () <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, FDCommentCellDelegate, HPGrowingTextViewDelegate, FDVoteCellDelegate, FDGiftsCellDelegate, PSUICollectionViewDelegate, PSUICollectionViewDataSource>

@property (readwrite) UITableView *tableView;
@property (readwrite) CGFloat heightOfPhoto;
@property (readwrite) NSNumber *reportCommentID;
@property (readwrite) UIView *containerView;
@property (readwrite) HPGrowingTextView *growingTextView;
@property (readwrite) UIButton *sendButton;
@property (readwrite) UISegmentedControl *segmentedControl;
@property (readwrite) NSMutableDictionary *segmentedControlAttributes;
@property (readwrite) NSString *titleOfPhotos;
@property (readwrite) NSString *titleOfComments;
@property (readwrite) NSString *titleOfTags;
@property (readwrite) NSString *titleOfRegions;
@property (readwrite) NSString *titleOfGifts;
@property (readwrite) NSString *titleOfFollowers;
@property (readwrite) PSUICollectionView *photosCollectionView;

@end

@implementation FDDetailsViewController

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
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, fullSize.width, fullSize.height - heightOfGrowingTextView) style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
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
	
	_titleOfPhotos = NSLocalizedString(@"Photos", nil);
	_titleOfComments = NSLocalizedString(@"Comments", nil);
	_titleOfTags = NSLocalizedString(@"Tags", nil);
	_titleOfRegions = NSLocalizedString(@"Regions", nil);
	_titleOfGifts = NSLocalizedString(@"Gifts", nil);
	_titleOfFollowers = NSLocalizedString(@"Followers", nil);
	
	_bMemberDetails = NO;//TODO: Test
	
	if (_bMemberDetails) {
		_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[_titleOfPhotos, _titleOfComments, _titleOfTags, _titleOfRegions, _titleOfGifts, _titleOfFollowers]];
	} else {
		_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[_titleOfComments, _titleOfTags, _titleOfRegions, _titleOfGifts, _titleOfFollowers]];
	}
	_segmentedControl.selectedSegmentIndex = 1;
	_segmentedControl.backgroundColor = _tableView.backgroundColor;
	_segmentedControl.tintColor = [UIColor grayColor];
	[_segmentedControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
	
	Class photoCellClass = [UITableViewCell class];
	Class commentCellClass = [FDCommentCell class];
	Class tagCellClass = [FDVoteCell class];
	Class regionCellClass = [FDVoteCell class];
	Class giftsCellClass = [FDGiftsCell class];
	Class followerCellClass = [FDUserCell class];

	_segmentedControlAttributes = [@{_titleOfComments : [@{keyOfClass : commentCellClass} mutableCopy],
									 _titleOfTags : [@{keyOfClass : tagCellClass} mutableCopy],
									 _titleOfRegions : [@{keyOfClass : regionCellClass} mutableCopy],
									 _titleOfGifts : [@{keyOfClass : giftsCellClass, keyOfDataSource : @[@"alwaysHasOne"]} mutableCopy],
									 _titleOfFollowers : [@{keyOfClass : followerCellClass} mutableCopy]
									} mutableCopy];
	
	if (_bMemberDetails) {
		_segmentedControlAttributes[_titleOfPhotos] = [@{keyOfClass : photoCellClass} mutableCopy];
	}
	
	_photosCollectionView = [[PSUICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[PSUICollectionViewFlowLayout aroundPhotoLayout]];
	_photosCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photosCollectionView.backgroundColor = [UIColor clearColor];
	[_photosCollectionView registerClass:[FDPhotoCell class] forCellWithReuseIdentifier:kFDPhotoCellIdentifier];
	_photosCollectionView.delegate = self;
	_photosCollectionView.dataSource = self;
	//[self.view addSubview:_photosCollectionView];
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
	
	if (!_segmentedControlAttributes[_titleOfComments][keyOfDataSource]) {
		[self fetchComments:^{
			[_tableView reloadData];
		}];
	}

	if (!_segmentedControlAttributes[_titleOfTags][keyOfDataSource]) {
		[self fetchTags:^{
			[_tableView reloadData];
		}];
	}
	
	if (!_segmentedControlAttributes[_titleOfRegions][keyOfDataSource]) {
		[self fetchRegions:^{
			[_tableView reloadData];
		}];
	}
	
	if (_bMemberDetails) {
		if (!_segmentedControlAttributes[_titleOfPhotos][keyOfDataSource]) {
			[self fetchPhotos:^{
				[_photosCollectionView reloadData];
				[_tableView reloadData];
			}];
		}
	}
	
	if (!_segmentedControlAttributes[_titleOfFollowers][keyOfDataSource]) {
		[self fetchFollowers:^{
			[_tableView reloadData];
		}];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)fetchPhotos:(dispatch_block_t)block
{
	//TODO: @(1)
	[[FDAFHTTPClient shared] detailsOfUser:@(1) withCompletionBlock:^(BOOL success, NSString *message, NSDictionary *profileAttributes, NSArray *tweetsData) {
		if (success) {
			FDUserProfile *userProfile = [FDUserProfile createWithAttributes:profileAttributes];//TODO
			NSLog(@"userProfile: %@", userProfile);
			
			NSArray *tweets = [FDTweet createMutableWithData:tweetsData];
			NSMutableArray *photos = [NSMutableArray array];
			for (FDTweet *tweet in tweets) {
				[photos addObjectsFromArray:tweet.photos];
			}
			_segmentedControlAttributes[_titleOfPhotos][keyOfDataSource] = photos;
		}
	}];
}

- (void)fetchComments:(dispatch_block_t)block
{
	[[FDAFHTTPClient shared] commentsOfPhoto:_photo.ID limit:@(9999) published:nil withCompletionBlock:^(BOOL success, NSString *message, NSArray *commentsData, NSNumber *total, NSNumber *lastestPublishedTimestamp) {
		if (success) {
			self.navigationItem.title = @"hello";//TODO set username
			
			_segmentedControlAttributes[_titleOfComments][keyOfDataSource] = [FDComment createMutableWithData:commentsData];
			if (block) block ();
		}
	}];
}

- (void)fetchTags:(dispatch_block_t)block
{
	//TODO: test@(1)
	[[FDAFHTTPClient shared] tagsOfPhoto:@(1) withCompletionBlock:^(BOOL success, NSString *message, NSArray *votesData, NSNumber *totalVoted) {
		if (success) {
			_segmentedControlAttributes[_titleOfTags][keyOfDataSource] = [FDVote createMutableWithData:votesData andExtra:totalVoted];
			if (block) block ();
		}
	}];
}

- (void)fetchRegions:(dispatch_block_t)block
{
	//TODO: test@(1)
	[[FDAFHTTPClient shared] regionsOfPhoto:@(1) withCompletionBlock:^(BOOL success, NSString *message, NSArray *votesData, NSNumber *totalVoted) {
		if (success) {
			NSArray *regions = [FDVote createMutableWithData:votesData andExtra:totalVoted];
			for (FDVote *vote in regions) {
				vote.bRegion = @(YES);
			}
			_segmentedControlAttributes[_titleOfRegions][keyOfDataSource] = regions;
			if (block) block ();
		}
	}];
}

- (void)fetchFollowers:(dispatch_block_t)block
{
	//TODO: test@(2)
	[[FDAFHTTPClient shared] followerListOfUser:@(2) withCompletionBlock:^(BOOL success, NSString *message, NSArray *usersData) {
		if (success) {
			NSArray *users = [FDUser createMutableWithData:usersData];
			_segmentedControlAttributes[_titleOfFollowers][keyOfDataSource] = users;
			if (block) block ();
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)titleForSelectedSegment
{
	return [_segmentedControl titleForSegmentAtIndex:_segmentedControl.selectedSegmentIndex];
}

- (void)selectedSegment:(UISegmentedControl *)segmentedControl
{
	CGRect frame = _tableView.frame;
	if ([self titleForSelectedSegment] != _titleOfComments) {
		_containerView.hidden = YES;
		frame.size.height = self.view.bounds.size.height;
	} else {
		frame.size.height = self.view.bounds.size.height - _containerView.bounds.size.height;
	}
	_tableView.frame = frame;
	[_tableView reloadData];
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
	NSString *title = [self titleForSelectedSegment];
	if ([title isEqualToString:_titleOfPhotos]) {
		return 1;
	}
	NSArray *dataSource = _segmentedControlAttributes[title][keyOfDataSource];
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
		NSString *title = [self titleForSelectedSegment];
		Class class = _segmentedControlAttributes[title][keyOfClass];
		NSString *reuseIdentifier = [class identifier];
		id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
		if (!cell) {
			cell = [[class alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
		}
		if ([cell isKindOfClass:[FDCommentCell class]]) {
			FDCommentCell *commentCell = (FDCommentCell *)cell;
			commentCell.delegate = self;
			FDComment *comment = _segmentedControlAttributes[title][keyOfDataSource][indexPath.row];
			commentCell.comment = comment;
			commentCell.bMine = [[FDAFHTTPClient shared] userID] == comment.userID;
		} else if ([cell isKindOfClass:[FDVoteCell class]]) {
			FDVoteCell *voteCell = (FDVoteCell *)cell;
			voteCell.delegate = self;
			FDVote *vote = _segmentedControlAttributes[title][keyOfDataSource][indexPath.row];
			voteCell.vote = vote;
		} else if ([cell isKindOfClass:[FDGiftsCell class]]) {
			FDGiftsCell *giftsCell = (FDGiftsCell *)cell;
			giftsCell.delegate = self;
		} else if ([cell isKindOfClass:[FDUserCell class]]) {
			FDUserCell *userCell = (FDUserCell *)cell;
			userCell.user = _segmentedControlAttributes[title][keyOfDataSource][indexPath.row];
		} else if ([cell isKindOfClass:[UITableViewCell class]]) {//photos
			UITableViewCell *tableViewCell = (UITableViewCell *)cell;
			[tableViewCell.contentView addSubview:_photosCollectionView];
		} 		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == kSectionOfPhoto) {
		return _heightOfPhoto;
	} else {
		NSString *title = [self titleForSelectedSegment];
		if ([title isEqualToString:_titleOfComments]) {
			NSArray *dataSource = _segmentedControlAttributes[_titleOfComments][keyOfDataSource];
			FDComment *comment = dataSource[indexPath.row];
			return [FDCommentCell heightForComment:comment];
		} else if ([title isEqualToString:_titleOfTags] || [title isEqualToString:_titleOfRegions]) {
			return [FDVoteCell height];
		} else if ([title isEqualToString:_titleOfGifts]){
			return [FDGiftsCell height];
		} else if ([title isEqualToString:_titleOfPhotos]){
			//CGFloat height = MAX(_photosCollectionView.contentSize.height, _photosCollectionView.frame.size.height);
			NSLog(@"contentSizeHeight: %f", _photosCollectionView.contentSize.height);
			NSLog(@"frameSizeHeight: %f", _photosCollectionView.frame.size.height);
			return MAX(_photosCollectionView.contentSize.height, _photosCollectionView.frame.size.height);
		} else if ([title isEqualToString:_titleOfFollowers]) {
			return _tableView.rowHeight;
		}
	}
	return _tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([_growingTextView resignFirstResponder]) {
		NSLog(@"resign");
		return;
	}
	if (indexPath.section != kSectionOfPhoto) {
		NSString *title = [self titleForSelectedSegment];
		if ([title isEqualToString:_titleOfComments]) {
			FDCommentCell *cell = (FDCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
			[cell showOrHideMoreActions];
		}
	}
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section != kSectionOfPhoto) {
		NSString *title = [self titleForSelectedSegment];
		if ([title isEqualToString:_titleOfComments]) {
			FDCommentCell *cell = (FDCommentCell *)[tableView cellForRowAtIndexPath:indexPath];
			[cell hideMoreActions];
		}
	}
}

#pragma mark - PSUICollectionViewDelegate

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [FDSize aroundPhotoSize];
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSLog(@"return count of data source");
	NSArray *dataSource = _segmentedControlAttributes[_titleOfPhotos][keyOfDataSource];
	return dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *dataSource = _segmentedControlAttributes[_titleOfPhotos][keyOfDataSource];
	FDPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFDPhotoCellIdentifier forIndexPath:indexPath];
	FDPhoto *photo = dataSource[indexPath.row];
	cell.photo = photo;
	//FDTweet *tweet = tweets[indexPath.row];
	//cell.tweet = tweet;
	//cell.delegate = self;
	NSLog(@"return cell");
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

#pragma mark - KeyboardNotifications

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

- (void)willReport:(FDComment *)comment
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Report Bad Comment", nil), nil];
	[actionSheet showInView:self.view];
	_reportCommentID = comment.ID;
}

#pragma mark - FDVoteCellDelegate

- (void)willVote:(FDVote *)vote
{
	NSString *title = [self titleForSelectedSegment];
	if (vote.bRegion.boolValue) {//TODO: photoID
		[[FDAFHTTPClient shared] voteRegion:vote.ID toPhoto:@(1) withCompletionBlock:^(BOOL success, NSString *message, NSArray *votesData, NSNumber *totalVoted) {
			if (success) {
				NSArray *votes = [FDVote createMutableWithData:votesData andExtra:totalVoted];
				for (FDVote *vote in votes) {
					vote.bRegion = @(YES);
				}
				_segmentedControlAttributes[title][keyOfDataSource] = votes;
				[_tableView reloadData];
			}
		}];
	} else {//TODO: photoID
		[[FDAFHTTPClient shared] voteTag:vote.ID toPhoto:@(1) withCompletionBlock:^(BOOL success, NSString *message, NSArray *votesData, NSNumber *totalVoted) {
			if (success) {
				NSArray *votes = [FDVote createMutableWithData:votesData andExtra:totalVoted];
				_segmentedControlAttributes[title][keyOfDataSource] = votes;
				[_tableView reloadData];
			}
		}];
	}
}

#pragma mark - FDGiftsCellDelegate

- (void)willGifts
{
	NSLog(@"will gifts");
}

- (void)willSendPrivateMessage
{
	FDMessagesViewController *messagesViewController = [[FDMessagesViewController alloc] init];
	[self.navigationController pushViewController:messagesViewController animated:YES];
}



@end
