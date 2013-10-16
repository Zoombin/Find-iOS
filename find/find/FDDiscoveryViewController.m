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
	NSArray *themes;
	NSArray *slideADThemes;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		NSString *identifier = NSLocalizedString(@"Discovery", nil);
		self.title = identifier;
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:identifier] tag:0];
		//self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:identifier] selectedImage:[UIImage imageNamed:identifier]];
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
	
	sectionsAttributesMap = [NSMutableDictionary dictionary];
	sectionsAttributesMap[@(0)] = [FDThemeCell attributesOfSlideADStyle];
	sectionsAttributesMap[@(1)] = [FDThemeCell attributesOfIconStyle];
	
	[[FDAFHTTPClient shared] themeListWithCompletionBlock:^(BOOL success, NSString *message, NSArray *themesData) {
		if (success) {
			themes = [FDTheme createMutableWithData:themesData];
			
			NSMutableArray *slideADs = [NSMutableArray array];
			for (FDTheme *theme in themes) {
				if (theme.categoryID.integerValue == 0) {
					[slideADs addObject:theme];
				}
			}
			slideADThemes = slideADs;
			
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
	return 2;
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
	NSDictionary *attributes;
	if (indexPath.section == 0) {
		attributes = [FDThemeCell attributesOfSlideADStyle];
	} else {
		attributes = [FDThemeCell attributesOfIconStyle];
	}
	cell = [[FDThemeCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:kFDThemeCellIdentifier];
	cell.attributes = attributes;
	cell.items = slideADThemes;
	NSLog(@"slideADThemes: %@", slideADThemes);
	return cell;
}



@end
