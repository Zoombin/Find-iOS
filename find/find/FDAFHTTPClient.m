//
//  FDAFHTTPClient.m
//  find
//
//  Created by zhangbin on 9/10/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDAFHTTPClient.h"
#import "NSData+Godzippa.h"
#import "FDErrorMessage.h"

#define kFDHost @"http://121.199.14.43/"

static NSString *responseKeyStatus = @"status";
static NSString *responseKeyData = @"data";
static NSString *responseKeyMsg = @"msg";
static NSString *responseKeyAct = @"action";
static NSString *responseKeyToken = @"token";
static NSString *userDefaultKeyToken = @"fd_token";

@implementation FDAFHTTPClient

static FDAFHTTPClient *_instance;
static NSString *token;

+(FDAFHTTPClient *)shared
{
	if(!_instance){
		_instance = [[FDAFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kFDHost]];
		token = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultKeyToken];
	}
	return _instance;
}

- (void)saveToken:(NSString *)aToken
{
	NSAssert(aToken, @"token must not be nil!");
	[[NSUserDefaults standardUserDefaults] setObject:aToken forKey:userDefaultKeyToken];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"save user token: %@", aToken);
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
	if (token) {
		[request setValue:token forHTTPHeaderField:@"Cookie"];
	}
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
	if (token) {
		[request setValue:token forHTTPHeaderField:@"Cookie"];
	}
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

//TEST gzip
- (void)test
{
//			NSString *token = @"token=MzA2MXwzMDg3fDMwOTF8MzEwNnwzMDYxfDMwNTJ8MzA1M3wzMTA2fDMwNjJ8MzA2OHwzMDg3fDMwMzV8MzA2M3wzMDUzfDMwNTB8MzEwNHwzMDgzfDMwNjd8MzAzN3wzMDkwfDMwODJ8MzAzNHwzMDMyfDMwNTh8MzA2MXwzMDQ5fDMwNDV8MzA0NXwyOTg0fA==";
//	
//	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"http://121.199.14.43/a.php" parameters:nil];
//	[request setValue:token forHTTPHeaderField:@"Cookie"];
//	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject)
//										 {
//											 NSLog(@"oauthAuthorize Success: %@",    [operation.response allHeaderFields]);
//											 
//										 }
//																	  failure:^(AFHTTPRequestOperation *operation, NSError *error)
//										 {
//											 NSLog(@"oauthAuthorize Fail: %@",operation.responseString);
//										 }];
//	[self enqueueHTTPRequestOperation:operation];
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

- (void)aroundPhotosAtLocation:(CLLocation *)location limit:(NSNumber *)limit distance:(NSNumber *)distance withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *tweets, NSNumber *distance))block
{
	NSMutableDictionary *parameters = [[location parseToDictionary] mutableCopy];
	if (limit) {
		parameters[@"limit"] = limit;
	}
	
	if (distance) {
		parameters[@"distance"] = distance;
	}
	
	[self getPath:@"around/photo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		NSArray *tweets = [FDTweet createMutableWithData:data[responseKeyData]];
		NSNumber *distance = data[@"distance"];
		if (block) block(YES, [FDErrorMessage messageFromData:data[responseKeyMsg]], tweets, distance);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO, [FDErrorMessage messageNetworkError], nil, nil);
	}];
}

- (void)likeOrUnlikePhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSNumber *message, NSNumber *liked))block
{
	NSString *path = [NSString stringWithFormat:@"photo/%@/like", photoID];
	
	[self postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			//NSNumber *liked = @([data[responseKeyAct] integerValue] == DOLIKE);
			//if (block) block ([data[responseKeyStatus] boolValue], data[responseKeyMsg], liked);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO, nil, NO);
	}];
}

- (void)commentPhoto:(NSNumber *)photoID content:(NSString *)content withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSAssert(photoID, @"photoID must not be nil when comment this photo!");
	
	photoID = @(1);//TODO: test
	NSString *path = [NSString stringWithFormat:@"tweet/%d/comment", photoID.integerValue];
	
	NSDictionary *parameters;
	if (content) parameters = @{@"content" : content};
	
	[self postPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (block) block ([data[responseKeyStatus] boolValue], [FDErrorMessage messageFromData:data[responseKeyMsg]]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO, [FDErrorMessage messageNetworkError]);
	}];
}

