//
//  FDAFHTTPClient.m
//  find
//
//  Created by zhangbin on 9/10/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAFHTTPClient.h"

#define kFDHost @"http://121.199.14.43/"

@implementation FDAFHTTPClient

static FDAFHTTPClient *_instance;


+(FDAFHTTPClient *)shared
{
	if(!_instance){
		_instance = [[FDAFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kFDHost]];
	}
	return _instance;
}

- (void)printResponseObject:(id)responseObject
{
	id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
	NSString *type;
	if ([data isKindOfClass:[NSDictionary class]]) {
		type = @"dictionary";
	} else if ([data isKindOfClass:[NSArray class]]) {
		type = @"array";
	}
	NSLog(@"%@-data: %@", type, data);
}

- (void)tweetPhotos:(NSArray *)photos atLocation:(CLLocation *)location address:(NSString *)address withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSMutableDictionary *parameters = [[location parseToDictionary] mutableCopy];
	if (address) {
		parameters[@"address"] = address;
	}
	if (photos) {
		parameters[@"pics"] = photos;
	}
	
	[self postPath:@"tweet" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (block) block ([data[@"status"] boolValue], [data[@"msg"] stringValue]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, error.description);
	}];
}

- (void)aroundPhotosAtLocation:(CLLocation *)location withCompletionBlock:(dispatch_block_t)block
{
	NSMutableDictionary *parameters = [[location parseToDictionary] mutableCopy];
	[self getPath:@"around/photo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[self printResponseObject:responseObject];
		if (block) block();
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block();
	}];
}

@end
