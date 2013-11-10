//
//  UITableViewCell+Find.m
//  find
//
//  Created by zhangbin on 11/10/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "UITableViewCell+Find.h"

@implementation UITableViewCell (Find)

+ (NSString *)identifier
{
	static NSString *kUITableViewCellIdentifier = @"kUITableViewCellIdentifier";
	return kUITableViewCellIdentifier;
}

@end
