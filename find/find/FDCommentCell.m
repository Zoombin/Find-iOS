//
//  FDCommentCell.m
//  find
//
//  Created by zhangbin on 9/18/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDCommentCell.h"
#import "FDAvatarView.h"

#define kGap 5

@implementation FDCommentCell
{
	FDAvatarView *avatar;
	UILabel *contentLabel;
	UILabel *dateLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		self.backgroundColor = [UIColor grayColor];
		
		CGPoint startPoint = CGPointZero;
		
		startPoint.x = 8;
		startPoint.y = kGap;
		
		CGSize avatarSize = [FDAvatarView defaultSize];
		avatar = [[FDAvatarView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, avatarSize.width, avatarSize.height)];
		[self.contentView addSubview:avatar];
		
		startPoint.x = CGRectGetMaxX(avatar.frame) + kGap * 2;
		startPoint.y = CGRectGetMinY(avatar.bounds) - 10;
		
		NSLog(@"startPoint: %@", NSStringFromCGPoint(startPoint));
		
		contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, 200, 30)];
		contentLabel.font = [self.class commentContentFont];
		contentLabel.textColor = [UIColor blackColor];
		contentLabel.numberOfLines = 0;
		contentLabel.lineBreakMode = NSLineBreakByWordWrapping;//TODO: ios7 enum, what if lower?
		[self.contentView addSubview:contentLabel];
		
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
	
	contentLabel.text = [NSString stringWithFormat:@"%@ : %@", _comment.username, _comment.content];
	
	CGRect contentFrame = contentLabel.frame;
	
	CGFloat height = [self.class heightForComment:comment boundingRectWithWidth:contentLabel.frame.size.width];
	contentFrame.size.height = height;
	contentLabel.frame = contentFrame;
	
	if (_comment.userID) {
		avatar.userID = _comment.userID;
	}
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
