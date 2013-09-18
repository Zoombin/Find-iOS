//
//  FDCommentCell.m
//  find
//
//  Created by zhangbin on 9/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDCommentCell.h"

@implementation FDCommentCell
{
	UILabel *commentLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor grayColor];
		
        commentLabel = [[UILabel alloc] initWithFrame:self.bounds];
		commentLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:commentLabel];
    }
    return self;
}

- (void)setComment:(FDComment *)comment
{
	if (_comment == comment) return;
	_comment = comment;
	
	commentLabel.text = _comment.content;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
