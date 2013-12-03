//
//  FDSessionInvalidCell.m
//  find
//
//  Created by zhangbin on 12/3/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDSessionInvalidCell.h"

@implementation FDSessionInvalidCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, [[self class] height])];
		label.text = NSLocalizedString(@"Tap to signin/signup.", nil);
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [UIFont fdThemeFontOfSize:16];
		label.backgroundColor = [UIColor randomColor];
		[self.contentView addSubview:label];
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
	return 90;
}

@end
