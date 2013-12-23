//
//  FDIdentityCell.m
//  find
//
//  Created by zhangbin on 12/23/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDIdentityCell.h"

@interface FDIdentityCell ()

@end

@implementation FDIdentityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_inputField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, self.bounds.size.width - 60, self.bounds.size.height)];
		//_inputField.backgroundColor = [UIColor randomColor];
		[self.contentView addSubview:_inputField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
