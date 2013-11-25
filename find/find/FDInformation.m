//
//  FDInformation.m
//  find
//
//  Created by zhangbin on 11/20/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//


static NSString *qq = @"qq";
static NSString *mobile = @"mobile";
static NSString *weixin = @"weixin";
static NSString *address = @"address";

#import "FDInformation.h"

@interface FDInformation ()

@property (readwrite) NSNumber *privacy;//0 公开, 1 部分人可见, 2 私密

@end

@implementation FDInformation

+ (NSDictionary *)typesDictionary
{
	static NSDictionary *typesDictionary;
	if (!typesDictionary) {
		typesDictionary = @{qq : @(FDInformationTypeQQ),
							mobile : @(FDInformationTypeMobile),
							weixin : @(FDInformationTypeWeixin),
							address : @(FDInformationTypeAddress)
							};
	}
	return typesDictionary;
}

+ (NSArray *)createMutableWithData:(NSDictionary *)data andPrivacy:(NSDictionary *)privacy
{
	NSMutableArray *informations = [NSMutableArray array];
	NSArray *keys = data.allKeys;
	for (NSString *key in keys) {
		if ([self typesDictionary][key]) {
			FDInformation *info = [[FDInformation alloc] init];
			info.type = (FDInformationType)[[self typesDictionary][key] integerValue];
			info.value = data[key];
			info.privacy = privacy[key];
			[informations addObject:info];
		}
	}
	return informations;
}

- (BOOL)isPublic
{
	if (_privacy) {
		return _privacy.integerValue == 0;
	}
	return NO;
}

- (BOOL)isPartly
{
	if (_privacy) {
		return _privacy.integerValue == 1;
	}
	return NO;
}

- (BOOL)isPrivate
{
	if (!_privacy) {
		return YES;//默认是私密的
	} else {
		return _privacy.integerValue == 2;
	}
}

- (NSString *)displayPrivacy
{
	if ([self isPublic]) {
		return NSLocalizedString(@"Public", nil);
	} else if ([self isPartly]) {
		return NSLocalizedString(@"Partly", nil);
	}
	return NSLocalizedString(@"Private", nil);
}

- (NSString *)description
{
	NSString *typeString;
	if (_type == FDInformationTypeQQ) {
		typeString = qq;
	} else if (_type == FDInformationTypeMobile) {
		typeString = mobile;
	} else if (_type == FDInformationTypeWeixin) {
		typeString = weixin;
	} else if (_type == FDInformationTypeAddress) {
		typeString = address;
	}
	return [NSString stringWithFormat:@"<type: %@, value: %@, isPublic: %@, isPartly: %@, isPrivate: %@>", typeString, _value, @([self isPublic]), @([self isPartly]), @([self isPrivate])];
}

@end
