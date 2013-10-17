//
//  FDSecondViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDDiscoveryViewController.h"
#import "FDThemeCell.h"
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
		sectionsAttributesMap[@(0)] = [FDThemeCell attributesOfSlideADStyle];
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
			
			NSMutableArray *slideADs = [NSMutableArray array];
			NSMutableArray *icons = [NSMutableArray array];
			NSMutableArray *brands = [NSMutableArray array];
			
			for (FDTheme *theme in themes) {
				if (theme.categoryID.integerValue == 0) {
					[slideADs addObject:theme];
				} else if (theme.categoryID.integerValue == 1) {
					[icons addObject:theme];
				} else if (theme.categoryID.integerValue == 2) {
					[brands addObject:theme];
				}
			}
			themesMap = @{@(0) : slideADs, @(1) : icons, @(2) : brands};
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
	} else return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSDictionary *attributes = sectionsAttributesMap[@(section)];
	if (attributes[kThemeCellAttributeKeyHeaderTitle]) {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
		label.text = attributes[kThemeCellAttributeKeyHeaderTitle];
		return label;
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
