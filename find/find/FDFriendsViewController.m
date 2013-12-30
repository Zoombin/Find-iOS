//
//  FDFriendsViewController.m
//  find
//
//  Created by zhangbin on 12/30/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDFriendsViewController.h"
#import "FDUserCell.h"

@interface FDFriendsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *dataSource;
@property (readwrite) NSArray *followers;
@property (readwrite) NSArray *following;

@end

@implementation FDFriendsViewController

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
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_tableView.dataSource = self;
	_tableView.delegate = self;
	[self.view addSubview:_tableView];
	
	NSString *followers = NSLocalizedString(@"粉丝", nil);
	NSString *following = NSLocalizedString(@"关注", nil);
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[followers, following]];
	segmentedControl.tintColor = [UIColor whiteColor];
	segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = segmentedControl;
	
	[self fetchFollowers];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)segmentedControlChanged:(UISegmentedControl *)sender
{
	if (sender.selectedSegmentIndex == 0) {
		[self fetchFollowers];
	} else {
		[self fetchFollowing];
	}
}

- (void)fetchFollowers
{
	if (!_followers) {
		[[FDAFHTTPClient shared] followersOfUser:[[FDAFHTTPClient shared] userID] withCompletionBlock:^(BOOL success, NSString *message, NSArray *usersData) {
			_followers = [FDUser createMutableWithData:usersData];
			_dataSource = _followers;
			[_tableView reloadData];
		}];
	} else {
		_dataSource = _followers;
		[_tableView reloadData];
	}
}


- (void)fetchFollowing
{
	if (!_following) {
		[[FDAFHTTPClient shared] followingOfUser:[[FDAFHTTPClient shared] userID] withCompletionBlock:^(BOOL success, NSString *message, NSArray *usersData) {
			_following = [FDUser createMutableWithData:usersData];
			_dataSource = _following;
			[_tableView reloadData];
		}];
	} else {
		_dataSource = _following;
		[_tableView reloadData];
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FDUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[FDUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
		cell.user = _dataSource[indexPath.row];
	}
	return cell;
}

@end
