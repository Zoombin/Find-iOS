//
//  FDSecondViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDDiscoveryViewController.h"
#import "FDThemeCell.h"
#import "FDThemeHeader.h"
#import "FDThemeItemView.h"

@interface FDDiscoveryViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation FDDiscoveryViewController
{
	UITableView *discoveryTableView;
	NSMutableDictionary *sectionsAttributesMap;
	NSDictionary *themesMap;
	NSArray *themes;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"Discovery", nil);
		self.title = identifier;
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:identifier] tag:0];
		//self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:identifier] selectedImage:[UIImage imageNamed:identifier]];
		
		sectionsAttributesMap = [NSMutableDictionary dictionary];
		sectionsAttributesMap[@(0)] = [FDThemeCell attributesOfSlideStyle];
		sectionsAttributesMap[@(1)] = [FDThemeCell attributesOfIconStyle];
		sectionsAttributesMap[@(2)] = [FDThemeCell attributesOfBrandStyle];
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
			themes = [FDTheme createMutableWithData:themesData];
			
			NSMutableArray *slideThemes = [NSMutableArray array];
			NSMutableArray *iconThemes = [NSMutableArray array];
			NSMutableArray *brandThemes = [NSMutableArray array];
			
			for (FDTheme *theme in themes) {
				if ([theme.categoryIdentifier isEqualToString:kThemeCategoryIdentifierSlide]) {
					[slideThemes addObject:theme];
				} else if ([theme.categoryIdentifier isEqualToString:kThemeCategoryIdentifierIcon]) {
					[iconThemes addObject:theme];
				} else if ([theme.categoryIdentifier isEqualToString:kThemeCategoryIdentifierBrand]) {
					[brandThemes addObject:theme];
				}
			}
			themesMap = @{@(0) : slideThemes, @(1) : iconThemes, @(2) : brandThemes};
			[discoveryTableView reloadData];
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return 0;
	} else if (section == 1) {
		return [FDThemeHeader height];
	} else if (section == 2) {
		return 0;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSDictionary *attributes = sectionsAttributesMap[@(section)];
	if (attributes[kThemeCellAttributeKeyHeaderTitle]) {
		FDThemeHeader *header = [[FDThemeHeader alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [FDThemeHeader height])];
		header.title = attributes[kThemeCellAttributeKeyHeaderTitle];
		return header;
	}
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return themesMap.allKeys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *attributes = sectionsAttributesMap[@(indexPath.section)];
	return CGRectFromString(attributes[kThemeCellAttributeKeyBounds]).size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FDThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:kFDThemeCellIdentifier];
	if (!cell) {
		cell = [[FDThemeCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:kFDThemeCellIdentifier];
	}
	NSDictionary *attributes = sectionsAttributesMap[@(indexPath.section)];
	cell.attributes = attributes;
	cell.items = themesMap[@(indexPath.section)];
	return cell;
}



@end
