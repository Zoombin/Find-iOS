//
//  FDEvent.m
//  find
//
//  Created by zhangbin on 10/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDTheme.h"

@implementation FDTheme

+ (FDTheme *)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"Every event must has an ID!");
	FDTheme *theme = [[FDTheme alloc] init];
	
	theme.ID = attributes[@"id"];
	theme.name = attributes[@"name"];
	//theme.typeID = attributes[@"typeid"];
	theme.categoryID = attributes[@"aid"];
	theme.order = attributes[@"order"];
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
	return [NSString stringWithFormat:@"<THEME: id: %@, aid: %@, name: %@, categoryID: %@, order: %@, image: %@>", _ID, _categoryID, _name, _categoryID, _order, _imagePath];
}

- (NSString *)imagePath
{
	return [NSString stringWithFormat:@"%@%@", QINIU_FIND_SERVER, _imagePath];
}

@end
