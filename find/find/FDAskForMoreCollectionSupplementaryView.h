//
//  FDAskForMoreCollectionSupplementaryView.h
//  find
//
//  Created by zhangbin on 12/13/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kFDAskForMoreCollectionSupplementaryViewIdentifier = @"kFDAskForMoreCollectionSupplementaryViewIdentifier";

@protocol FDAskForMoreCollectionSupplementaryViewDelegate <NSObject>

- (void)askForMore;

@end

@interface FDAskForMoreCollectionSupplementaryView : PSUICollectionReusableView

@property (nonatomic, weak) id<FDAskForMoreCollectionSupplementaryViewDelegate> delegate;

+ (CGFloat)height;

@end
