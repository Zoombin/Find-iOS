//
//  FDInformation.h
//  find
//
//  Created by zhangbin on 11/20/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FDInformationType) {
	FDInformationTypeQQ,
	FDInformationTypeMobile,
	FDInformationTypeWeixin,
	FDInformationTypeAddress
};


@interface FDInformation : NSObject

@property (nonatomic, assign) FDInformationType type;
@property (nonatomic, strong) id value;

+ (NSArray *)createMutableWithData:(NSDictionary *)data andPrivacy:(NSDictionary *)privacy;

- (BOOL)isPublic;
- (BOOL)isPartly;
- (BOOL)isPrivate;
- (NSString *)displayPrivacyType;
- (NSString *)display;

@end
