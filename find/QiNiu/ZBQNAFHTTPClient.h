//
//  ZBQNAFHTTPClient.h
//  find
//
//  Created by zhangbin on 8/28/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "AFHTTPClient.h"
#import "FDPhoto.h"
#import "FDPhotoInfo.h"

@interface ZBQNAFHTTPClient : AFHTTPClient

+(instancetype)shared;

- (void)uploadData:(NSData *)data name:(NSString *)name completionBlock:(dispatch_block_t)block;

- (void)uploadData:(NSData *)data name:(NSString *)name progressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress completionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
