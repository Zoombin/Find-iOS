//
//  FDStoreViewController.m
//  find
//
//  Created by zhangbin on 11/30/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDStoreViewController.h"

@interface FDStoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (readwrite) UITableView *tableView;

@end

@implementation FDStoreViewController

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
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
#ifdef IGNORE_RULES_OF_APP_STORE
	NSString *virtual = NSLocalizedString(@"Virtual", nil);
	NSString *stuff = NSLocalizedString(@"Stuff", nil);
	NSString *records = NSLocalizedString(@"Records", nil);
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[virtual, stuff, records]];
	segmentedControl.tintColor = [UIColor whiteColor];
	segmentedControl.selectedSegmentIndex = 0;
	self.navigationItem.titleView = segmentedControl;
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"StoreCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//	NSNumber *height = _dataSourceDictionary[@(indexPath.section)][indexPath.row][kHeightOfCell];
//	if (height) {
//		return height.floatValue;
//	}
	return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	Class class = NSClassFromString(_dataSourceDictionary[@(indexPath.section)][indexPath.row][kPushTargetClass]);
//	if (class) {
//		UIViewController *viewController = [[class alloc] init];
//		viewController.hidesBottomBarWhenPushed = YES;
//		[self.navigationController pushViewController:viewController animated:YES];
//	}
}


@end
