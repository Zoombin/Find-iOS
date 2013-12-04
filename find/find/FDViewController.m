//
//  FDViewController.m
//  find
//
//  Created by zhangbin on 9/5/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDViewController.h"

@interface FDViewController ()

@property (readwrite) UIImagePickerController *imagePicker;

@end

@implementation FDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startCameraWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate allowsEditing:(BOOL)allowsEditing
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		if (!_imagePicker) {
			_imagePicker = [[UIImagePickerController alloc] init];
		}
		_imagePicker.delegate = delegate;
		_imagePicker.allowsEditing = allowsEditing;
		_imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentViewController:_imagePicker animated:YES completion:nil];
	}
}

- (void)startPhotoLibraryWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate allowsEditing:(BOOL)allowsEditing
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		if (!_imagePicker) {
			_imagePicker = [[UIImagePickerController alloc] init];
		}
		_imagePicker.delegate = delegate;
		_imagePicker.allowsEditing = allowsEditing;
		_imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//虽然是default但是需要设置
		[self presentViewController:_imagePicker animated:YES completion:nil];
	}
}

//- (void)startAviaryEditorWithPhoto:(UIImage *)image
//{
//	AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:image];
//	editorController.delegate = self;
//	UIViewController *parent = self.presentedViewController ?: self;
//	[parent presentViewController:editorController animated:YES completion:nil];
//}

- (void)choosePickerWithDelegate:(id<UIActionSheetDelegate>)delegate
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:delegate cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"Snap a New", @"Pick From Photo Library", nil];
	[actionSheet showInView:self.view];
}

@end
