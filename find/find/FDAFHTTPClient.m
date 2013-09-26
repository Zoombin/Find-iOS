//
//  FDAFHTTPClient.m
//  find
//
//  Created by zhangbin on 9/10/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAFHTTPClient.h"
#import "NSData+Godzippa.h"

#define kFDHost @"http://121.199.14.43/"

static NSString *responseKeyStatus = @"status";
static NSString *responseKeyData = @"data";
static NSString *responseKeyMsg = @"msg";


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
	} else if ([data isKindOfClass:[NSString class]]) {
		type = @"string";
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
			if (block) block ([data[responseKeyStatus] boolValue], data[responseKeyMsg]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, error.description);
	}];
}

- (void)aroundPhotosAtLocation:(CLLocation *)location limit:(NSNumber *)limit distance:(NSNumber *)distance withCompletionBlock:(void (^)(BOOL success, NSArray *tweets, NSNumber *distance))block
{
	NSMutableDictionary *parameters = [[location parseToDictionary] mutableCopy];
	if (limit) {
		parameters[@"limit"] = limit;
	}
	
	if (distance) {
		parameters[@"distance"] = distance;
	}
	
	[self getPath:@"around/photo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		//[self printResponseObject:responseObject];
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		NSArray *tweets = [FDTweet createMutableWithData:data[responseKeyData]];
		NSNumber *distance = data[@"distance"];
		if (block) block(YES, tweets, distance);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO, nil, nil);
	}];
}

- (void)likeOrUnlikePhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSNumber *message))block
{
	NSString *path = [NSString stringWithFormat:@"photo/%@/like", photoID];
	
	[self postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (block) block ([data[responseKeyStatus] boolValue], data[responseKeyMsg]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO, nil);
	}];
}

- (void)commentPhoto:(NSNumber *)photoID content:(NSString *)content withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSString *path = [NSString stringWithFormat:@"tweet/%d/comment", photoID.integerValue];
	
	NSDictionary *parameters;
	if (content) parameters = @{@"content" : content};
	
	[self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (block) block ([data[responseKeyStatus] boolValue], data[responseKeyData]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO, error.description);
	}];
}

- (void)commentsOfPhoto:(NSNumber *)photoID limit:(NSNumber *)limit published:(NSNumber *)published withCompletionBlock:(void (^)(BOOL success, NSArray *comments, NSNumber *lastestPublishedTimestamp))block
{
	photoID = @(1);//TODO: test
	NSMutableString *path = [NSMutableString stringWithFormat:@"tweet/%@/comment?", photoID];
	
	if (limit) {
		[path appendString:[NSString stringWithFormat:@"limit=%@", limit]];
		[path appendString:@"&"];
	}
	
	if (published) {
		[path appendString:[NSString stringWithFormat:@"published=%@", published]];
		[path appendString:@"&"];
	}
	
	[self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			NSArray *comments = [FDComment createMutableWithData:data[responseKeyData]];
			if (block) block (YES, comments, data[@"published"]);//TODO: maybe error
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO, nil, nil);
	}];	
}

- (void)test
{
	NSString *testHost = @"http://f.hualongxiang.com/";
	
	AFHTTPClient *client = [[FDAFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:testHost]];
	[client getPath:@"mobile/getinfo/1390626" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//		NSData *data = [responseObject dataByGZipDecompressingDataWithError:nil];
//		NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//		NSLog(@"dic: %@", dic);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"no");
	}];
}


@end
