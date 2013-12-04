//
//  FDViewController.h
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBViewController.h"

@interface FDViewController : UIViewController

- (void)startCameraWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate allowsEditing:(BOOL)allowsEditing;
- (void)startPhotoLibraryWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate allowsEditing:(BOOL)allowsEditing;
- (void)choosePickerWithDelegate:(id<UIActionSheetDelegate>)delegate;

@end
