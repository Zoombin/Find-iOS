//
//  FDEditCell.h
//  find
//
//  Created by zhangbin on 12/2/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDEditCell : UITableViewCell

@property (nonatomic, weak) id<UITextFieldDelegate, UITextViewDelegate> delegate;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;

- (NSString *)identifier;
- (UIView *)footerWithText:(NSString *)text;
- (void)becomeFirstResponder;
+ (CGFloat)height;
+ (CGFloat)heightOfFooter;
+ (NSInteger)numberOfRows;

@end
