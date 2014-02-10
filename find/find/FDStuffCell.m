//
//  FDStuffCell.m
//  find
//
//  Created by zhangbin on 12/20/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDStuffCell.h"
#import "FDAvatarView.h"

@interface FDStuffCell ()

@property (readwrite) FDAvatarView *avatar;
@property (readwrite) UILabel *priceLabel;

@end

@implementation FDStuffCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.backgroundColor = [UIColor randomColor];
		
		_priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 80, self.bounds.size.height)];
		//_priceLabel.backgroundColor = [UIColor randomColor];
		_priceLabel.numberOfLines = 0;
		_priceLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_priceLabel.font = [UIFont fdThemeFontOfSize:13];
		_priceLabel.textAlignment = NSTextAlignmentRight;
		[self.contentView addSubview:_priceLabel];
		
		self.textLabel.font = [UIFont fdThemeFontOfSize:14];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	_stuff = nil;
	_priceLabel.text = nil;
	self.textLabel.text = nil;
	self.imageView.image = nil;
}

- (void)setStuff:(FDStuff *)stuff
{
	_stuff = stuff;
	if (_stuff.iconPath) {
		[[[UIImageView alloc] init] setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_stuff.iconPath]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
			self.imageView.image = image;
		} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
			
		}];
	}
	self.textLabel.text = _stuff.name;
	_priceLabel.text = [_stuff.price printablePrice];
}

@end
