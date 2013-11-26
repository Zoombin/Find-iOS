//
//  FDUserProfile.m
//  find
//
//  Created by zhangbin on 10/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDUserProfile.h"

NSString *kProfileUsername = @"username";
NSString *kProfileGender = @"gender";
NSString *kProfileAge = @"age";
NSString *kProfileHeight = @"stature";
NSString *kProfileWeight = @"weight";
NSString *kProfileChest = @"chest";
NSString *kProfileNumberOfPhotos = @"numberOfPhotos";
NSString *kProfileNumberOfFollowers = @"numberOfFollowers";
NSString *kProfileNumberOfFollowing = @"numberOfFollowing";
NSString *kProfileViews = @"views";
NSString *kProfileSignature = @"signature";
NSString *kProfileAsignature = @"asignature";
NSString *kProfileQQ = @"qq";
NSString *kProfileMobile = @"mobile";
NSString *kProfileWeixin = @"weixin";
NSString *kProfileAddress = @"address";
NSString *kProfileAvatar = @"avatar";
NSString *kProfilePhotos = @"photos";
NSString *kProfilePrivateMessages = @"privateMessages";
NSString *kProfileSettings = @"settings";

@implementation FDUserProfile

+ (instancetype)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"A profile must have userID!");
	FDUserProfile *userProfile = [[FDUserProfile alloc] init];
	userProfile.userID = attributes[@"id"];
	userProfile.username = attributes[@"username"];
	userProfile.gender = attributes[@"gender"];
	userProfile.height = attributes[@"stature"];
	userProfile.signature = attributes[@"signature"];
//	userProfile.asignature = attributes[@"asignature"];//TODO: return is a number
	userProfile.numberOfPhotos = attributes[@"photos"];
	userProfile.age = attributes[@"age"];
	userProfile.chest = attributes[@"chest"];
	userProfile.weight = attributes[@"weight"];
	userProfile.numberOfFollowing = attributes[@"followed"];
	userProfile.numberOfFollowers = attributes[@"follower"];
	
	if (attributes[@"privacyinfo"] && attributes[@"userprivacy"]) {
		NSArray *informations = [FDInformation createMutableWithData:attributes[@"privacyinfo"] andPrivacy:attributes[@"userprivacy"]];
		for (FDInformation *info in informations) {
			if (info.type == FDInformationTypeQQ) {
				userProfile.qqInformation = info;
			} else if (info.type == FDInformationTypeMobile) {
				userProfile.mobileInformation = info;
			} else if (info.type == FDInformationTypeWeixin) {
				userProfile.weixinInformation = info;
			} else if (info.type == FDInformationTypeAddress) {
				userProfile.addressInformation = info;
			}
		}
	}
	return userProfile;
}

- (BOOL)isFemale
{
	return _gender.integerValue == 0;
}

- (NSString *)displayWithIdentifier:(NSString *)identifier
{
	if ([identifier isEqualToString:kProfileUsername]) {
		return _username;
	} else if ([identifier isEqualToString:kProfileSignature]) {
		return _signature;
	} else if ([identifier isEqualToString:kProfileAge]) {
		return [_age printableAge];
	} else if ([identifier isEqualToString:kProfileHeight]) {
		return [_height printableHeight];
	} else if ([identifier isEqualToString:kProfileWeight]) {
		return [_weight printableWeight];
	} else if ([identifier isEqualToString:kProfileChest]) {
		return [_chest printableChest];
	} else if ([identifier isEqualToString:kProfileQQ]) {
		return [_qqInformation displayPrivacy];
	} else if ([identifier isEqualToString:kProfileMobile]) {
		return [_mobileInformation displayPrivacy];
	} else if ([identifier isEqualToString:kProfileWeixin]) {
		return [_weixinInformation displayPrivacy];
	} else if ([identifier isEqualToString:kProfileAddress]) {
		return [_addressInformation displayPrivacy];
	} else if ([identifier isEqualToString:kProfilePhotos]) {
		return [_numberOfPhotos stringValue];
	}
	return nil;
}

- (NSString *)privacyInfoWithIdentifier:(NSString *)identifier
{
	if ([identifier isEqualToString:kProfileQQ]) {
		return (NSString *)[_qqInformation.value stringValue];
	} else if ([identifier isEqualToString:kProfileMobile]) {
		return (NSString *)[_mobileInformation.value stringValue];
	} else if ([identifier isEqualToString:kProfileWeixin]) {
		return (NSString *)_weixinInformation.value;
	} else if ([identifier isEqualToString:kProfileAddress]) {
		FDAddress *address = [FDAddress createWithAttributes:_addressInformation.value];
		return address.addr;
	}
	return nil;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<profile: userID: %@, username: %@>", _userID, _username];
}

@end
