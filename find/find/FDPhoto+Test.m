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

+ (NSArray *)creatTest:(NSUInteger)count
{
	NSMutableArray *photos = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		[photos addObject:[self createOne]];
	}
	return photos;
}

+ (FDPhoto *)createOne
{
	NSUInteger random = arc4random() % kCountOfTestPhoto + 1;
	FDPhoto *photo = [[FDPhoto alloc] init];
	photo.urlString = [NSString stringWithFormat:@"%@%d.jpg", QINIU_HOST, random];
	return photo;
}

@end
