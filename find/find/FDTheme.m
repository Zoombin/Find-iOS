//
//  FDEvent.m
//  find
//
//  Created by zhangbin on 10/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDTheme.h"

NSString *kThemeTypeIdentifierPhoto = @"photo";
NSString *kThemeTypeIdentifierUser = @"member";

@implementation FDTheme

+ (FDTheme *)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"Every event must has an ID!");
	FDTheme *theme = [[FDTheme alloc] init];
	
	theme.ID = attributes[@"id"];
	theme.title = attributes[@"title"];
	theme.subtitle = attributes[@"subtitle"];
	theme.imagePath = attributes[@"img"];
	theme.type = attributes[@"type"];
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
	return [NSString stringWithFormat:@"<THEME: id: %@, title: %@, subtitle: %@, type: %@, image: %@>", _ID, _title, _subtitle, _type, _imagePath];
}

- (NSString *)imagePath
{
	return [NSString stringWithFormat:@"%@", _imagePath];
}

@end
