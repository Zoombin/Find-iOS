//
//  FDIdentityPasswordConfirmCell.m
//  find
//
//  Created by zhangbin on 12/23/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDIdentityPasswordConfirmCell.h"

@implementation FDIdentityPasswordConfirmCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.textLabel.text = NSLocalizedString(@"确认", nil);
		self.inputField.placeholder = NSLocalizedString(@"请再次输入密码", nil);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
