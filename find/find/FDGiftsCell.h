//
//  FDGiftsCell.h
//  find
//
//  Created by zhangbin on 11/7/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDGiftsCellDelegate <NSObject>

- (void)willGifts;
- (void)willSendPrivateMessage;

@end

@interface FDGiftsCell : UITableViewCell

@property (nonatomic, weak) id<FDGiftsCellDelegate> delegate;

+ (CGFloat)height;
+ (NSString *)identifier;

@end
