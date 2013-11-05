//
//  FDVoteCell.m
//  find
//
//  Created by zhangbin on 11/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDVoteCell.h"

@implementation FDVoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor randomColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat)height
{
	return 40;
}

@end
