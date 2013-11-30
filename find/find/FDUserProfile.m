//
//  FDUserProfile.m
//  find
//
//  Created by zhangbin on 10/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDUserProfile.h"

NSString *kProfileShape = @"privacyinfo";
NSString *kProfileNickname = @"nickname";
NSString *kProfileAvatar = @"avatar";
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
NSString *kProfilePhotos = @"photos";
NSString *kProfilePrivateMessages = @"privateMessages";
NSString *kProfileSettings = @"settings";

@implementation FDUserProfile

+ (instancetype)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"A profile must have userID!");
	FDUserProfile *userProfile = [[FDUserProfile alloc] init];
	userProfile.userID = attributes[@"id"];
	userProfile.nickname = attributes[@"nickname"];
	userProfile.avatarPath = attributes[@"avatar"];
	userProfile.bFemale = [attributes[@"gender"] integerValue] == 0;
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

- (id)valueWithIdentifier:(NSString  *)identifier
{
	if ([identifier isEqualToString:kProfileNickname]) {
		return _nickname;
	} else if ([identifier isEqualToString:kProfileSignature]) {
		return _signature;
	} else if ([identifier isEqualToString:kProfileAge]) {
		return _age;
	} else if ([identifier isEqualToString:kProfileHeight]) {
		return _height;
	} else if ([identifier isEqualToString:kProfileWeight]) {
		return _weight;
	} else if ([identifier isEqualToString:kProfileChest]) {
		return _chest;
	} else if ([identifier isEqualToString:kProfileQQ]) {
		return _qqInformation;
	} else if ([identifier isEqualToString:kProfileMobile]) {
		return _mobileInformation;
	} else if ([identifier isEqualToString:kProfileWeixin]) {
		return _weixinInformation;
	} else if ([identifier isEqualToString:kProfileAddress]) {
		return _addressInformation;
	} else if ([identifier isEqualToString:kProfilePhotos]) {
		return _numberOfPhotos;
	}
	return nil;
}

- (NSString *)displayWithIdentifier:(NSString *)identifier
{
	if ([identifier isEqualToString:kProfileNickname]) {
		return _nickname;
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
		return [_qqInformation displayPrivacyType];
	} else if ([identifier isEqualToString:kProfileMobile]) {
		return [_mobileInformation displayPrivacyType];
	} else if ([identifier isEqualToString:kProfileWeixin]) {
		return [_weixinInformation displayPrivacyType];
	} else if ([identifier isEqualToString:kProfileAddress]) {
		return [_addressInformation displayPrivacyType];
	} else if ([identifier isEqualToString:kProfilePhotos]) {
		return [_numberOfPhotos stringValue];
	}
	return nil;
}

- (NSString *)privacyInfoWithIdentifier:(NSString *)identifier
{
	NSString *value = nil;
	if ([identifier isEqualToString:kProfileQQ]) {
		value = [_qqInformation display];
	} else if ([identifier isEqualToString:kProfileMobile]) {
		value = [_mobileInformation display];
	} else if ([identifier isEqualToString:kProfileWeixin]) {
		value = [_weixinInformation display];
	} else if ([identifier isEqualToString:kProfileAddress]) {
		value = [_addressInformation display];
	}
	return value;
}

- (void)setValue:(NSNumber *)value withIdentifier:(NSString *)identifier
{
	if ([identifier isEqualToString:kProfileAge]) {
		_age = value;
	} else if ([identifier isEqualToString:kProfileHeight]) {
		_height = value;
	} else if ([identifier isEqualToString:kProfileWeight]) {
		_weight = value;
	} else if ([identifier isEqualToString:kProfileChest]) {
		_chest = value;
	}
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<profile: userID: %@, nickname: %@>", _userID, _nickname];
}

@end
