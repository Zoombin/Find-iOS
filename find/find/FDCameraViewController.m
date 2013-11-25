//
//  FDForthViewController.m
//  find
//
//  Created by zhangbin on 8/26/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDCameraViewController.h"
#import "FDCameraFlashButton.h"

@interface FDCameraViewController () <
AFPhotoEditorControllerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (readwrite) UIImageView *imageView;
@property (readwrite) UIImagePickerController *imagePicker;

@end

@implementation FDCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *identifier = NSLocalizedString(@"Camera", nil);
		self.title = identifier;
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
			[self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"CameraHighlighted"] withFinishedUnselectedImage:[UIImage imageNamed:@"Camera"]];
		} else {
			self.tabBarItem = [[UITabBarItem alloc] initWithTitle:identifier image:[UIImage imageNamed:@"Camera"] tag:0];
		}
		
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(startCamera)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	
	[self startCamera];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	_imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	_imageView.backgroundColor = [UIColor randomColor];
	[self.view addSubview:_imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)startCamera
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		_imagePicker = [[UIImagePickerController alloc] init];
		_imagePicker.delegate = self;
		_imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		if ([UIImagePickerController isFlashAvailableForCameraDevice:_imagePicker.cameraDevice]) {
			_imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
		}
		_imagePicker.cameraOverlayView = [self overlayViewForImagePicker:_imagePicker];
		[self presentViewController:_imagePicker animated:YES completion:nil];
		return YES;
	}
	return NO;
}

- (BOOL)startPhotoLibrary
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		void(^present)() = ^() {
			UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
			imagePicker.delegate = self;
			[self presentViewController:_imagePicker = imagePicker animated:YES completion:nil];
		};
		if (self.presentedViewController) {
			[self.presentedViewController dismissViewControllerAnimated:YES completion:present];
		} else {
			present();
		}
		return YES;
	}
	return NO;
}

- (void)startAviaryEditorWithPhoto:(UIImage *)image
{
	AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:image];
	editorController.delegate = self;
	UIViewController *parent = self.presentedViewController ?: self;
	[parent presentViewController:editorController animated:YES completion:nil];
}

