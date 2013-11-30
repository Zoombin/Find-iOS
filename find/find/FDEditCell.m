//
//  FDEditCell.m
//  find
//
//  Created by zhangbin on 11/14/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDEditCell.h"

@implementation FDEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
	return nil;
}

- (void)becomeFirstResponder
{
	
}

+ (CGFloat)height
{
	return 0;
}

+ (CGFloat)heightOfFooter
{
	return 0;
}

+ (NSInteger)numberOfRows
{
	return 0;
}


@end
