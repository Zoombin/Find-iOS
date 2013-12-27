//
//  FDGiftsCell.m
//  find
//
//  Created by zhangbin on 11/7/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDGiftsCell.h"

static NSInteger minimumQuantityOfGift = 1;

@interface FDGiftsCell ()

//@property (readwrite) UIButton *favPhotoButton;
//@property (readwrite) UIButton *favUserButton;
//@property (readwrite) UIButton *shareToWeiboButton;
//@property (readwrite) UIButton *shareToWeixinButton;
@property (readwrite) UITextField *diamondQuantityTextField;
@property (readwrite) UIButton *giftDiamondButton;
@property (readwrite) UIStepper *diamondStepper;
@property (readwrite) UITextField *flowerQuantityTextField;
@property (readwrite) UIButton *giftFlowerButton;
@property (readwrite) UIStepper *flowerStepper;

@end

@implementation FDGiftsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		//self.backgroundColor = [UIColor randomColor];
		
		CGPoint start = CGPointZero;
		CGFloat gap = 20;
		CGSize size = CGSizeMake(100, 40);
		
//		_favPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//		_favPhotoButton.frame = CGRectMake(start.x, start.y, size.width, size.height);
//		_favPhotoButton.showsTouchWhenHighlighted = YES;
//		_favPhotoButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//		[_favPhotoButton setTitle:NSLocalizedString(@"Favor It", nil) forState:UIControlStateNormal];
//		_favPhotoButton.backgroundColor = [UIColor randomColor];//TODO
//		[self.contentView addSubview:_favPhotoButton];
//		
//		start.x = CGRectGetMaxX(_favPhotoButton.frame) + gap;
//		
//		_favUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
//		_favUserButton.frame = CGRectMake(start.x, start.y, size.width, size.height);
//		_favUserButton.showsTouchWhenHighlighted = YES;
//		_favUserButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//		[_favUserButton setTitle:NSLocalizedString(@"Follow Her/Him", nil) forState:UIControlStateNormal];
//		_favUserButton.backgroundColor = [UIColor randomColor];//TODO
//		[self.contentView addSubview:_favUserButton];
//		
//		start = CGPointMake(CGRectGetMinX(_favPhotoButton.frame), CGRectGetMaxY(_favPhotoButton.frame) + gap);
//		
//		_shareToWeiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
//		_shareToWeiboButton.frame = CGRectMake(start.x, start.y, size.width, size.height);
//		_shareToWeiboButton.showsTouchWhenHighlighted = YES;
//		_shareToWeiboButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//		[_shareToWeiboButton setTitle:NSLocalizedString(@"Private Message", nil) forState:UIControlStateNormal];
//		_shareToWeiboButton.backgroundColor = [UIColor randomColor];
//		[_shareToWeiboButton addTarget:self action:@selector(willSendPrivateMessage) forControlEvents:UIControlEventTouchUpInside];
//		[self.contentView addSubview:_shareToWeiboButton];
//		
//		start.x = CGRectGetMaxX(_shareToWeiboButton.frame) +gap;
//		
//		_shareToWeixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
//		_shareToWeixinButton.frame = CGRectMake(start.x, start.y, size.width, size.height);
//		_shareToWeixinButton.showsTouchWhenHighlighted = YES;
//		_shareToWeixinButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//		_shareToWeixinButton.backgroundColor = [UIColor randomColor];
//		[_shareToWeixinButton setTitle:NSLocalizedString(@"Share To Weixin", nil) forState:UIControlStateNormal];
//		[self.contentView addSubview:_shareToWeixinButton];
//		
//		start = CGPointMake(CGRectGetMinX(_shareToWeiboButton.frame), CGRectGetMaxY(_shareToWeiboButton.frame) + gap);
//		
//		size = CGSizeMake(50, 30);
		
		UILabel *giftDiamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, size.width, size.height)];
		giftDiamondLabel.text = NSLocalizedString(@"送钻石", nil);
		giftDiamondLabel.textColor = [UIColor fdThemeRed];
		giftDiamondLabel.textAlignment = NSTextAlignmentCenter;
		giftDiamondLabel.adjustsFontSizeToFitWidth = YES;
		giftDiamondLabel.backgroundColor = [UIColor randomColor];//TODO
		[self.contentView addSubview:giftDiamondLabel];

		start.x = CGRectGetMaxX(giftDiamondLabel.frame) + gap;
		
		_diamondQuantityTextField = [[UITextField alloc] initWithFrame:CGRectMake(start.x, start.y, 160, 30)];
		_diamondQuantityTextField.backgroundColor = [UIColor randomColor];
		_diamondQuantityTextField.text = [@(minimumQuantityOfGift) stringValue];
		_diamondQuantityTextField.textAlignment = NSTextAlignmentCenter;
		_diamondQuantityTextField.userInteractionEnabled = NO;
		[self.contentView addSubview:_diamondQuantityTextField];
		
		start.x = CGRectGetMaxX(_diamondQuantityTextField.frame) + gap;
		
		_giftDiamondButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_giftDiamondButton.frame = CGRectMake(start.x, start.y, size.width, size.height);
		_giftDiamondButton.showsTouchWhenHighlighted = YES;
		[_giftDiamondButton setTitle:NSLocalizedString(@"赠送", nil) forState:UIControlStateNormal];
		_giftDiamondButton.backgroundColor = [UIColor randomColor];
		[self.contentView addSubview:_giftDiamondButton];
		
		start = CGPointMake(CGRectGetMinX(_diamondQuantityTextField.frame), CGRectGetMaxY(_diamondQuantityTextField.frame));
		
		_diamondStepper = [[UIStepper alloc] initWithFrame:CGRectMake(start.x, start.y, 60, 30)];
		_diamondStepper.minimumValue = minimumQuantityOfGift;
		[_diamondStepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
		[self.contentView addSubview:_diamondStepper];
		
		start = CGPointMake(CGRectGetMinX(giftDiamondLabel.frame), CGRectGetMaxY(_diamondStepper.frame) + gap);

		UILabel *giftFlowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(start.x, start.y, size.width, size.height)];
		giftFlowerLabel.text = NSLocalizedString(@"送鲜花", nil);
		giftFlowerLabel.textColor = [UIColor fdThemeRed];
		giftFlowerLabel.textAlignment = NSTextAlignmentCenter;
		giftFlowerLabel.adjustsFontSizeToFitWidth = YES;
		giftFlowerLabel.backgroundColor = [UIColor randomColor];
		[self.contentView addSubview:giftFlowerLabel];
		
		start.x = CGRectGetMaxX(giftFlowerLabel.frame) + gap;
		
		_flowerQuantityTextField = [[UITextField alloc] initWithFrame:CGRectMake(start.x, start.y, 160, 30)];
		_flowerQuantityTextField.backgroundColor = [UIColor randomColor];
		_flowerQuantityTextField.text = [@(minimumQuantityOfGift) stringValue];
		_flowerQuantityTextField.textAlignment = NSTextAlignmentCenter;
		_flowerQuantityTextField.userInteractionEnabled = NO;
		[self.contentView addSubview:_flowerQuantityTextField];
		
		start.x = CGRectGetMaxX(_flowerQuantityTextField.frame) + gap;
		
		_giftFlowerButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_giftFlowerButton.frame = CGRectMake(start.x, start.y, size.width, size.height);
		_giftFlowerButton.showsTouchWhenHighlighted = YES;
		[_giftFlowerButton setTitle:NSLocalizedString(@"赠送", nil) forState:UIControlStateNormal];
		_giftFlowerButton.backgroundColor = [UIColor randomColor];
		[self.contentView addSubview:_giftFlowerButton];
		
		start = CGPointMake(CGRectGetMinX(_flowerQuantityTextField.frame), CGRectGetMaxX(_flowerQuantityTextField.frame));
		
		_flowerStepper = [[UIStepper alloc] initWithFrame:CGRectMake(start.x, start.y, 60, 30)];
		_flowerStepper.minimumValue = minimumQuantityOfGift;
		[_flowerStepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
		[self.contentView addSubview:_flowerStepper];
    }
    return self;
}

- (void)stepperValueChanged:(UIStepper *)stepper
{
	UITextField *textField;
	if (stepper == _diamondStepper) {
		textField = _diamondQuantityTextField;

	} else if (stepper == _flowerStepper) {
		textField = _flowerQuantityTextField;
	}
	textField.text = [@(stepper.value) stringValue];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)height
{
	return 330;
}

+ (NSString *)identifier
{
	static NSString *kFDGiftsCellIdentifier = @"kFDGiftsCellIdentifier";
	return kFDGiftsCellIdentifier;
}

- (void)willSendPrivateMessage
{
	[_delegate willSendPrivateMessage];
}

@end
