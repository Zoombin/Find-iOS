//
//  FDMeCell.m
//  find
//
//  Created by zhangbin on 12/3/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDMeCell.h"

@interface FDMeCell ()

@property (nonatomic, strong) FDAvatarView *avatar;
@property (readwrite) UIImageView *genderIcon;
@property (readwrite) UILabel *nicknameLabel;
@property (readwrite) UILabel *signatureLabel;
@property (readwrite) UILabel *shapeLabel;
@property (readwrite) UILabel *privacyLabel;

@end

@implementation FDMeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		CGSize avatarSize = [FDAvatarView bigSize];
		CGRect frame = CGRectMake(self.indentationWidth, ([[self class] height] - avatarSize.height) / 2, avatarSize.width, avatarSize.height);
        _avatar = [[FDAvatarView alloc] initWithFrame:frame];
		//_avatar.backgroundColor = [UIColor randomColor];//TODO: test
		[self.contentView addSubview:_avatar];
		
		frame = CGRectMake(CGRectGetMaxX(_avatar.frame) + 5, CGRectGetMinY(_avatar.frame), 20, 20);
		_genderIcon = [[UIImageView alloc] initWithFrame:frame];
		_genderIcon.contentMode = UIViewContentModeScaleAspectFill;
		[self.contentView addSubview:_genderIcon];
		
		frame.origin.x = CGRectGetMaxX(_genderIcon.frame);
		frame.size.width = 200;
		frame.size.height = 30;
		
		_nicknameLabel = [[UILabel alloc] initWithFrame:frame];
		//_nicknameLabel.backgroundColor = [UIColor randomColor];//TODO: test
		_nicknameLabel.font = [UIFont fdThemeFontOfSize:15];
		[self.contentView addSubview:_nicknameLabel];
		
		frame.origin.x = CGRectGetMinX(_genderIcon.frame);
		frame.origin.y = CGRectGetMaxY(_nicknameLabel.frame);
		frame.size.width = 220;
		frame.size.height = 15;
		
		_signatureLabel = [[UILabel alloc] initWithFrame:frame];
		//_signatureLabel.backgroundColor = [UIColor randomColor];//TODO: test
		_signatureLabel.font = [UIFont fdThemeFontOfSize:9];
		[self.contentView addSubview:_signatureLabel];
		
		frame.origin.y = CGRectGetMaxY(_signatureLabel.frame);
		frame.size.height = 15;
		
		_shapeLabel = [[UILabel alloc] initWithFrame:frame];
		//_shapeLabel.backgroundColor = [UIColor randomColor];//TODO: test
		_shapeLabel.font = [UIFont fdThemeFontOfSize:9];
		[self.contentView addSubview:_shapeLabel];
		
		frame.origin.y = CGRectGetMaxY(_shapeLabel.frame);
		_privacyLabel = [[UILabel alloc] initWithFrame:frame];
		//_privacyLabel.backgroundColor = [UIColor randomColor];//TODO: test
		_privacyLabel.font = [UIFont fdThemeFontOfSize:9];
		[self.contentView addSubview:_privacyLabel];
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
	_avatar.image = nil;
	_genderIcon.image = nil;
	_nicknameLabel.text = nil;
	_signatureLabel.text = nil;
	_shapeLabel.text = nil;
	_privacyLabel.text = nil;
}

- (void)setProfile:(FDUserProfile *)profile
{
	_profile = profile;
	if (!_profile) return;
	[_avatar setImageWithURL:[NSURL URLWithString:_profile.avatarPath]];
	_genderIcon.image = _profile.bFemale ? [UIImage imageNamed:@"IconFemale"] : [UIImage imageNamed:@"IconMale"];
	_nicknameLabel.text = _profile.nickname;
	_signatureLabel.text = _profile.signature;
	//_shapeLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@", NSLocalizedString(@"Age", nil), NSLocalizedString(@"Height", nil), NSLocalizedString(@"Weight", nil), NSLocalizedString(@"Chest", nil)];
	_privacyLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@", NSLocalizedString(@"Mobile", nil), NSLocalizedString(@"QQ", nil), NSLocalizedString(@"Weixin", nil), NSLocalizedString(@"Address", nil)];
	_shapeLabel.text = [NSString stringWithFormat:@"%@%@/%@%@/%@%@/%@%@", NSLocalizedString(@"Age", nil), [_profile.age printableAge], NSLocalizedString(@"Height", nil), [_profile.height printableHeight], NSLocalizedString(@"Weight", nil), [_profile.weight printableWeight], NSLocalizedString(@"Chest", nil), [_profile.chest printableChest]];
	//_privacyLabel.text = [NSString stringWithFormat:@"%@%@/%@%@/%@%@/%@%@", NSLocalizedString(@"Mobile", nil), [_profile.mobileInformation displayPrivacyType], NSLocalizedString(@"QQ", nil), [_profile.qqInformation displayPrivacyType], NSLocalizedString(@"Weixin", nil), [_profile.weixinInformation displayPrivacyType], NSLocalizedString(@"Address", nil), [_profile.addressInformation displayPrivacyType]];
}

+ (CGFloat)height
{
	return 90;
}

@end
