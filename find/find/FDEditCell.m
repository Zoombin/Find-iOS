//
//  FDEditCell.m
//  find
//
//  Created by zhangbin on 12/2/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDEditCell.h"

@implementation FDEditCell

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

- (NSString *)identifier
{
	static NSString *identifier = @"FDEditCellIdentifer";
	return identifier;
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
	return 1;
}

- (NSString *)content
{
	return @"";
}

@end
