//
//  AFSDKDemoViewController.h
//  AviaryDemo-iOS
//
//  Created by Michael Vitrano on 1/23/13.
//  Copyright (c) 2013 Aviary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFSDKDemoViewController : UIViewController

@property (strong, nonatomic) UIButton *editSampleButton;
@property (strong, nonatomic) UIButton *choosePhotoButton;
@property (strong, nonatomic) UIImageView *backgroundImageView;

- (void)editSample:(id)sender;
- (void)choosePhoto:(id)sender;

@end
