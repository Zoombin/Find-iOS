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
#define kWidthOfContentArea 200
#define kHeightOfDateLabel 10

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
		
//		self.backgroundColor = [UIColor grayColor];//TODO: test
		
		CGPoint startPoint = CGPointZero;
		
		startPoint.x = kGap;
		startPoint.y = kGap;
		
		CGSize avatarSize = [FDAvatarView defaultSize];
		avatar = [[FDAvatarView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, avatarSize.width, avatarSize.height)];
		[self.contentView addSubview:avatar];
		avatar.backgroundColor = [UIColor blueColor];
		
		startPoint.x = CGRectGetMaxX(avatar.frame) + kGap;
		startPoint.y = CGRectGetMinY(avatar.frame);
		
		contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, kWidthOfContentArea, 0)];
		contentLabel.font = [[self class] contentFont];
		contentLabel.numberOfLines = 0;
		contentLabel.textColor = [UIColor blackColor];
//		contentLabel.backgroundColor = [UIColor randomColor];//TODO: test
		contentLabel.lineBreakMode = NSLineBreakByWordWrapping;//TODO: ios7 enum, what if lower?
		[self.contentView addSubview:contentLabel];
		
		startPoint.x = CGRectGetMinX(contentLabel.frame);
		startPoint.y = CGRectGetMaxY(contentLabel.frame);
		
		dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, self.bounds.size.width - startPoint.x, kHeightOfDateLabel)];
		dateLabel.textColor = [UIColor lightGrayColor];
		dateLabel.font = [UIFont fdThemeFontWithSize:9];
//		dateLabel.backgroundColor = [UIColor randomColor];//TODO: test
		[self.contentView addSubview:dateLabel];
		
		startPoint.x = CGRectGetMaxX(contentLabel.frame);
		startPoint.y = CGRectGetMinY(contentLabel.frame);
		
		UIButton *tweetCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[tweetCommentButton setImage:[UIImage imageNamed:@"CommentGray"] forState:UIControlStateNormal];
		tweetCommentButton.backgroundColor = [UIColor randomColor];
		tweetCommentButton.contentMode = UIViewContentModeCenter;
		tweetCommentButton.showsTouchWhenHighlighted = YES;
		tweetCommentButton.frame = CGRectMake(startPoint.x, startPoint.y, self.bounds.size.width - startPoint.x, self.frame.size.height - 2 * startPoint.y);
		[tweetCommentButton addTarget:self action:@selector(willCommentOrReply:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:tweetCommentButton];
    }
    return self;
}

- (void)setComment:(FDComment *)comment
{
	if (_comment == comment) return;
	_comment = comment;
	
	contentLabel.text = [NSString stringWithFormat:@"%@ : %@", _comment.username, _comment.content];
	[contentLabel sizeToFit];
	
	CGRect newFrame = dateLabel.frame;
	newFrame.origin.y = CGRectGetMaxY(contentLabel.frame) + kGap;
	dateLabel.frame = newFrame;
	dateLabel.text = [_comment.published printableTimestamp];
	
//	if (_comment.userID) {
//		avatar.userID = _comment.userID;
//	}
}

- (void)willCommentOrReply:(FDComment *)comment
{
	[_delegate willCommentOrReply:comment];
}

+ (CGFloat)heightForComment:(FDComment *)comment
{
	NSString *text = [NSString stringWithFormat:@"%@ : %@", comment.username, comment.content];
	CGRect textFrame = [text boundingRectWithSize:CGSizeMake(kWidthOfContentArea, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [[self class] contentFont]} context:nil];
	return kGap + textFrame.size.height + kGap +  kHeightOfDateLabel + kGap;
}


static UIFont *contentFont;
+ (UIFont *)contentFont
{
	if (!contentFont) {
		contentFont = [UIFont fdThemeFontWithSize:13];
	}
	return contentFont;
}

@end
