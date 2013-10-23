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
#define kMinCellHeight 60

@interface FDCommentCell()

@property (readwrite) FDAvatarView *avatar;
@property (readwrite) UILabel *contentLabel;
@property (readwrite) UILabel *dateLabel;

@end

@implementation FDCommentCell

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
		_avatar = [[FDAvatarView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, avatarSize.width, avatarSize.height)];
		[self.contentView addSubview:_avatar];
		
		startPoint.x = CGRectGetMaxX(_avatar.frame) + kGap;
		startPoint.y = CGRectGetMinY(_avatar.frame);
		
		_contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, kWidthOfContentArea, kMinCellHeight)];
		_contentLabel.font = [[self class] contentFont];
		_contentLabel.numberOfLines = 0;
		_contentLabel.textColor = [UIColor blackColor];
//		_contentLabel.backgroundColor = [UIColor randomColor];//TODO: test
		_contentLabel.lineBreakMode = NSLineBreakByCharWrapping;//TODO: ios7 enum, what if lower?
		[self.contentView addSubview:_contentLabel];
		
		startPoint.x = CGRectGetMinX(_contentLabel.frame);
		startPoint.y = CGRectGetMaxY(_contentLabel.frame);
		
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, self.bounds.size.width - startPoint.x, kHeightOfDateLabel)];
		_dateLabel.textColor = [UIColor lightGrayColor];
		_dateLabel.font = [UIFont fdThemeFontOfSize:9];
//		_dateLabel.backgroundColor = [UIColor randomColor];//TODO: test
		[self.contentView addSubview:_dateLabel];
		
		startPoint.x = CGRectGetMaxX(_contentLabel.frame);
		startPoint.y = CGRectGetMinY(_contentLabel.frame);
		
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

+ (NSString *)displayContent:(FDComment *)comment
{
	if (comment) {
		return [NSString stringWithFormat:@"%@: %@", comment.username, comment.content];
	}
	return nil;
}

- (void)setComment:(FDComment *)comment
{
	if (_comment == comment) return;
	_comment = comment;
	_contentLabel.text = [[self class] displayContent:_comment];
	_dateLabel.text = [_comment.published printableTimestamp];
	_avatar.userID = _comment.userID;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	CGRect frame = _contentLabel.frame;
	[_contentLabel sizeToFit];
	frame.size.height = _contentLabel.frame.size.height;
	_contentLabel.frame = frame;
	
	frame = _dateLabel.frame;
	frame.origin.y = CGRectGetMaxY(_contentLabel.frame) + kGap;
	_dateLabel.frame = frame;
}


- (void)prepareForReuse
{
	[super prepareForReuse];
	_contentLabel.text = nil;
	_dateLabel.text = nil;
//	avatar.userID = nil;
//	avatar.image = nil;
	_comment.userID = nil;
	_comment = nil;
}

- (void)willCommentOrReply:(FDComment *)comment
{
	[_delegate willCommentOrReply:comment];
}

+ (CGFloat)heightForComment:(FDComment *)comment
{
	NSString *text = [self displayContent:comment];
	CGRect textFrame = [text boundingRectWithSize:CGSizeMake(kWidthOfContentArea, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [[self class] contentFont]} context:nil];
	return kGap + textFrame.size.height + kGap +  kHeightOfDateLabel + kGap;
}

+ (UIFont *)contentFont
{
	static UIFont *contentFont;
	if (!contentFont) {
		contentFont = [UIFont fdThemeFontOfSize:13];
	}
	return contentFont;
}

@end
