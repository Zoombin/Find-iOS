//
//  FDEditNicknameCell.m
//  find
//
//  Created by zhangbin on 11/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDEditNicknameCell.h"

static NSInteger margin = 10;

@implementation FDEditNicknameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(margin, 0, self.bounds.size.width - 2 * margin, [[self class] height])];
		textField.backgroundColor = [UIColor randomColor];
		textField.placeholder = NSLocalizedString(@"New Nickname", nil);
		[self.contentView addSubview:textField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)footer
{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
	label.numberOfLines = 0;
	label.text = NSLocalizedString(@"Please input your nickname!", nil);
	label.font = [UIFont fdThemeFontOfSize:13];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor randomColor];
	return label;
}

+ (CGFloat)height
{
	return 40;
}

+ (CGFloat)heightOfFooter
{
	return 50;
}

+ (NSInteger)numberOfRows
{
	return 1;
}

@end
