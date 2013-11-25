//
//  TFCameraFlashButton.h
//  Threadflip
//
//  Created by Rex Sheng on 7/25/13.
//  Copyright (c) 2013 Threadflip. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CameraButtonStyle)
- (void)cameraButtonStyle;
@end

@interface FDCameraFlashButton : UIButton

@property (nonatomic) UIImagePickerControllerCameraFlashMode flashMode;

@end
