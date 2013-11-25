//
//  TFCameraFlashButton.m
//  Threadflip
//
//  Created by Rex Sheng on 7/25/13.
//  Copyright (c) 2013 Threadflip. All rights reserved.
//

#import "FDCameraFlashButton.h"

@implementation UIButton (CameraButtonStyle)

- (void)cameraButtonStyle
{
	self.layer.borderColor = [[UIColor colorWithWhite:0.0f alpha:0.7f] CGColor];
	self.layer.borderWidth = 1;
	self.layer.cornerRadius = 2.5f;
	self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.375];
}

@end


#define FlashMode(mode) (0x10000 << (mode + 1))

@implementation FDCameraFlashButton

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self cameraButtonStyle];
		UIImage *off = [UIImage imageNamed:@"camera-flash-off-alpha"];
		[self setImage:off forState:FlashMode(UIImagePickerControllerCameraFlashModeOff)];
		[self setImage:off forState:FlashMode(UIImagePickerControllerCameraFlashModeOff) | UIControlStateHighlighted];
		UIImage *on = [UIImage imageNamed:@"camera-flash-on-alpha"];
		[self setImage:on forState:FlashMode(UIImagePickerControllerCameraFlashModeOn)];
		[self setImage:on forState:FlashMode(UIImagePickerControllerCameraFlashModeOn) | UIControlStateHighlighted];
    }
    return self;
}

- (void)setFlashMode:(UIImagePickerControllerCameraFlashMode)flashMode
{
	if (_flashMode != flashMode) {
		_flashMode = flashMode;
		[self layoutSubviews];
	}
}

- (UIControlState)state
{
	UIControlState state = super.state;
	return state | FlashMode(_flashMode);
}

@end
