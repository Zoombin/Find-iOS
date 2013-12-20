//
//  FDSecondViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDDiscoveryViewController.h"
#import "FDThemeCell.h"
#import "FDThemeHeaderView.h"
#import "FDThemeItemView.h"
#import "FDThemeSection.h"
#import "FDPhotosViewController.h"
#import "FDDetailsViewController.h"

@interface FDDiscoveryViewController () <UITableViewDataSource, UITableViewDelegate, FDThemeCellDelegate>

@property (readwrite) UITableView *tableView;
@property (readwrite) NSArray *themeSections;

@end

@implementation FDDiscoveryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"Discovery", nil);
		self.title = identifier;
		
		UIImage *normalImage = [UIImage imageNamed:@"Discovery"];
		UIImage *selectedImage = [UIImage imageNamed:@"DiscoveryHighlighted"];
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
			[self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];//TODO: trick
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:normalImage tag:0];
			[self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:normalImage];
		}
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	[[FDAFHTTPClient shared] themeListWithCompletionBlock:^(BOOL success, NSString *message, NSArray *themesData) {
		if (success) {
			_themeSections = [FDThemeSection createMutableWithData:themesData];
			[_tableView reloadData];
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
	for (FDThemeSection *themeSection in _themeSections) {
		if (themeSection.ordered.integerValue == section) {
			return themeSection;
		}
	}
	return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger count = 0;
	for (FDThemeSection *section in _themeSections) {
		count += section.isEmpty ? 0 : 1;
	}
	return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = 0;
	
	FDThemeSection *themeSection = [self themeSectionInSection:indexPath.section];
	NSDictionary *attributes = [FDThemeCell attributesOfStyle:themeSection.style];
	height += CGRectFromString(attributes[kThemeCellAttributeKeyBounds]).size.height;

	if (attributes[kThemeCellAttributeKeyHeaderTitle]) {
		height += [FDThemeHeaderView height];
	}
	return height;
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
	NSMutableDictionary *attributes = [[FDThemeCell attributesOfStyle:themeSection.style] mutableCopy];
	if ([themeSection.style isEqualToString:kThemeStyleIdentifierIcon]) {
		attributes[kThemeCellAttributeKeyHeaderTitle] = themeSection.title;
	}
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
		//photosViewController.hidesBottomBarWhenPushed = YES;
		photosViewController.themeID = theme.ID;
		[self.navigationController pushViewController:photosViewController animated:YES];
	} else if ([theme.type isEqualToString:kThemeTypeIdentifierUser]) {//TODO: should display users?
		FDPhotosViewController *photosViewController = [[FDPhotosViewController alloc] init];
		//photosViewController.hidesBottomBarWhenPushed = YES;
		photosViewController.themeID = theme.ID;
		[self.navigationController pushViewController:photosViewController animated:YES];
	}
}

- (void)didSelectShowAllInThemeSection:(FDThemeSection *)themeSection
{
	FDPhotosViewController *photosViewController = [[FDPhotosViewController alloc] init];
	//photosViewController.themeID = theme.ID;
	[self.navigationController pushViewController:photosViewController animated:YES];
}

@end
