//
//  FDWebViewController.m
//  find
//
//  Created by zhangbin on 12/3/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDWebViewController.h"

@interface FDWebViewController ()

@property (readwrite) UIWebView	*webView;

@end

@implementation FDWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[self setLeftBarButtonItemAsBackButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_path]]];
	[self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
