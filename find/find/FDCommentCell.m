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
	UIImageView *headView;
	UILabel *dateLabel;
	CGFloat height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.backgroundColor = [UIColor grayColor];
		
//		CGPoint startPoint = CGPointZero;
		
//		headView = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, HeadSize.width, HeadSize.height)];
//		headView.contentMode = UIViewContentModeScaleToFill;
		//[self addSubview:headView];
		
		self.textLabel.font = [self.class commentContentFont];
		self.textLabel.textColor = [UIColor blackColor];
		self.textLabel.numberOfLines = 0;
		self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;//TODO: ios7 enum, what if lower?
		
//		startPoint.x = CGRectGetWidth(headView.frame) + kGap;
//		startPoint.y = 0;
		
		//dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, self.bounds.size.width - startPoint.x, 20)];
//		dateLabel = [[UILabel alloc] init];
//		dateLabel.textColor = [UIColor lightTextColor];
//		dateLabel.font = [UIFont systemFontOfSize:12];
//		[self.contentView addSubview:dateLabel];
    }
    return self;
}

- (void)setComment:(FDComment *)comment
{
	if (_comment == comment) return;
	_comment = comment;

	//NSString *path = [NSString stringWithFormat:@"%@%@", QINIU_HOST, @"1.jpg"];//TODO: test
	//[headView setImageWithURL:[NSURL URLWithString:path]];

	self.textLabel.text = [NSString stringWithFormat:@"%@ : %@", _comment.username, _comment.content];
}


+ (CGFloat)heightForComment:(FDComment *)comment boundingRectWithWidth:(CGFloat)width
{
	NSString *text = [NSString stringWithFormat:@"%@ : %@", comment.username, comment.content];
	CGRect textFrame = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [self.class commentContentFont]} context:nil];
	return textFrame.size.height + 30;
}


static UIFont *contentFont;
+ (UIFont *)commentContentFont
{
	if (!contentFont) {
		contentFont = [UIFont systemFontOfSize:13];
	}
	return contentFont;
}

@end
