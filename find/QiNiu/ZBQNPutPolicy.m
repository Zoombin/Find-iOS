//
//  ZBQNPutPolicy.m
//  find
//
//  Created by zhangbin on 8/28/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "ZBQNPutPolicy.h"
#import <CommonCrypto/CommonHMAC.h>
#import "GTMBase64.h"

@implementation ZBQNPutPolicy

@synthesize scope;
@synthesize callbackUrl;
@synthesize callbackBody;
@synthesize returnUrl;
@synthesize returnBody;
@synthesize asyncOps;
@synthesize endUser;
@synthesize expires;

- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey
{
	NSString *policy = [self marshal];
    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedPolicy = [GTMBase64 stringByWebSafeEncodingData:policyData padded:TRUE];
    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
    
    char digestStr[CC_SHA1_DIGEST_LENGTH];
    bzero(digestStr, 0);
    const char *secretKeyStr = [secretKey UTF8String];
    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
	NSString *encodedDigest = [GTMBase64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
    
    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
	return token;
}

// Marshal as JSON format string.

- (NSString *)marshal
{
    time_t deadline;
    time(&deadline);
    deadline += (self.expires > 0) ? self.expires : 3600; // 1 hour by default.
    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
	
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.scope) {
        [dic setObject:self.scope forKey:@"scope"];
    }
    if (self.callbackUrl) {
        [dic setObject:self.callbackUrl forKey:@"callbackUrl"];
    }
    if (self.callbackBody) {
        [dic setObject:self.callbackBody forKey:@"callbackBody"];
    }
    if (self.returnUrl) {
        [dic setObject:self.returnUrl forKey:@"returnUrl"];
    }
    if (self.returnBody) {
        [dic setObject:self.returnBody forKey:@"returnBody"];
    }
    if (self.endUser) {
        [dic setObject:self.endUser forKey:@"endUser"];
    }
    [dic setObject:deadlineNumber forKey:@"deadline"];
    
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
													   options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
														 error:&error];
	
	NSString *jsonString;
	if (! jsonData) {
		NSLog(@"Got an error: %@", error);
	} else {
		jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	}
	
	return jsonString;
}

@end
