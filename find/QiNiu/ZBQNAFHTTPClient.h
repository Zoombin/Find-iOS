//
//  ZBQNAFHTTPClient.h
//  find
//
//  Created by zhangbin on 8/28/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "AFHTTPClient.h"

@interface ZBQNAFHTTPClient : AFHTTPClient

+(ZBQNAFHTTPClient *)shared;

- (void)uploadData:(NSData *)data name:(NSString *)name completionBlockWithSuccess:(dispatch_block_t)success;
- (void)uploadData:(NSData *)data name:(NSString *)name progressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress completionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
