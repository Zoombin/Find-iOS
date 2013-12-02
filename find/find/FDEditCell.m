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
        // Initialization code
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

- (UIView *)footerWithText:(NSString *)text
{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
	label.numberOfLines = 0;
	label.text = text;
	label.font = [UIFont fdThemeFontOfSize:13];
	label.textAlignment = NSTextAlignmentCenter;
	//label.backgroundColor = [UIColor randomColor];
	return label;
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

@end
