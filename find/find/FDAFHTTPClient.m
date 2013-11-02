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
#import "AFNetworkActivityIndicatorManager.h"

#define kFDHost @"http://121.199.14.43/"

static NSString *responseKeyStatus = @"status";
static NSString *responseKeyData = @"data";
static NSString *responseKeyMsg = @"msg";
static NSString *responseKeyAct = @"action";
static NSString *responseKeyLikes = @"likes";
static NSString *responseKeyToken = @"token";
static NSString *userDefaultKeyToken = @"fd_token";
static NSString *userDefaultKeyAccount = @"fd_account";
static NSString *userDefaultKeyUserID = @"fd_user_id";

@implementation FDAFHTTPClient

static FDAFHTTPClient *_instance;
static NSString *token;

+(instancetype)shared
{
	if(!_instance){
		[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
		_instance = [[FDAFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kFDHost]];
		token = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultKeyToken];
		NSLog(@"load token: %@", token);
	}
	return _instance;
}

- (void)saveToken:(NSString *)aToken
{
	if ([token isEqualToString:aToken]) return;
	token = aToken;
	NSAssert(token, @"token must not be nil!");
	[[NSUserDefaults standardUserDefaults] setObject:aToken forKey:userDefaultKeyToken];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"save user token: %@", token);
}

- (void)saveAccount:(NSString *)aAccount
{
	NSAssert(aAccount, @"token must not be nil!");
	[[NSUserDefaults standardUserDefaults] setObject:aAccount forKey:userDefaultKeyAccount];
	[[NSUserDefaults standardUserDefaults] synchronize];
	NSLog(@"save user account: %@", aAccount);
}

- (NSString *)cookieValue
{
	if (token) {
		return [NSString stringWithFormat:@"token=%@", token];
	}
	return nil;
}

- (NSString *)account
{
	NSString *account = nil;
	account = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultKeyAccount];
	if (!account) {
		account = @"root";//TODO: 这样对吗？还是只是为了test
	}
	return account;
}

- (NSString *)userID
{
	NSString *userID = nil;
	userID = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultKeyUserID];
	return userID;
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

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
	if ([self cookieValue]) {
		[request setValue:[self cookieValue] forHTTPHeaderField:@"Cookie"];
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
	if ([self cookieValue]) {
		[request setValue:[self cookieValue] forHTTPHeaderField:@"Cookie"];
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

- (void)infoOfPhoto:(NSString *)photoInfoUrlString completionBlockWithSuccess:(void (^)(NSDictionary *infoAttributes))success
{
	[self getPath:photoInfoUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (success) success(data);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
	}];
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
			if (block) block ([data[responseKeyStatus] boolValue], [FDErrorMessage messageFromData:data[responseKeyMsg]]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError]);
	}];
}

- (void)aroundPhotosAtLocation:(CLLocation *)location limit:(NSNumber *)limit distance:(NSNumber *)distance withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *tweetsData, NSNumber *distance))block
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
		if ([data isKindOfClass:[NSDictionary class]]) {
			NSNumber *distance = data[@"distance"];
			//TODO: YES everytime?
			if (block) block (YES, [FDErrorMessage messageFromData:data[responseKeyMsg]], data[responseKeyData], distance);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO, [FDErrorMessage messageNetworkError], nil, nil);
	}];
}

- (void)likeOrUnlikePhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSNumber *liked, NSNumber *likes))block;
{
	NSString *path = [NSString stringWithFormat:@"photo/%@/like", photoID];
	
	[self postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			BOOL success = [data[responseKeyStatus] boolValue];
			NSNumber *liked = @([data[responseKeyAct] integerValue] == DOLIKE);
			NSString *message = [FDErrorMessage messageFromData:data[responseKeyMsg]];
			if (block) block (success, message, liked, data[responseKeyLikes]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block(NO, [FDErrorMessage messageNetworkError], nil, nil);
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

- (void)commentsOfPhoto:(NSNumber *)photoID limit:(NSNumber *)limit published:(NSNumber *)published withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *commentsData, NSNumber *lastestPublishedTimestamp))block
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
			//TODO: YES everytime?
			if (block) block (YES, [FDErrorMessage messageFromData:data[responseKeyMsg]], data[responseKeyData], data[@"published"]);
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
				[self saveToken:data[responseKeyToken]];
				[self saveAccount:username];
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
				[self saveToken:data[responseKeyToken]];
				[self saveAccount:username];
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
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (block) block (YES, [FDErrorMessage messageFromData:data[responseKeyMsg]]);//TODO: should return array of FDUsers
		}
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

- (void)themeListWithCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *themesData))block
{
	[self getPath:@"event" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (block) block ([data[responseKeyStatus] boolValue], [FDErrorMessage messageFromData:data[responseKeyMsg]], data[responseKeyData]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError], nil);
	}];
}

- (void)themeContent:(NSNumber *)themeID withCompletionBlock:(void (^)(BOOL success, NSString *message, NSArray *themeContentData, NSDictionary *themeAttributes))block
{
	NSString *path = [NSString stringWithFormat:@"event/%@", themeID];
	[self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (block) block ([data[responseKeyStatus] boolValue], [FDErrorMessage messageFromData:data[responseKeyMsg]], data[responseKeyData], data[@"event"]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError], nil, nil);
	}];
}

- (void)report:(NSString *)path withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	[self postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
		if ([data isKindOfClass:[NSDictionary class]]) {
			if (block) block ([data[responseKeyStatus] boolValue], [FDErrorMessage messageFromData:data[responseKeyMsg]]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) block (NO, [FDErrorMessage messageNetworkError]);
	}];
}

- (void)reportComment:(NSNumber *)commentID withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSString *path = [NSString stringWithFormat:@"comment/%@/report", commentID];
	[self report:path withCompletionBlock:^(BOOL success, NSString *message) {
		if (block) block(success, message);
	}];
}

- (void)reportUser:(NSNumber *)userID withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSString *path = [NSString stringWithFormat:@"member/%@/report", userID];
	[self report:path withCompletionBlock:^(BOOL success, NSString *message) {
		if (block) block(success, message);
	}];
}

- (void)reportPhoto:(NSNumber *)photoID withCompletionBlock:(void (^)(BOOL success, NSString *message))block
{
	NSString *path = [NSString stringWithFormat:@"tweet/%@/report", photoID];
	[self report:path withCompletionBlock:^(BOOL success, NSString *message) {
		if (block) block(success, message);
	}];
}

@end
