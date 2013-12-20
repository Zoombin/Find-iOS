//
//  FDStuffCell.m
//  find
//
//  Created by zhangbin on 12/20/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDStuffCell.h"

@implementation FDStuffCell

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

    // Configure the view for the selected state
}

@end
