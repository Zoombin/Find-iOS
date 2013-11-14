//
//  FDThemeSection.m
//  find
//
//  Created by zhangbin on 10/22/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDThemeSection.h"
#import "FDTheme.h"

NSString *kThemeStyleIdentifierSlide = @"slide";
NSString *kThemeStyleIdentifierIcon = @"icon";
NSString *kThemeStyleIdentifierBrand = @"brand";

@implementation FDThemeSection

+ (instancetype)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"A themeSection must have a ID!");
	FDThemeSection *themeSection = [[FDThemeSection alloc] init];
	themeSection.ID = attributes[@"id"];
	themeSection.name = attributes[@"secname"];
	themeSection.title = attributes[@"title"];
	themeSection.ordered = attributes[@"ordered"];
	
	if ([themeSection.name hasPrefix:kThemeStyleIdentifierSlide]) {
		themeSection.style = kThemeStyleIdentifierSlide;
	} else if ([themeSection.name hasPrefix:kThemeStyleIdentifierIcon]) {
		themeSection.style = kThemeStyleIdentifierIcon;
	} else if ([themeSection.name hasPrefix:kThemeStyleIdentifierBrand]) {
		themeSection.style = kThemeStyleIdentifierBrand;
	}
	
	NSArray *themeData = attributes[@"events"];
	themeSection.themes = [FDTheme createMutableWithData:themeData];
	for (FDTheme *theme in themeSection.themes) {
		theme.style = themeSection.style;
	}
	return themeSection;
}

+ (NSArray *)createMutableWithData:(NSArray *)data
{
	NSMutableArray *themeSections = [NSMutableArray array];
	for (NSDictionary *attributes in data) {
		[themeSections addObject:[self createWithAttributes:attributes]];
	}
	return themeSections;
}

- (BOOL)isEmpty
{
	return (!(BOOL)_themes.count);
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<section: id: %@, name: %@, ordered: %@, style: %@>", _ID, _name, _ordered, _style];
}

@end
