//
//  FDCommentCell.m
//  find
//
//  Created by zhangbin on 9/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDCommentCell.h"
#import "UIImageView+AFNetworking.h"

#define kGap 10

@implementation FDCommentCell
{
	UILabel *commentLabel;
	UIImageView *headView;
	UILabel *dateLabel;
	CGFloat height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//- (id)initWithFrame:(CGRect)frame
{
    //self = [super initWithFrame:frame];
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.backgroundColor = [UIColor grayColor];
		
		CGPoint startPoint = CGPointZero;
		
		headView = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, HeadSize.width, HeadSize.height)];
		headView.contentMode = UIViewContentModeScaleToFill;
		//[self addSubview:headView];
		
		startPoint.x = CGRectGetWidth(headView.frame) + kGap;
		startPoint.y = 0;
		
        commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, self.bounds.size.width - startPoint.x, 50)];
		commentLabel.numberOfLines = 0;
		commentLabel.font = [UIFont systemFontOfSize:16];
		commentLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:commentLabel];
		
		//startPoint.x = CGRectGetMinX(commentLabel.frame) + kGap;
		//startPoint.y = CGRectGetHeight(commentLabel.frame) + kGap;
		
		//dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, self.bounds.size.width - startPoint.x, 20)];
		dateLabel = [[UILabel alloc] init];
		dateLabel.textColor = [UIColor lightTextColor];
		dateLabel.font = [UIFont systemFontOfSize:12];
		[self.contentView addSubview:dateLabel];
    }
    return self;
}

- (void)setComment:(FDComment *)comment
{
	if (_comment == comment) return;
	_comment = comment;

	//NSLog(@"comment: %@", _comment);
	NSString *path = [NSString stringWithFormat:@"%@%@", QINIU_HOST, @"1.jpg"];
	[headView setImageWithURL:[NSURL URLWithString:path]];
	
	commentLabel.text = [NSString stringWithFormat:@"%@ : %@", _comment.username, _comment.content];
	[commentLabel sizeToFit];
	
	//CGRect commentFrame = commentLabel.frame;
	//NSLog(@"commentFrame: %@", NSStringFromCGRect(commentFrame));
	
	CGPoint startPoint = CGPointZero;
	startPoint.x = CGRectGetMinX(commentLabel.frame) + kGap;
	startPoint.y = CGRectGetHeight(commentLabel.frame) + kGap;
	
	dateLabel.frame = CGRectMake(startPoint.x, startPoint.y, self.bounds.size.width - startPoint.x, 20);
	dateLabel.text = [_comment.published printableTimestamp];
	
	height = CGRectGetMaxY(dateLabel.frame);
	//self.frame = CGRectMake(0, 0, 320, CGRectGetMaxY(dateLabel.frame));
	//NSLog(@"self.frame: %@", NSStringFromCGRect(self.frame));
}

- (CGFloat)height
{
	return height;
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
