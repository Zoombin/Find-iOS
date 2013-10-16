//
//  FDEvent.m
//  find
//
//  Created by zhangbin on 10/16/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDEvent.h"

@implementation FDEvent

+ (FDEvent *)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"Every event must has an ID!");
	FDEvent *event = [[FDEvent alloc] init];
	
	event.ID = attributes[@"id"];
	event.name = attributes[@"name"];
//	event.typeID = attributes[@"typeid"];
	event.categoryID = attributes[@"aid"];
	event.order = attributes[@"order"];
	return event;
}

+ (NSArray *)createMutableWithData:(NSArray *)data
{
	NSMutableArray *events = [NSMutableArray array];
	for (NSDictionary *attributes in data) {
		[events addObject:[self createWithAttributes:attributes]];
	}
	return events;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<EVENT: id: %@, name: %@, categoryID: %@, order: %@>", _ID, _name, _categoryID, _order];
}

@end
