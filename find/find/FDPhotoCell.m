//
//  FDPhotoCell.m
//  find
//
//  Created by zhangbin on 12/11/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhotoCell.h"
#import "FDAvatarView.h"

@interface FDPhotoCell ()

@property (readwrite) FDAvatarView *avatar;

@end

@implementation FDPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)height
{
	return 35;
}

@end
