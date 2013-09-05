//
//  FDUser.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDUser.h"

@implementation FDUser

- (FDPhoto *)mainPhoto
{
	if (_photos.count) {
		return _photos[0];
	}
	return nil;
}

@end
