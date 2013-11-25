//
//  FDEditCell.h
//  find
//
//  Created by zhangbin on 11/14/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDEditCell : UITableViewCell

@property (nonatomic, weak) id<UITextFieldDelegate, UITextViewDelegate> delegate;
@property (nonatomic, strong) NSString *content;

- (UIView *)footer;
+ (CGFloat)height;
+ (CGFloat)heightOfFooter;
+ (NSInteger)numberOfRows;

@end
