//
//  FDShareAndGiftsCell.h
//  find
//
//  Created by zhangbin on 11/7/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDShareAndGiftsCellDelegate <NSObject>

- (void)willGifts;
- (void)willSendPrivateMessage;

@end

@interface FDShareAndGiftsCell : UITableViewCell

@property (nonatomic, weak) id<FDShareAndGiftsCellDelegate> delegate;

+ (CGFloat)height;
+ (NSString *)identifier;

@end
