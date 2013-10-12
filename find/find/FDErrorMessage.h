//
//  FDErrorMessage.h
//  find
//
//  Created by zhangbin on 10/12/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDErrorMessage : NSObject

+ (NSString *)messageFromData:(id)msgData;
+ (NSString *)messageNetworkError;

@end