- (UIView *)overlayViewForImagePicker:(UIImagePickerController *)picker
{
	// LANDSCAPE TODO: This doesn't handle autorotation
	
	picker.showsCameraControls = NO;
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	CGSize size = view.bounds.size;
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	CGFloat x = roundf((size.width - self.destinationImageSize.width) / 2);
	CGFloat statusbarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	
	UIToolbar *topBar = [self cameraToolbarForPicker:picker];
	// this might be a bug in iOS6
	CGRect frame = topBar.frame;
	frame.origin.y = 15;
	frame.origin.x = 5;
	frame.size.width = size.width - frame.origin.x * 2;
	if ([UIDevice currentDevice].systemVersion.floatValue < 7.f) {
		frame.origin.y += statusbarHeight;
	}
	topBar.frame = frame;
	[view addSubview:topBar];
	
//	UIEdgeInsets bottomCenterInsets;
	
	CGFloat bottomBarHeight = 58;
	UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, bottomBarHeight)];
	bottomBar.backgroundColor = [UIColor fdThemeRed];
	bottomBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	
	//if (bottomCenterInsets) *bottomCenterInsets = UIEdgeInsetsMake(0, 45, bottomBarHeight / 2, width - 45);
	//return bottomBar;
	//UIView *bottomBar = [UIView bottomBarWidth:size.width style:TFBottomBarStyleLarge edgeInsets:&bottomCenterInsets];
	bottomBar.frame = CGRectOffset(bottomBar.frame, 0, size.height - bottomBar.bounds.size.height);

	CAShapeLayer *layer = [CAShapeLayer layer];
	layer.frame = CGRectMake(0, 0, size.width, size.height - bottomBar.frame.size.height);
	UIBezierPath *path = [UIBezierPath bezierPathWithRect:layer.bounds];
	CGRect scrollFrame = CGRectMake(x, x + CGRectGetMaxY(topBar.frame), self.destinationImageSize.width, self.destinationImageSize.height);
	[path appendPath:[UIBezierPath bezierPathWithRect:scrollFrame]];
	layer.path = path.CGPath;
	layer.fillRule = kCAFillRuleEvenOdd;
	layer.fillColor = [[UIColor colorWithWhite:0.0f alpha:0.0] CGColor];//[[RSMoveAndScaleView appearance] maskForegroundColor].CGColor;
	[view.layer addSublayer:layer];

	// translate is not working, so enlarge it for extra top.
	// center  = size.width / 2 / .75
	// center' = size.height - bottomBar.bounds.size.height - statusbarHeight - center
	// scale = center' / center;
	CGSize imageFrameSize = CGSizeMake(size.width, size.width / .75f);
	CGFloat halfImageHeight = imageFrameSize.height / 2;
	CGFloat scale = MAX((size.height - statusbarHeight - bottomBar.bounds.size.height) / halfImageHeight - 1, 1);
	// (iphone5 ios7) scale = 1.240625

	CGFloat extraX = imageFrameSize.width * (scale - 1) / 2;
	CGFloat extraY = imageFrameSize.height * (scale - 1) / 2;

	CGFloat left = extraX + scrollFrame.origin.x;
	CGFloat top = scrollFrame.origin.y; // 70.25
	CGFloat bottom = (scale + 1) * halfImageHeight - scrollFrame.size.height - top; //122.75
	//_croppingAreaInsets = UIEdgeInsetsMake(extraY + top, left, bottom, left);
	picker.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
	[view addSubview:bottomBar];
	
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	cancelButton.frame = CGRectMake(60, 20, 44, 44);
//	cancelButton.center = CGPointMake(60, 20);
	cancelButton.showsTouchWhenHighlighted = YES;
	cancelButton.titleLabel.font = [UIFont fdBoldThemeFontOfSize:11];
	[cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
	cancelButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[cancelButton addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
	[bottomBar addSubview:cancelButton];

	UIButton *takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *buttonImageOn = [UIImage imageNamed:@"camera-button-on"];
	UIImage *buttonImage = [UIImage imageNamed:@"camera-button"];
	takeButton.bounds = CGRectMake(0, 0, buttonImage.size.width * 1.6f, buttonImage.size.height * 1.6f);
	takeButton.center = CGPointMake(size.width / 2, 20);
	[takeButton setImage:buttonImage forState:UIControlStateNormal];
	[takeButton setImage:buttonImageOn forState:UIControlStateHighlighted];
	takeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
	[takeButton addTarget:picker action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
	[bottomBar addSubview:takeButton];

	UIButton *openPhotosLibrary = [UIButton buttonWithType:UIButtonTypeCustom];
	openPhotosLibrary.bounds = CGRectMake(0, 0, 44, 44);
	openPhotosLibrary.center = CGPointMake(size.width - 60, 20);
	openPhotosLibrary.showsTouchWhenHighlighted = YES;
	openPhotosLibrary.titleLabel.font = [UIFont fdBoldThemeFontOfSize:11];
	[openPhotosLibrary setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[openPhotosLibrary setImage:[UIImage imageNamed:@"photolibrary-camera"] forState:UIControlStateNormal];
	openPhotosLibrary.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[openPhotosLibrary addTarget:self action:@selector(startPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
	[bottomBar addSubview:openPhotosLibrary];
	
	return view;
}

- (CGSize)destinationImageSize
{
	CGFloat width = roundf(MIN(self.view.bounds.size.width, self.view.bounds.size.height)  * (285.f / 320.f));
	return CGSizeMake(width, width);
}

- (UIToolbar *)cameraToolbarForPicker:(UIImagePickerController *)picker
{
	CGRect buttonFrame = CGRectMake(0, 0, 57, 33);
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
	//toolbar.tintColor = GetAppDelegate().window.tintColor;
	[toolbar setBackgroundImage:[UIImage imageFromColor:[UIColor clearColor]] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
	FDCameraFlashButton *flashToggleButton = [[FDCameraFlashButton alloc] initWithFrame:buttonFrame];
	[flashToggleButton addTarget:self action:@selector(changeFlashMode:) forControlEvents:UIControlEventTouchUpInside];
	if ([UIImagePickerController isFlashAvailableForCameraDevice:picker.cameraDevice]) {
		flashToggleButton.flashMode = picker.cameraFlashMode;
	} else {
		flashToggleButton.flashMode = 0;
	}
	NSMutableArray *items = [NSMutableArray arrayWithCapacity:3];
	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:flashToggleButton];
	[items addObject:leftItem];
	[items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
	
	flashToggleButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
	if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
		UIButton *deviceToggleButton = [[UIButton alloc] initWithFrame:buttonFrame];
		[deviceToggleButton setImage:[UIImage imageNamed:@"camera-rotate-alpha"] forState:UIControlStateNormal];
		[deviceToggleButton addTarget:self action:@selector(changeCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
		deviceToggleButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
		[deviceToggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[deviceToggleButton cameraButtonStyle];
		UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:deviceToggleButton];
		[items addObject:rightItem];
	}
	[toolbar setItems:items];
	return toolbar;
}

#pragma makr - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{
		//_imageView.backgroundColor = [UIColor randomColor];
	}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissViewControllerAnimated:YES completion:^{
		[self startAviaryEditorWithPhoto:info[UIImagePickerControllerOriginalImage]];
	}];
}

#pragma mark - AFPhotoEditorControllerDelegate

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
	[self dismissViewControllerAnimated:YES completion:^{
		_imageView.image = image;
	}];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Camera Actions

- (void)cancelCamera
{
	[self.imagePicker.delegate imagePickerControllerDidCancel:self.imagePicker];
}

- (void)changeFlashMode:(FDCameraFlashButton *)button
{
	if ([UIImagePickerController isFlashAvailableForCameraDevice:self.imagePicker.cameraDevice]) {
		self.imagePicker.cameraFlashMode = button.flashMode = -self.imagePicker.cameraFlashMode;
	}
}

- (void)changeCameraDevice:(UIButton *)button
{
	if (self.imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
		self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
	} else {
		self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
	}
	if ([UIImagePickerController isFlashAvailableForCameraDevice:self.imagePicker.cameraDevice]) {
		self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
	}
}

@end
