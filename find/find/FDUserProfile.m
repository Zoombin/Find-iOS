//
//  FDUserProfile.m
//  find
//
//  Created by zhangbin on 10/6/13.
//  Copyright (c) 2013 ZoomBin. All rights reserved.
//

#import "FDUserProfile.h"

@implementation FDUserProfile

+ (instancetype)createWithAttributes:(NSDictionary *)attributes
{
	NSAssert(attributes[@"id"], @"A profile must have userID!");
	FDUserProfile *userProfile = [[FDUserProfile alloc] init];
	userProfile.userID = attributes[@"id"];
	userProfile.username = attributes[@"username"];
	userProfile.gender = attributes[@"gender"];
	userProfile.height = attributes[@"stature"];
//	userProfile.birthday = attributes[@"birthday"];//TODO: return is string
	userProfile.signature = attributes[@"signature"];
//	userProfile.asignature = attributes[@"asignature"];//TODO: return is a number
	userProfile.numberOfPhotos = attributes[@"photos"];
	userProfile.age = attributes[@"age"];
	userProfile.chest = attributes[@"chest"];
	userProfile.weight = attributes[@"weight"];
	userProfile.numberOfFollowing = attributes[@"followed"];
	userProfile.numberOfFollowers = attributes[@"follower"];
	
	if (attributes[@"contact"] && attributes[@"userprivacy"]) {
		NSArray *informations = [FDInformation createMutableWithData:attributes[@"contact"] andPrivacy:attributes[@"userprivacy"]];
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

- (NSString *)description
{
	return [NSString stringWithFormat:@"<profile: userID: %@, username: %@>", _userID, _username];
}

@end
