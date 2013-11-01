//
//  FDPhoto.m
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhoto.h"
#import "NSString+Qiniu.h"

@implementation FDPhoto

+ (FDPhoto *)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"A photo must have an ID!");
	FDPhoto *photo = [[FDPhoto alloc] init];
	photo.ID = attributes[@"id"];
	photo.userID = attributes[@"mid"];
	photo.tweetID = attributes[@"ptid"];
	photo.type = attributes[@"type"];
	photo.path = attributes[@"path"];
	photo.likes = attributes[@"likes"];
	photo.liked = attributes[@"liked"];
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

- (NSString *)urlString
{
	return [NSString stringWithFormat:@"%@", _path];
}

- (NSURL *)url
{
	return [NSURL URLWithString:[self urlString]];
}

- (NSString *)urlStringInfo
{
	return [[self urlString] qnImageInfo];
}

- (NSString *)urlStringScaleAspectFit:(CGSize)size
{
	return [[self urlString] qnScaleAspectFit:size];
}

- (NSString *)urlStringScaleFitWidth:(CGFloat)width
{
	return [[self urlString] qnScaleFitWidth:width];
}

- (NSURL *)urlScaleFitWidth:(CGFloat)width
{
	return [NSURL URLWithString:[self urlStringScaleFitWidth:width]];
}

- (NSString *)urlstringCropToSize:(CGSize)size
{
	NSLog(@"urlstringCropToSize: %@", [[self urlString] qnCropFromCenterToSize:size]);
	return [[self urlString] qnCropFromCenterToSize:size];
}

- (void)fetchInfoWithCompletionBlock:(dispatch_block_t)block
{
	[[FDAFHTTPClient shared] infoOfPhoto:self.urlStringInfo completionBlockWithSuccess:^(NSDictionary *infoAttributes) {
		_info = [FDPhotoInfo createWithAttributes:infoAttributes];
		if (block) block();
	}];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<ID: %@, userID: %@, path: %@, likes: %@>", _ID, _userID, _path, _likes];
}

@end
