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

typedef NS_ENUM(NSInteger, FDInformationLevel) {//和服务器对应public是0
	FDInformationLevelPublic,
	FDInformationLevelPartly,
	FDInformationLevelPrivate
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
- (NSString *)valueString;

@end
