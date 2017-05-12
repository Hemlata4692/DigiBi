//
//  UserService.h
//  Digibi_ecommerce
//
//  Created by Sumit on 08/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserService : NSObject
//Get session id from server
-(void)getSessionId;
//end

//Login
-(NSMutableDictionary *)customerapiCustomerLogin:(NSString *)email password:(NSString *)password;

//end

////temp
//-(void)customerapiCustomerLogin;
////end

//Register user
-(NSMutableDictionary *)registerUser:(NSString *)name email:(NSString *)email mobileNumber:(NSString *)mobileNumber password:(NSString *)password;
//end

//Forgot password
-(NSMutableDictionary *)customerapiForgetPassword:(NSString *)email;
//end

//Change password
-(NSMutableDictionary *)customerapiChangePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;
//end

//Terms and conditions
-(NSMutableDictionary *)customerapiCmsPageInfoRequestParam:(NSString *)urlKey;
//end

//Add address
-(NSMutableDictionary *)customerAddressCreateRequestParam:(NSString *)name mobile:(NSString *)mobile streetAddress:(NSString *)streetAddress streetAddress2:(NSString *)streetAddress2 cityAddress:(NSString *)cityAddress countryId:(NSString *)countryId state:(NSString *)state postalCode:(NSString *)postalCode customerAddressId:(NSString *)customerAddressId latLong:(NSString *)latLong isEdit:(BOOL)isEdit;
//end


//My address
-(NSMutableDictionary *)customerAddressListRequestParam;
//end

//Delete address
-(NSMutableDictionary *)customerAddressDeleteRequestParam:(NSString *)customerAddressId;
//end

//Customer info
-(NSMutableDictionary *)customerCustomerInfoRequestParam;
//end

//Customer update profile
-(NSMutableDictionary *)customerCustomerUpdateRequestParam:(NSString *)name mobile:(NSString *)mobile email:(NSString *)email;
//end

//Notification list
-(NSMutableDictionary *)customerapiNotificationListingRequestParam;
//end

//Clear notification list
-(NSMutableDictionary *)customerapiNotificationClearRequestParam;
//end
//Singleton instance

////Country list
//-(NSMutableDictionary *)directoryCountryListRequestParam;
////end

//Country list
-(NSMutableDictionary *)customerapiDirectoryCountryListRequestParam;
//end

-(NSMutableDictionary *)customerapiClearCartRequestParam:(NSString *)latitude longitude:(NSString *)longitude;
+ (id)sharedManager;
//end

//Club authentication
-(id)customerapiClubAuthenticationRequestParam:(NSString *)clubCode uniqueCode:(NSString *)uniqueCode;
//end
@end
