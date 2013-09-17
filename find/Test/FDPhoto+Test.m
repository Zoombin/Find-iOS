//
//  FDPhoto+Test.m
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhoto+Test.h"

#define kCountOfTestPhoto 308

@implementation FDPhoto (Test)

+ (NSArray *)createTest:(NSUInteger)count
{
	NSMutableArray *photos = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		[photos addObject:[self createTestOne]];
	}
	return photos;
}

+ (FDPhoto *)createTestOne
{
	NSUInteger random = arc4random() % kCountOfTestPhoto + 1;
	FDPhoto *photo = [[FDPhoto alloc] init];
	photo.path = [NSString stringWithFormat:@"%d.jpg", random];
	return photo;
}

@end
