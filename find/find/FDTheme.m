//
//  FDEvent.m
//  find
//
//  Created by zhangbin on 10/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDTheme.h"

@implementation FDTheme

NSString *kThemeCategoryIdentifierSlide = @"slide";
NSString *kThemeCategoryIdentifierIcon = @"icon";
NSString *kThemeCategoryIdentifierBrand = @"brand";

+ (FDTheme *)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"Every event must has an ID!");
	FDTheme *theme = [[FDTheme alloc] init];
	
	theme.ID = attributes[@"id"];
	theme.name = attributes[@"name"];
	theme.categoryIdentifier = attributes[@"area"];
	theme.imagePath = attributes[@"img"];
	return theme;
}

+ (NSArray *)createMutableWithData:(NSArray *)data
{
	NSMutableArray *themes = [NSMutableArray array];
	for (NSDictionary *attributes in data) {
		[themes addObject:[self createWithAttributes:attributes]];
	}
	return themes;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<THEME: id: %@, name: %@, categoryIdentifier: %@,  image: %@>", _ID, _name, _categoryIdentifier, _imagePath];
}

- (NSString *)imagePath
{
	return [NSString stringWithFormat:@"%@%@", QINIU_FIND_SERVER, _imagePath];
}

@end
