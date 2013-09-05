//
//  FDPhoto.m
//  find
//
//  Created by zhangbin on 8/31/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhoto.h"

@implementation FDPhoto

- (void)setUrlString:(NSString *)urlString
{
	if ([_urlString isEqualToString:urlString]) return;
	_urlString = urlString;
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
