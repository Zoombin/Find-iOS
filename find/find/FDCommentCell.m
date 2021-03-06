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
#define kWidthOfContentArea 220
#define kHeightOfDateLabel 10
#define kMinCellHeight 50
#define kMoreActionsLayoutOffset 40

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
		
//		self.backgroundColor = [UIColor randomColor];//TODO: test

		CGPoint startPoint = CGPointZero;
		
		startPoint.x = self.indentationWidth;
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
		_contentLabel.backgroundColor = [UIColor randomColor];//TODO: test
		_contentLabel.lineBreakMode = NSLineBreakByCharWrapping;//TODO: ios7 enum, what if lower?
		_contentLabel.userInteractionEnabled = YES;
		[self.contentView addSubview:_contentLabel];
		
		startPoint.x = CGRectGetMinX(_contentLabel.frame);
		startPoint.y = CGRectGetMaxY(_contentLabel.frame);
		
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, self.bounds.size.width - startPoint.x, kHeightOfDateLabel)];
		_dateLabel.textColor = [UIColor lightGrayColor];
		_dateLabel.font = [UIFont fdThemeFontOfSize:9];
		_dateLabel.userInteractionEnabled = YES;
//		_dateLabel.backgroundColor = [UIColor randomColor];//TODO: test
		[self.contentView addSubview:_dateLabel];
		
		startPoint.x = CGRectGetMaxX(_contentLabel.frame);
		startPoint.y = CGRectGetMinY(_contentLabel.frame);
		
		CGSize buttonSize = CGSizeMake(50, 40);
		
		UIButton *tweetCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[tweetCommentButton setImage:[UIImage imageNamed:@"Comment"] forState:UIControlStateNormal];
//		tweetCommentButton.backgroundColor = [UIColor randomColor];
		tweetCommentButton.contentMode = UIViewContentModeCenter;
		tweetCommentButton.showsTouchWhenHighlighted = YES;
		tweetCommentButton.frame = CGRectMake(startPoint.x, startPoint.y, buttonSize.width, buttonSize.height);
		[tweetCommentButton addTarget:self action:@selector(willCommentOrReply:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:tweetCommentButton];
		
		startPoint.x = CGRectGetMaxX(tweetCommentButton.frame);
		startPoint.y = CGRectGetMinY(tweetCommentButton.frame);
		
		UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[reportButton setImage:[UIImage imageNamed:@"ReportComment"] forState:UIControlStateNormal];
		[reportButton setImage:[UIImage imageNamed:@"ReportCommentHighlighted"] forState:UIControlStateHighlighted];
//		reportButton.backgroundColor = [UIColor randomColor];
		reportButton.contentMode = UIViewContentModeCenter;
		reportButton.showsTouchWhenHighlighted = YES;
		reportButton.frame = CGRectMake(startPoint.x, startPoint.y, buttonSize.width, buttonSize.height);
		[reportButton addTarget:self action:@selector(willReport) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:reportButton];
		
//		UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideMoreActions)];
//		swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
//		[self addGestureRecognizer:swipeGestureRecognizer];
    }
    return self;
}

- (void)showMoreActions
{
	CGFloat endX = -1 * kMoreActionsLayoutOffset;
	[self animationOfShowAndHideMoreActionsWithDestinationX:endX];
}

- (void)hideMoreActions
{
	CGFloat endX = 0;
	[self animationOfShowAndHideMoreActionsWithDestinationX:endX];
}

- (void)animationOfShowAndHideMoreActionsWithDestinationX:(CGFloat)endX
{
	[UIView animateWithDuration:0.25 animations:^{
		CGRect frame = self.frame;
		frame.origin.x = endX;
		frame.size.width -= endX;
		self.frame = frame;
	}];
}

- (void)showOrHideMoreActions
{
	CGFloat startX = self.frame.origin.x;
	if (startX < 0) {
		[self hideMoreActions];
	} else {
		[self showMoreActions];
	}
}

- (void)setComment:(FDComment *)comment
{
	if (_comment == comment) return;
	_comment = comment;
	_contentLabel.text = [[self class] displayContent:_comment];
	_dateLabel.text = [_comment.published printableTimestamp];
	_avatar.userID = _comment.userID;
}

- (void)setBMine:(BOOL)bMine
{
	_bMine = bMine;
	if (_bMine) {
		_contentLabel.textColor = [UIColor fdThemeRed];
	}
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

+ (NSString *)identifier
{
	static NSString *kFDCommentCellIdentifier = @"kFDCommentCellIdentifier";
	return kFDCommentCellIdentifier;
}

+ (CGFloat)heightForComment:(FDComment *)comment
{
	NSString *text = [self displayContent:comment];
	CGRect textFrame = [text boundingRectWithSize:CGSizeMake(kWidthOfContentArea, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [[self class] contentFont]} context:nil];
	return MAX(kGap + textFrame.size.height + kGap +  kHeightOfDateLabel + kGap, kMinCellHeight);
}

- (void)willReport
{
	[_delegate willReport:_comment];
}

+ (UIFont *)contentFont
{
	static UIFont *contentFont;
	if (!contentFont) {
		contentFont = [UIFont fdThemeFontOfSize:13];
	}
	return contentFont;
}

+ (NSString *)displayContent:(FDComment *)comment
{
	if (comment) {
		return [NSString stringWithFormat:@"%@: %@", comment.username, comment.content];
	}
	return nil;
}

@end