- (void)commentsOfPhoto:(NSNumber *)photoID limit:(NSNumber *)limit published:(NSNumber *)published withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *comments, NSNumber *lastestPublishedTimestamp))block
{
	NSAssert(photoID, @"photoID must not be nil when fetch comments of this photo!");
	
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
			if (block) block (YES, [FDErrorMessage messageFromData:data[responseKeyMsg]], comments, data[@"published"]);//TODO: maybe error
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO, [FDErrorMessage messageNetworkError], nil, nil);
	}];	
}

//location could be nil, username and password must not be nil
- (void)signupAtLocation:(CLLocation *)location username:(NSString *)username password:(NSString *)password withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSAssert(username && password, @"username and password must not be nil when signup!");
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	if (location) {
		parameters = [[location parseToDictionary] mutableCopy];
	}
	
	parameters[@"username"] = username;
	parameters[@"password"] = password;
	
	[self postPath:@"signup" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if ([data[responseKeyStatus] boolValue]) {
				token = data[responseKeyToken];
				[self saveToken:token];
			}
			if (block) block ([data[responseKeyStatus] boolValue], [FDErrorMessage messageFromData:data[responseKeyMsg]]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError]);
	}];
}

//location could be nil, username and password must not be nil
- (void)signinAtLocation:(CLLocation *)location username:(NSString *)username password:(NSString *)password withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSAssert(username && password, @"username and password must not be nil when signin!");
	
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	if (location) {
		parameters = [[location parseToDictionary] mutableCopy];
	}
	
	parameters[@"username"] = username;
	parameters[@"password"] = password;
	
	[self postPath:@"signin" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if ([data[responseKeyStatus] boolValue]) {
				token = data[responseKeyToken];
				[self saveToken:token];
			}
			if (block) block ([data[responseKeyStatus] boolValue], [FDErrorMessage messageFromData:data[responseKeyMsg]]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError]);
	}];
}

- (void)profileOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSDictionary *userProfileAttributes))block
{
	NSAssert(userID, @"userID must not be nil when fetch profile!");
	
	NSString *path = [NSString stringWithFormat:@"member/%@/profile", userID];
	
	[self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (block) block (YES, [FDErrorMessage messageFromData:data[responseKeyMsg]], data);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError], nil);
	}];
}

- (void)editProfileOfUser:(NSNumber *)userID profileAttributes:(NSDictionary *)profileAttributes withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	
}

- (void)blockUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSAssert(userID, @"userID must not be nil when block it!");
	
	NSString *path = [NSString stringWithFormat:@"member/black/%@", userID];
	
	[self postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (block) block (YES, [FDErrorMessage messageFromData:data[responseKeyMsg]]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError]);
	}];
}

- (void)blockListOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSAssert(userID, @"userID must not be nil when fetch block list!");
	
	NSString *path = [NSString stringWithFormat:@"member/%@/black", userID];
	
	[self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		//id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		//[self printResponseObject:responseObject];
		
//		if ([data isKindOfClass:[NSDictionary class]]) {
//			if (block) block (YES, data);
//		}
		if (block) block (YES, nil);//TODO: should return array of FDUsers
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError]);
	}];
}

- (void)followOrUnfollowUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSAssert(userID, @"userID must not be nil when follow or unfollow user!");
	
	NSString *path = [NSString stringWithFormat:@"member/%@/follow", userID];
	
	//TODO: need return followed or unfollowed
	[self postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		;
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError]);
	}];
}

- (void)followerListOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSAssert(userID, @"userID must not be nil when fetch follower list of this user!");
	
	//TODO
	NSString *path = [NSString stringWithFormat:@"member/%@/follower", userID];
	
	[self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		;
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError]);
	}];
}

- (void)followedListOfUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSAssert(userID, @"userID must not be nil when fetch followed list of this user!");
	
	//TODO
	NSString *path = [NSString stringWithFormat:@"member/%@/followed", userID];
	
	[self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		;
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError]);
	}];
}
@end
