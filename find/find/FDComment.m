//
//  FDComment.m
//  find
//
//  Created by zhangbin on 9/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDComment.h"

@implementation FDComment

+ (FDComment *)createWithAttributes:(NSDictionary *)attributes
{
	FDComment *comment = [[FDComment alloc] init];
	NSAssert(attributes[@"id"], @"A comment must have a id!");
	
	comment.ID = attributes[@"id"];
	comment.userID = attributes[@"mid"];
	comment.username = attributes[@"username"];
	comment.content = attributes[@"content"];
	comment.typeID = attributes[@"typeid"];
	comment.type = attributes[@"type"];
	comment.published = attributes[@"published"];
	return comment;
}

+ (NSArray *)createMutableWithData:(NSArray *)data
{
	NSMutableArray *comments = [NSMutableArray array];
	for (NSDictionary *attributes in data) {
		FDComment *comment = [self createWithAttributes:attributes];
		[comments addObject:comment];
	}
	return comments;
}
- (NSString *)description
{
	return [NSString stringWithFormat:@"<id: %@, published: %@, username: %@, content: %@>", _ID, [_published printableTimestamp], _username, _content];
}

@end
