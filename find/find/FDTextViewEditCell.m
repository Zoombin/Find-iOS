//
//  FDEditSignatureCell.m
//  find
//
//  Created by zhangbin on 11/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDTextViewEditCell.h"

@interface FDTextViewEditCell ()

@property (readwrite) UITextView *textView;

@end

@implementation FDTextViewEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		_textView = [[UITextView alloc] initWithFrame:CGRectMake(self.indentationWidth, 0, self.bounds.size.width - 2 * self.indentationWidth, [[self class] height])];
		_textView.enablesReturnKeyAutomatically = YES;
		//_textView.backgroundColor = [UIColor lightGrayColor];
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

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
	_textView.keyboardType = keyboardType;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
	_textView.returnKeyType = returnKeyType;
}

- (NSString *)content
{
	return _textView.text;
}

@end
