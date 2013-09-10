//
//  FDTestPhotoUploadViewController.m
//  find
//
//  Created by zhangbin on 8/28/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDTestPhotoUploadViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface FDTestPhotoUploadViewController () <CLLocationManagerDelegate>

@end

@implementation FDTestPhotoUploadViewController
{
	CLLocationManager *locationManager;
	CLLocation *fakeLocation;
	CLLocation *trueLocation;
	
	UITextField *fakeLatField;
	UITextField *fakeLonField;
	
	UILabel *trueLocationLabel;
	UILabel *distanceLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Upload";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	//locationManager = [[CLLocationManager alloc] init];
	//locationManager.delegate = self;
    //locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	//[locationManager startUpdatingLocation];
	
	CLLocationDegrees baseLat = 31.298026;
	CLLocationDegrees baseLon = 120.666564;
	trueLocation = [[CLLocation alloc] initWithLatitude:baseLat longitude:baseLon];
	fakeLocation = [[CLLocation alloc] initWithLatitude:baseLat longitude:baseLon];
	
	CGSize fullSize = self.view.bounds.size;
	
	CGFloat margin = 10;
	CGFloat startY = 64;
	CGFloat height = 30;
	
	trueLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, startY, fullSize.width, height)];
	trueLocationLabel.text = @"Base Location";
	trueLocationLabel.adjustsFontSizeToFitWidth = YES;
	[self.view addSubview:trueLocationLabel];
	
	startY = CGRectGetMaxY(trueLocationLabel.frame);
	
	UILabel *fakeLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, startY, fullSize.width, height)];
	fakeLocationLabel.text = @"Fake Location:";
	[self.view addSubview:fakeLocationLabel];
	
	startY = CGRectGetMaxY(fakeLocationLabel.frame);
	
	UILabel *fakeLatLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, startY, 40, height)];
	fakeLatLabel.text = @"lat:";
	[self.view addSubview:fakeLatLabel];
	
	fakeLatField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fakeLatLabel.frame), startY, 200, height)];
	fakeLatField.backgroundColor = [UIColor grayColor];
	fakeLatField.placeholder = @"lat";
	[self.view addSubview:fakeLatField];
	
	startY = CGRectGetMaxY(fakeLatLabel.frame) + margin;
	
	UILabel *fakeLonLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, startY, 40, height)];
	fakeLonLabel.text = @"log:";
	[self.view addSubview:fakeLonLabel];
	
	fakeLonField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fakeLonLabel.frame), startY, 200, height)];
	fakeLonField.backgroundColor = [UIColor grayColor];
	fakeLonField.placeholder = @"log";
	[self.view addSubview:fakeLonField];
	
	startY = CGRectGetMaxY(fakeLonField.frame) + margin;
	
	CGFloat locationButtonWidth = fullSize.width - 2 * margin;
	
	UIButton *sameWithTrueLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[sameWithTrueLocation setTitle:@"sameWithBaseLocation" forState:UIControlStateNormal];
	sameWithTrueLocation.frame = CGRectMake(margin, startY, locationButtonWidth, height);
	sameWithTrueLocation.tag = 0;
	[sameWithTrueLocation setBackgroundColor:[UIColor yellowColor]];
	[sameWithTrueLocation addTarget:self action:@selector(randomLocation:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:sameWithTrueLocation];
	
	startY = CGRectGetMaxY(sameWithTrueLocation.frame) + margin;
	
	UIButton *random100meters = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[random100meters setTitle:@"near 100 meters" forState:UIControlStateNormal];
	random100meters.frame = CGRectMake(margin, startY, locationButtonWidth, height);
	random100meters.tag = 100;
	[random100meters setBackgroundColor:[UIColor greenColor]];
	[random100meters addTarget:self action:@selector(randomLocation:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:random100meters];
	
	startY = CGRectGetMaxY(random100meters.frame) + margin;
	
	UIButton *random1000meters = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[random1000meters setTitle:@"near 1000 meters" forState:UIControlStateNormal];
	random1000meters.frame = CGRectMake(margin, startY, locationButtonWidth, height);
	random1000meters.tag = 1000;
	[random1000meters setBackgroundColor:[UIColor blueColor]];
	[random1000meters addTarget:self action:@selector(randomLocation:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:random1000meters];
	
	startY = CGRectGetMaxY(random1000meters.frame) + margin;
	
	UIButton *random10000meters = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[random10000meters setTitle:@"near 10000 meters" forState:UIControlStateNormal];
	random10000meters.frame = CGRectMake(margin, startY, locationButtonWidth, height);
	random10000meters.tag = 10000;
	[random10000meters setBackgroundColor:[UIColor redColor]];
	[random10000meters addTarget:self action:@selector(randomLocation:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:random10000meters];
	
	startY = CGRectGetMaxY(random10000meters.frame);
	
	distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, startY, fullSize.width - 2 * margin, height)];
	distanceLabel.adjustsFontSizeToFitWidth = YES;
	[self.view addSubview:distanceLabel];
	
	startY = CGRectGetMaxY(distanceLabel.frame) + margin;
	
	UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[uploadButton setTitle:@"upload" forState:UIControlStateNormal];
	uploadButton.frame = CGRectMake(margin, startY, 100, height);
	[uploadButton setBackgroundColor:[UIColor blackColor]];
	[uploadButton addTarget:self action:@selector(testAPI) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:uploadButton];
	
	[self updateTrueLocation:trueLocation];
	[self updateFakeLocation:fakeLocation];
}

- (UIImage *)captureView:(UIView *)view {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
	
    UIGraphicsBeginImageContext(screenRect.size);
	
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
	
    [view.layer renderInContext:ctx];
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return newImage;
}

- (void)randomLocation:(UIButton *)sender
{
	if (!trueLocation) {
		NSLog(@"cant get current location");
		return;
	}
	CGFloat distanceDesire = (CGFloat)sender.tag;
	
	CGFloat factor = 0;
	
	CGPoint point = CGPointZero;
	if (distanceDesire == 0) {
		point.x = 0;
		point.y = 0;
		factor = 0;
	} else if (distanceDesire == 100) {
		point.x = 0;
		point.y = 100;
		factor = 0.0001;
	} else if (distanceDesire == 1000) {
		point.x = 100;
		point.y = 900;
		factor = 0.001;
	} else if (distanceDesire == 10000) {
		point.x = 1000;
		point.y = 9000;
		factor = 0.01;
	}
	
	CLLocationDegrees lat = trueLocation.coordinate.latitude;
	CLLocationDegrees lon = trueLocation.coordinate.longitude;
	
	NSInteger random = arc4random() % 20 - 10;
	if (random == 0) {
		random = 1;
	}
	lat += factor * random;
	lon += factor * random;
	CLLocation *locationTry = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
	
	[self updateFakeLocation:locationTry];
}

- (void)updateFakeLocation:(CLLocation *)location
{
	fakeLocation = location;
	fakeLatField.text = [@(fakeLocation.coordinate.latitude) stringValue];
	fakeLonField.text = [@(fakeLocation.coordinate.longitude) stringValue];
	
	distanceLabel.text = [NSString stringWithFormat:@"distance between base and fake is: %f", [fakeLocation distanceFromLocation:trueLocation]];
	
	self.view.backgroundColor = [UIColor randomColor];
}

- (void)updateTrueLocation:(CLLocation *)location
{
	trueLocation = location;
	trueLocationLabel.text = [NSString stringWithFormat:@"Base Location: %@", [trueLocation coordinateString]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	if (locations.count) {
		trueLocation = [locations lastObject];
		[self updateTrueLocation:trueLocation];
		[self updateFakeLocation:trueLocation];
		[manager stopUpdatingLocation];
	}
}

#pragma mark - Test

- (void)testAPI
{
	//[self testAroundPhotos];
	NSArray *array = @[[@(1) readableDistance],[@(100) readableDistance], [@(123) readableDistance], [@(1237115) readableDistance]];
	NSLog(@"distance: %@", [@(12) readableDistance]);
}

- (void)testUpload
{
	UIImage *screenshot = [self captureView:self.view];
	NSData *imageData = UIImageJPEGRepresentation(screenshot, 1);
	
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
	NSDate *now = [NSDate date];
	
	NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:now]];
	[self displayHUD:@"uploading..."];
	[[ZBQNAFHTTPClient shared] uploadData:imageData name:fileName completionBlock:^(void) {
		[self hideHUD:YES];
	}];
}

- (void)testTweet
{
	[self displayHUD:@"Posting..."];
	[[FDAFHTTPClient shared] tweetPhotos:nil atLocation:fakeLocation address:@"ooxxxx" withCompletionBlock:^(BOOL success, NSString *message) {
		[self hideHUD:YES];
		if (!success) {
			[self displayHUDError:nil message:message];
		}
	}];
}

- (void)testAroundPhotos
{
	[self displayHUD:@"Fetching around photos"];
	[[FDAFHTTPClient shared] aroundPhotosAtLocation:fakeLocation withCompletionBlock:^(void) {
		[self hideHUD:YES];
	}];
}

@end
