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
	
	UILabel *trueLocationLabel;
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
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager startUpdatingLocation];
	
	CLLocationDegrees fakeLat = 31.298026;
	CLLocationDegrees fakeLon = 120.666564;
	fakeLocation = [[CLLocation alloc] initWithLatitude:fakeLat longitude:fakeLon];
	
	CGSize fullSize = self.view.bounds.size;
	
	CGFloat margin = 10;
	CGFloat startY = 0;
	CGFloat height = 30;
	
	trueLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, 0, fullSize.width, height)];
	trueLocationLabel.text = @"True Location";
	trueLocationLabel.adjustsFontSizeToFitWidth = YES;
	[self.view addSubview:trueLocationLabel];
	
	startY = CGRectGetMaxY(trueLocationLabel.frame) + margin;
	
	UILabel *fakeLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, startY, fullSize.width, height)];
	fakeLocationLabel.text = @"Fake Location:";
	[self.view addSubview:fakeLocationLabel];
	
	startY = CGRectGetMaxY(fakeLocationLabel.frame);
	
	UILabel *latLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, startY, 40, height)];
	latLabel.text = @"lat:";
	[self.view addSubview:latLabel];
	
	UITextField *latField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(latLabel.frame), startY, 200, height)];
	latField.backgroundColor = [UIColor grayColor];
	latField.placeholder = @"lat";
	latField.text = [@(fakeLocation.coordinate.latitude) stringValue];
	[self.view addSubview:latField];
	
	startY = CGRectGetMaxY(latLabel.frame) + margin;
	
	UILabel *lonLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, startY, 40, height)];
	lonLabel.text = @"log:";
	[self.view addSubview:lonLabel];
	
	UITextField *lonField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lonLabel.frame), startY, 200, height)];
	lonField.backgroundColor = [UIColor grayColor];
	lonField.placeholder = @"log";
	lonField.text = [@(fakeLocation.coordinate.longitude) stringValue];
	[self.view addSubview:lonField];
	
	startY = CGRectGetMaxY(lonField.frame) + margin;
	
	UIButton *sameWithTrueLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[sameWithTrueLocation setTitle:@"sameWithTrueLocation" forState:UIControlStateNormal];
	sameWithTrueLocation.frame = CGRectMake(margin, startY, fullSize.width - 2 * margin, height);
	sameWithTrueLocation.tag = 0;
	[sameWithTrueLocation addTarget:self action:@selector(randomLocation:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:sameWithTrueLocation];
	
	startY = CGRectGetMaxY(sameWithTrueLocation.frame) + margin;
	
	UIButton *randomIn500meters = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[randomIn500meters setTitle:@"randomIn500meters" forState:UIControlStateNormal];
	randomIn500meters.frame = CGRectMake(margin, startY, fullSize.width - 2 * margin, height);
	randomIn500meters.tag = 500;
	[randomIn500meters addTarget:self action:@selector(randomLocation:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:randomIn500meters];
	
	startY = CGRectGetMaxY(randomIn500meters.frame) + margin;
	
	UIButton *randomIn1000meters = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[randomIn1000meters setTitle:@"randomIn1000meters" forState:UIControlStateNormal];
	randomIn1000meters.frame = CGRectMake(margin, startY, fullSize.width - 2 * margin, height);
	randomIn1000meters.tag = 1000;
	[randomIn1000meters addTarget:self action:@selector(randomLocation:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:randomIn1000meters];
	
	startY = CGRectGetMaxY(randomIn1000meters.frame) + margin;
	
	UIButton *randomIn10000meters = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[randomIn10000meters setTitle:@"randomIn10000meters" forState:UIControlStateNormal];
	randomIn10000meters.frame = CGRectMake(margin, startY, fullSize.width - 2 * margin, height);
	randomIn10000meters.tag = 10000;
	[randomIn10000meters addTarget:self action:@selector(randomLocation:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:randomIn10000meters];
}

- (void)randomLocation:(UIButton *)sender
{
	//CGFloat distance = (CGFloat)sender.tag;
		
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
		trueLocationLabel.text = [trueLocation localizedCoordinateString];
	}
}

@end
