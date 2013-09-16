//
//  FDPhoto.m
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhoto.h"

@implementation FDPhoto

+ (FDPhoto *)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"A photo must have an ID!");
	FDPhoto *photo = [[FDPhoto alloc] init];
	photo.ID = attributes[@"id"];
	photo.userID = attributes[@"mid"];
	photo.tweetID = attributes[@"ptid"];
	photo.type = attributes[@"type"];
	photo.urlString = attributes[@"path"];
	photo.likes = attributes[@"likes"];
	photo.views = attributes[@"views"];
	photo.uploaded = attributes[@"uploaded"];
	return photo;
}

+ (NSArray *)createMutableWithData:(NSArray *)data
{
	NSMutableArray *photos = [NSMutableArray array];
	for (NSDictionary *attributes in data) {
		[photos addObject:[self createWithAttributes:attributes]];
	}
	return photos;
}

- (NSString *)urlStringInfo
{
	return [NSString stringWithFormat:@"%@?imageInfo", _urlString];
}

- (NSString *)urlStringScaleAspectFit:(CGSize)size
{
	return [NSString stringWithFormat:@"%@?imageView/1/w/%d/h/%d", _urlString, (NSUInteger)size.width, (NSUInteger)size.height];
}

- (NSString *)urlStringScaleFitWidth:(CGFloat)width
{
	return [NSString stringWithFormat:@"%@?imageView/2/w/%d", _urlString, (NSUInteger)width];
}

- (void)fetchInfoWithCompletionBlock:(dispatch_block_t)block
{
	[[ZBQNAFHTTPClient shared] infoOfPhoto:self completionBlockWithSuccess:^(FDPhotoInfo *info) {
		_info = info;
		if (block) block();
	}];
}

@end
