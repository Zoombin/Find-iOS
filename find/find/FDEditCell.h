//
//  FDEditCell.h
//  find
//
//  Created by zhangbin on 11/14/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDEditCell : UITableViewCell

- (void)setDelegate:(id<UITextFieldDelegate, UITextViewDelegate>)delegate;

- (UIView *)footer;
+ (CGFloat)height;
+ (CGFloat)heightOfFooter;
+ (NSInteger)numberOfRows;

@end
