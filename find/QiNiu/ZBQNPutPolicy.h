//
//  ZBQNPutPolicy.h
//  find
//
//  Created by zhangbin on 8/28/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

// NOTE: Generally speaking, this class is not required for client development.
// The token string should be retrieved from your biz server.

// Refer to the spec: http://docs.qiniu.com/api/put.html#uploadToken
@interface ZBQNPutPolicy : NSObject

@property (retain, nonatomic) NSString *scope;
@property (retain, nonatomic) NSString *callbackUrl;
@property (retain, nonatomic) NSString *callbackBody;
@property (retain, nonatomic) NSString *returnUrl;
@property (retain, nonatomic) NSString *returnBody;
@property (retain, nonatomic) NSString *asyncOps;
@property (retain, nonatomic) NSString *endUser;
@property int expires;

// Make uptoken string.
- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey;

@end
