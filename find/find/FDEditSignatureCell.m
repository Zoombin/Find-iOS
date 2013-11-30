//
//  FDEditSignatureCell.m
//  find
//
//  Created by zhangbin on 11/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDEditSignatureCell.h"

static NSInteger margin = 10;

@interface FDEditSignatureCell ()

@property (readwrite) UITextView *textView;

@end

@implementation FDEditSignatureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[self.textField removeFromSuperview];
		
		_textView = [[UITextView alloc] initWithFrame:CGRectMake(margin, 0, self.bounds.size.width - 2 * margin, [[self class] height])];
		//_textView.backgroundColor = [UIColor randomColor];
		_textView.returnKeyType = UIReturnKeyDone;
		_textView.font = [UIFont fdThemeFontOfSize:13];
		[self.contentView addSubview:_textView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContent:(NSString *)content
{
	_textView.text = content;
}

- (UIView *)footerWithText:(NSString *)text
{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
	label.numberOfLines = 0;
	label.text = text;//NSLocalizedString(@"Please input your signature!", nil);
	label.font = [UIFont fdThemeFontOfSize:13];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor randomColor];
	return label;
}

- (void)becomeFirstResponder
{
	[_textView becomeFirstResponder];
}

+ (CGFloat)height
{
	return 100;
}

+ (CGFloat)heightOfFooter
{
	return 50;
}

+ (NSInteger)numberOfRows
{
	return 1;
}

- (void)setDelegate:(id<UITextFieldDelegate, UITextViewDelegate>)delegate
{
	_textView.delegate = delegate;
}


@end
