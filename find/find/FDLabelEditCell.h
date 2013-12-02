//
//  FDLabelEditCell.h
//  find
//
//  Created by zhangbin on 11/14/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDLabelEditCell : UITableViewCell

@property (nonatomic, weak) id<UITextFieldDelegate, UITextViewDelegate> delegate;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *content;

- (UIView *)footerWithText:(NSString *)text;
- (void)becomeFirstResponder;
+ (CGFloat)height;
+ (CGFloat)heightOfFooter;
+ (NSInteger)numberOfRows;

@end
