//
//  FDPhotoCell.m
//  find
//
//  Created by zhangbin on 12/11/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDPhotoCell.h"
#import "FDAvatarView.h"
#import "FDLikesView.h"

#define kGap 2

@interface FDPhotoCell ()

@property (readwrite) UIImageView *photoView;
@property (readwrite) FDLikesView *likesView;
@property (readwrite) UILabel *addressLabel;

@end

@implementation FDPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		//self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		CGPoint start = CGPointMake(self.indentationWidth, kGap);
		_photoView = [[UIImageView alloc] initWithFrame:CGRectMake(start.x, start.y, [[self class] height] - kGap * 2, [[self class] height] - kGap * 2)];
		_photoView.backgroundColor = [UIColor randomColor];
		[self.contentView addSubview:_photoView];
		
		start = CGPointMake(CGRectGetMaxX(_photoView.frame) + 10, 0);
		
		_likesView = [[FDLikesView alloc] initWithFrame:CGRectMake(start.x, start.y, [FDLikesView size].width, [FDLikesView size].height)];
		[self.contentView addSubview:_likesView];
		
		start.y = CGRectGetMaxY(_likesView.frame);
		
		_addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, self.bounds.size.width - start.x, 15)];
		_addressLabel.backgroundColor = [UIColor randomColor];
		[self.contentView addSubview:_addressLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)height
{
	return 80;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	_photoView.image = nil;
	_photo = nil;
	_photo.path = nil;
	_addressLabel.text = nil;
	_likesView.liked = nil;
	_likesView.likes = nil;
}

- (void)setPhoto:(FDPhoto *)photo
{
	_photo = photo;
	if (_photo.path) {
		[_photoView setImageWithURL:[NSURL URLWithString:[_photo urlstringCropToSize:CGSizeMake([[self class] height] - kGap * 2, [[self class] height] - kGap * 2)]]];
	}
	_addressLabel.text = [_photo.ID stringValue];//TODO: should address
	_likesView.liked = _photo.liked;
	_likesView.likes = _photo.likes;
}

@end
