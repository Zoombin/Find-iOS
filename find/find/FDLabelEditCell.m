//
//  FDLabelEditCell.m
//  find
//
//  Created by zhangbin on 11/14/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDLabelEditCell.h"

@interface FDLabelEditCell ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation FDLabelEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(self.indentationWidth, 0, self.bounds.size.width - 2 * self.indentationWidth, [[self class] height])];
		//_textField.backgroundColor = [UIColor randomColor];
		_textField.returnKeyType = UIReturnKeyDone;
		[self.contentView addSubview:_textField];
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
	_textField.text = content;
}

- (void)becomeFirstResponder
{
	[_textField becomeFirstResponder];
}

+ (CGFloat)height
{
	return 40;
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
	_textField.delegate = delegate;
}

@end
