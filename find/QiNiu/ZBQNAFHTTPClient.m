//
//  ZBQNAFHTTPClient.m
//  find
//
//  Created by zhangbin on 8/28/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "ZBQNAFHTTPClient.h"
#import "ZBQNPutPolicy.h"
#import "AFHTTPRequestOperation.h"

#define kQiniuUpHost @"http://up.qiniu.com"
#define kQiniuUserAgent  @"qiniu-ios-sdk"

#define kQiniuAccessKey @"zrAvv0stUaPwrAYiaSuVgvsUSgajrFDcJoIn62Vp"
#define kQiniuSecretKey @"8onamuD2Evcu6nzoozjydlRL0oybHrRuc45fy_yA"
#define kQiniuBucketFind @"find"
#define kQiniuBucketFindServer @"findserver"

@implementation ZBQNAFHTTPClient

static NSString *_token;

+(instancetype)shared
{
	static ZBQNAFHTTPClient *instance;
    if(!instance){
        instance = [[ZBQNAFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kQiniuUpHost]];
		[instance setDefaultHeader:@"User-Agent" value:kQiniuUserAgent];
		
		ZBQNPutPolicy *policy = [[ZBQNPutPolicy alloc] init];
		policy.scope = kQiniuBucketFind;
		_token = [policy makeToken:kQiniuAccessKey secretKey:kQiniuSecretKey];
    }
    return instance;
}



- (void)uploadData:(NSData *)data name:(NSString *)name withCompletionBlock:(void (^)(BOOL success))block
{
	[self uploadData:data name:name progressBlock:nil completionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (block) block(YES);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO);
	}];
}

- (void)uploadData:(NSData *)data name:(NSString *)name progressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress completionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:nil parameters:@{@"token" : _token, @"key" : name} constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
					[formData appendPartWithFileData:data name:@"file" fileName:name mimeType:@""];
				}];
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		//NSLog(@"sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
		if (progress) progress(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
	}];

	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (success) success(operation, responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (failure) failure(operation, error);
	}];
	[self enqueueHTTPRequestOperation:operation];
}

@end
