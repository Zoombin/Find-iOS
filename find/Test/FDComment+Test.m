//
//  FDComment+Test.m
//  find
//
//  Created by zhangbin on 10/23/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDComment+Test.h"

//@property (nonatomic, strong) NSNumber *ID;
//@property (nonatomic, strong) NSNumber *userID;
//@property (nonatomic, strong) NSString *username;
//@property (nonatomic, strong) NSString *content;
//@property (nonatomic, strong) NSNumber *typeID;//评论对象id
//@property (nonatomic, strong) NSNumber *type;
//@property (nonatomic, strong) NSNumber *published;

//"id": 17,
//"mid": 1,
//"username": "root",
//"content": "comment at:2013-23-22 17:10:09",
//"typeid": 1,
//"type": 0,
//"publiship": 1884701257,
//"published": 1382433823


@implementation FDComment (Test)

+ (NSArray *)createTest:(NSUInteger)count
{
//	static NSDictionary *commentAttributes = @{@"id" : @(17), @"mid" : @(1), @"username" : @"root", @"content" : @"comment at:2013-23-22 17:10:09", @"typeid" : @(1), @"type" : @(0), @"publiship" :  @(1884701257), @"published" : @(1382433823)};
	NSMutableArray *comments = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		
		
	}
	return comments;
}

//+ (FDComment *)createTestOne
//{
//	FDComment *user = [[FDUser alloc] init];
//	user.photos = [FDPhoto createTest:100];
//	return user;
//}

@end
