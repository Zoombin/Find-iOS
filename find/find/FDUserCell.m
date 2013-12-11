//
//  FDUserCell.m
//  find
//
//  Created by zhangbin on 11/14/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDUserCell.h"
#import "FDAvatarView.h"

@interface FDUserCell ()

@property (readwrite) FDAvatarView *avatar;
@property (readwrite) UILabel *nameLabel;

@end

@implementation FDUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		CGSize avatarSize = [FDAvatarView defaultSize];
		CGPoint start = CGPointMake(self.indentationWidth, (self.bounds.size.height - avatarSize.height) / 2);
		
		_avatar = [[FDAvatarView alloc] initWithFrame:CGRectMake(start.x, start.y, avatarSize.width, avatarSize.height)];
		[self.contentView addSubview:_avatar];
		
		start = CGPointMake(CGRectGetMaxX(_avatar.frame) + 5, 0);
		_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, self.bounds.size.width - start.x, self.bounds.size.height)];
		_nameLabel.backgroundColor = [UIColor randomColor];//TODO
		_nameLabel.font = [UIFont fdThemeFontOfSize:9];
		[self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	_user = nil;
	_avatar.userID = nil;
	_nameLabel.text = nil;
}

- (void)setUser:(FDUser *)user
{
	if (_user == user) return;
	_user = user;
	_avatar.imagePath = _user.avatarPath;
	//_avatar.userID = _user.ID;//TODO:
	_nameLabel.text = _user.nickname;
}

+ (NSString *)identifier
{
	static NSString *kFDUserCellIdentifier = @"kFDUserCellIdentifier";
	return kFDUserCellIdentifier;
}

@end
