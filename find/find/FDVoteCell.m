//
//  FDVoteCell.m
//  find
//
//  Created by zhangbin on 11/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDVoteCell.h"

@interface FDVoteCell ()

@property (readwrite) UILabel *nameLabel;
@property (readwrite) UILabel *quantityLabel;
@property (readwrite) UIProgressView *percentageView;
@property (readwrite) UIButton *voteButton;

@end

@implementation FDVoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.backgroundColor = [UIColor randomColor];
		
		CGFloat gap = 10;
		CGPoint start = CGPointZero;
		
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, 50, [[self class] height])];
		_nameLabel.font = [UIFont fdThemeFontOfSize:13];
		_nameLabel.textAlignment = UITextAlignmentRight;
		_nameLabel.backgroundColor = [UIColor randomColor];//TODO
		[self.contentView addSubview:_nameLabel];
		
		start = CGPointMake(CGRectGetMaxX(_nameLabel.frame) + gap, 0);
		
		CGSize size = CGSizeMake(180, [[self class] height] / 2);
		
		_quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, size.width, size.height)];
		_quantityLabel.font = [UIFont fdBoldThemeFontOfSize:10];
		_quantityLabel.backgroundColor = [UIColor randomColor];//TODO
		[self.contentView addSubview:_quantityLabel];
		
		start.y = CGRectGetMaxY(_quantityLabel.frame);
		
		_percentageView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
		_percentageView.frame = CGRectMake(start.x, start.y, size.width, size.height);
		_percentageView.backgroundColor = [UIColor grayColor];
		_percentageView.tintColor = [UIColor fdThemeRed];
		[self.contentView addSubview:_percentageView];
		
		start = CGPointMake(CGRectGetMaxX(_percentageView.frame), 0);
		
		_voteButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_voteButton.titleLabel.font = [UIFont fdThemeFontOfSize:13];
		[_voteButton setTitle:NSLocalizedString(@"Vote", nil) forState:UIControlStateNormal];
		_voteButton.showsTouchWhenHighlighted = YES;
		[_voteButton setTitle:NSLocalizedString(@"Voted", nil) forState:UIControlStateSelected];
		_voteButton.frame = CGRectMake(start.x, start.y, self.bounds.size.width - start.x, [[self class] height]);
		_voteButton.backgroundColor = [UIColor randomColor];//TODO
		[_voteButton addTarget:self action:@selector(vote:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:_voteButton];
    }
    return self;
}

- (void)vote:(UIButton *)sender
{
	NSLog(@"vote: %@", _vote.name);
	_voteButton.selected = YES;
}

- (void)setVote:(FDVote *)vote
{
	if (_vote == vote) return;
	_vote = vote;
	_nameLabel.text = _vote.name;
	_quantityLabel.text = [_vote.quantity stringValue];
	_percentageView.progress = [_vote.percentage floatValue];
	_voteButton.selected = [_vote.voted boolValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

+ (CGFloat)height
{
	return 40;
}

@end
