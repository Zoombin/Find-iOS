//
//  FDSecondViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDDiscoveryViewController.h"
#import "FDThemeCell.h"
#import "FDThemeSectionHeaderView.h"
#import "FDThemeItemView.h"
#import "FDThemeSection.h"
#import "FDUserProfileViewController.h"
#import "FDPhotosViewController.h"

@interface FDDiscoveryViewController () <UITableViewDataSource, UITableViewDelegate, FDThemeCellDelegate>

@end

@implementation FDDiscoveryViewController
{
	UITableView *discoveryTableView;
	NSArray *themeSections;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"Discovery", nil);
		self.title = identifier;
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
			[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"DiscoveryHighlighted"] withFinishedUnselectedImage:[UIImage imageNamed:@"Discovery"]];
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:@"Discovery"] tag:0];
		}
		
		//self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	discoveryTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	discoveryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	discoveryTableView.delegate = self;
	discoveryTableView.dataSource = self;
	[self.view addSubview:discoveryTableView];
	
	[[FDAFHTTPClient shared] themeListWithCompletionBlock:^(BOOL success, NSString *message, NSArray *themesData) {
		if (success) {
			themeSections = [FDThemeSection createMutableWithData:themesData];
			[discoveryTableView reloadData];
		} else {
			[self displayHUDTitle:nil message:message];
		}
	}];
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

- (FDThemeSection *)themeSectionInSection:(NSInteger)section
{
	for (FDThemeSection *themeSection in themeSections) {
		if (themeSection.ordered.integerValue == section) {
			return themeSection;
		}
	}
	return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	FDThemeSection *themeSection = [self themeSectionInSection:section];
	if ([themeSection.style isEqualToString:kThemeStyleIdentifierIcon]) {
		return [FDThemeSectionHeaderView height];
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	FDThemeSection *themeSection = [self themeSectionInSection:section];
	NSDictionary *attributes = [FDThemeCell attributesOfStyle:themeSection.style];
	if (attributes[kThemeCellAttributeKeyHeaderTitle]) {
		FDThemeSectionHeaderView *headerView = [[FDThemeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [FDThemeSectionHeaderView height])];
		headerView.title = themeSection.title;
		return headerView;
	}
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger count = 0;
	for (FDThemeSection *section in themeSections) {
		count += section.isEmpty ? 0 : 1;
	}
	return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FDThemeSection *themeSection = [self themeSectionInSection:indexPath.section];
	NSDictionary *attributes = [FDThemeCell attributesOfStyle:themeSection.style];
	return CGRectFromString(attributes[kThemeCellAttributeKeyBounds]).size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//no reuse for remember themecell's scroll position
	NSString *noReuseIdentiifer = [NSString stringWithFormat:@"%@%@", [FDThemeCell identifier], @(indexPath.section)];
	FDThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:noReuseIdentiifer];
	if (!cell) {
		cell = [[FDThemeCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:noReuseIdentiifer];
		cell.delegate = self;
	}
	FDThemeSection *themeSection = [self themeSectionInSection:indexPath.section];
	NSDictionary *attributes = [FDThemeCell attributesOfStyle:themeSection.style];
	cell.attributes = attributes;
	cell.themeSection = themeSection;
	return cell;
}

#pragma mark - FDThemeCellDelegate

- (void)didSelectTheme:(FDTheme *)theme inThemeSection:(FDThemeSection *)themeSection
{
	NSLog(@"select theme: %@ in themeSection: %@", theme, themeSection);
	if ([theme.type isEqualToString:kThemeTypeIdentifierPhoto]) {
		FDPhotosViewController *photosViewController = [[FDPhotosViewController alloc] init];
		photosViewController.themeID = theme.ID;
		[self.navigationController pushViewController:photosViewController animated:YES];
	} else if ([theme.type isEqualToString:kThemeTypeIdentifierUser]) {
		//[self.navigationController pushViewController:[[FDUserProfileViewController alloc] init] animated:YES];
	}
}

@end
