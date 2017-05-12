//
//  UserService.m
//  Digibi_ecommerce
//
//  Created by Sumit on 08/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "UserService.h"
#import "UserXMLParser.h"
#define kUrlLogin                                 @"loginParam"
#define kUrlcustomerapiCustomerLogin              @"customerapiCustomerLoginRequestParam"
#define kUrlcustomerCustomerCreate                @"customerCustomerCreateRequestParam"
#define kUrlcustomerapiForgetPassword             @"customerapiForgetPasswordRequestParam"
#define kUrlcustomerapiChangePassword             @"customerapiChangePasswordRequestParam"
#define kUrlcustomerapiCmsPageInfoRequestParam    @"customerapiCmsPageInfoRequestParam"
#define kUrlcustomerAddressListRequestParam       @"customerAddressListRequestParam"
#define kUrlcustomerAddressCreateRequestParam     @"customerAddressCreateRequestParam"
#define kUrlcustomerAddressUpdateRequestParam     @"customerAddressUpdateRequestParam"
#define kUrlcustomerAddressDeleteRequestParam     @"customerAddressDeleteRequestParam"
#define kUrlcustomerCustomerInfoRequestParam      @"customerCustomerInfoRequestParam"
#define kUrlcustomerCustomerUpdateRequestPara     @"customerCustomerUpdateRequestParam"
#define kUrlcustomerapiNotificationListingRequestParam    @"customerapiNotificationListingRequestParam"
#define kUrlcustomerapiNotificationClearRequestParam   @"customerapiNotificationClearRequestParam"
//#define kUrldirectoryCountryListRequestParam   @"directoryCountryListRequestParam"
#define kUrlcustomerapiDirectoryCountryListRequestParam   @"customerapiDirectoryCountryListRequestParam"

#define kUrlcustomerapiClearCartRequestParam   @"customerapiClearCartRequestParam"

#define kUrlcustomerapiClubAuthenticationRequestParam @"customerapiClubAuthenticationRequestParam"

@implementation UserService
{
    NSMutableDictionary *webserviceData;
}

#pragma mark - singleton instance
+ (id)sharedManager
{
    static UserService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedMyManager = [[self alloc] init];
                  });
    return sharedMyManager;
}
- (id)init
{
    
    if (self = [super init])
    {
        webserviceData = [NSMutableDictionary new];
        
    }
    return self;
}
#pragma mark - end

#pragma mark - get session id
-(void)getSessionId
{
    NSDictionary * parameters = @{@"username":@"digibiappuserv1",@"apiKey":@"4#6mobiledigibi"};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlLogin];
    [[UserXMLParser sharedManager]loadxmlByData:data presentView:@"Session"];
//    NSLog(@"final string is %@",[[UserXMLParser sharedManager] testStr]);
}
#pragma mark - end

#pragma mark - Login
-(NSMutableDictionary *)customerapiCustomerLogin:(NSString *)email password:(NSString *)password
{
    [webserviceData removeAllObjects];
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters;
    
    //        parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"email":email,@"password":password,@"devicetoken":@"dsCX-6lCqRo:APA91bHns0o3O0WuhyiI3IbXDxJH_rDWO5UNq3sYURjt75eHhBWNs6K9bpl3_JODuJ0OGjF3P9gGkGwLZmpO2bXqS2H23eoKEqwKIZR2aEfg9srkqntl_svnLNA7nSgmmwWomteVue46",@"devicetype":@"a",@"isfb":@"0",@"fbparams":@"", @"quoteId":@""};
    //    <quoteId xmlns="">194</quoteId>
    if(([UserDefaultManager getValue:@"quoteId"] == nil) || [[UserDefaultManager getValue:@"quoteId"] isEqualToString:@""]){
        parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"email":email,@"password":password,@"devicetoken":myDelegate.deviceToken,@"devicetype":@"i",@"isfb":@"0",@"fbparams":@"", @"quoteId":@""};
    }
    else{
        parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"email":email,@"password":password,@"devicetoken":myDelegate.deviceToken,@"devicetype":@"i",@"isfb":@"0",@"fbparams":@"", @"quoteId":[UserDefaultManager getValue:@"quoteId"]};
    };
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiCustomerLogin];
    
    
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webserviceData = [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
//    NSLog(@"final string is %@",[[UserXMLParser sharedManager] testStr]);
    return webserviceData;
}

#pragma mark - Register

-(NSMutableDictionary *)registerUser:(NSString *)name email:(NSString *)email mobileNumber:(NSString *)mobileNumber password:(NSString *)password
{
    [webserviceData removeAllObjects];
    
    NSDictionary * customerData;
    
    if(([UserDefaultManager getValue:@"quoteId"] == nil) || [[UserDefaultManager getValue:@"quoteId"] isEqualToString:@""]){
        customerData=@{@"customer_id":@"",@"email":email,@"firstname":name,@"lastname":@"",@"middlename":@"",@"password":password,@"website_id":@"1",@"store_id":@"1",@"group_id":@"1",@"store_id":@"1",@"prefix":@"",@"suffix":@"",@"dob":@"",@"taxvat":@"",@"gender":@"",@"mobileno":mobileNumber,@"quoteId":@"",@"devicetoken":myDelegate.deviceToken,@"devicetype":@"i"};
        
    }
    else{
        customerData=@{@"customer_id":@"",@"email":email,@"firstname":name,@"lastname":@"",@"middlename":@"",@"password":password,@"website_id":@"1",@"store_id":@"1",@"group_id":@"1",@"store_id":@"1",@"prefix":@"",@"suffix":@"",@"dob":@"",@"taxvat":@"",@"gender":@"",@"mobileno":mobileNumber, @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"devicetoken":myDelegate.deviceToken,@"devicetype":@"i"};
    }
    
    NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerData":customerData};
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerCustomerCreate];
    
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webserviceData = [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
//    NSLog(@"register string is %@",[[UserXMLParser sharedManager] testStr]);
    return webserviceData;
}

#pragma mark - end

#pragma mark - Forgot Password

-(NSMutableDictionary *)customerapiForgetPassword:(NSString *)email
{
    [webserviceData removeAllObjects];
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"email":email};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiForgetPassword];
    
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webserviceData = [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    //    webserviceData= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
//    NSLog(@"final string is %@",[[UserXMLParser sharedManager] testStr]);
    return webserviceData;
    
}
#pragma mark - end

#pragma mark - Change Password
-(NSMutableDictionary *)customerapiChangePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
//    NSLog(@"UserDefaultManager email:%@",[UserDefaultManager getValue:@"email"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"email":[UserDefaultManager getValue:@"email"],@"old_password":oldPassword,@"new_password":newPassword};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiChangePassword];
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webserviceData = [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
    //    webserviceData=[[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
//    NSLog(@"final string is %@",[[UserXMLParser sharedManager] testStr]);
    return webserviceData;
    
}
#pragma mark - end
#pragma mark - Terms and conditions

-(NSMutableDictionary *)customerapiCmsPageInfoRequestParam:(NSString *)urlKey
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"urlkey":urlKey};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiCmsPageInfoRequestParam];
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webserviceData = [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
    //    webserviceData= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
//    NSLog(@"Terms & condition is %@",[[UserXMLParser sharedManager] testStr]);
    return webserviceData;
}
#pragma mark - end
#pragma mark - Add address

-(NSMutableDictionary *)customerAddressCreateRequestParam:(NSString *)name mobile:(NSString *)mobile streetAddress:(NSString *)streetAddress streetAddress2:(NSString *)streetAddress2 cityAddress:(NSString *)cityAddress countryId:(NSString *)countryId state:(NSString *)state postalCode:(NSString *)postalCode customerAddressId:(NSString *)customerAddressId latLong:(NSString *)latLong isEdit:(BOOL)isEdit
{
    
    //    NSDictionary * street=@{@"complexObjectArray":streetAddress};
    NSString* street = [NSString stringWithFormat:@"<complexObjectArray>%@</complexObjectArray> <complexObjectArray>%@</complexObjectArray>",streetAddress,streetAddress2];
    NSDictionary * addressData=@{@"city":cityAddress,@"company":@"",@"country_id":countryId,@"fax":latLong,@"firstname":name,@"lastname":@"",@"middlename":@"",@"postcode":postalCode,@"prefix":@"",@"region_id":@"0",@"region":state,@"street":street,@"suffix":@"",@"telephone":mobile,@"is_default_billing":@"false",@"is_default_shipping":@"true"};
    
//    NSLog(@"sessionId %@",[UserDefaultManager getValue:@"sessionId"]);
//    NSLog(@"customer_id %@",[UserDefaultManager getValue:@"customer_id"]);
    
    
    NSData * data;
    
    if (isEdit==YES)
    {
        NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"addressId":customerAddressId,@"addressData":addressData};
        
        data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerAddressUpdateRequestParam];
    }
    else
    {
        NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"],@"addressData":addressData};
        
        data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerAddressCreateRequestParam];
        
    }
    
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webserviceData= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
//    NSLog(@"register string is %@",[[UserXMLParser sharedManager] testStr]);
    
    return webserviceData;
}
#pragma mark - end

#pragma mark - My addresses list

-(NSMutableDictionary *)customerAddressListRequestParam
{
//    NSLog(@"sessionId %@",[UserDefaultManager getValue:@"sessionId"]);
//    NSLog(@"customer_id %@",[UserDefaultManager getValue:@"customer_id"]);
    
    
    NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerAddressListRequestParam];
    
     id webServiceData1;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData1= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    //
    //    webserviceData= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
//    NSLog(@"register string is %@",[[UserXMLParser sharedManager] testStr]);
    return webServiceData1;
}

#pragma mark - end
#pragma mark - Delete address

-(NSMutableDictionary *)customerAddressDeleteRequestParam:(NSString *)customerAddressId
{
    
    
    NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"addressId":customerAddressId};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerAddressDeleteRequestParam];
    
    
    id webServiceData1;

    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData1= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
    
    //    NSLog(@"register string is %@",[[UserXMLParser sharedManager] testStr]);
    return webServiceData1;
    
}
#pragma mark - end

#pragma mark - Customer info(My profile)

-(NSMutableDictionary *)customerCustomerInfoRequestParam
{
    
    NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"],@"attributes":@"<complexObjectArray>firstname</complexObjectArray><complexObjectArray>email</complexObjectArray><complexObjectArray>mobileno</complexObjectArray>" };
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerCustomerInfoRequestParam];
    
    id webServiceData1;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData1= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@"infoRequest"];
    }
    
    
    //    NSLog(@"register string is %@",[[UserXMLParser sharedManager] testStr]);
    return webServiceData1;
    
}
#pragma mark - end

#pragma mark - Customer update profile
-(NSMutableDictionary *)customerCustomerUpdateRequestParam:(NSString *)name mobile:(NSString *)mobile email:(NSString *)email
{
    NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"],@"customerData": @{@"customer_id":[UserDefaultManager getValue:@"customer_id"],@"email":email,@"firstname":name,@"lastname":@"",@"middlename":@"",@"password":@"",@"website_id":@"1",@"store_id":@"1",@"group_id":@"1",@"prefix":@"",@"suffix":@"",@"dob":@"",@"taxvat":@"",@"gender":@"",@"mobileno":mobile} };
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerCustomerUpdateRequestPara];
    
   id webServiceData1;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData1= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@"infoRequest"];
    }
    
    
    //    NSLog(@"register string is %@",[[UserXMLParser sharedManager] testStr]);
    return webServiceData1;
    
}
#pragma mark - end

//<customerapiNotificationListingRequestParam xmlns="urn:Magento">
//<sessionId xmlns="">a429e3ced7dc8ba1ca45999e5a3debd6</sessionId>
//<customerId xmlns="">160</customerId>
//</customerapiNotificationListingRequestParam>
#pragma mark - Notification list

-(NSMutableDictionary *)customerapiNotificationListingRequestParam
{
    
    NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiNotificationListingRequestParam];
    
    id webServiceData1;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData1= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@"NotificationCenter"];
    }
    
    //    NSLog(@"register string is %@",[[UserXMLParser sharedManager] testStr]);
    return webServiceData1;
    
}
#pragma mark - end

#pragma mark - Clear notification list

-(NSMutableDictionary *)customerapiNotificationClearRequestParam
{
    
    NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"customerId":[UserDefaultManager getValue:@"customer_id"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiNotificationClearRequestParam];
  id  webServiceData1;
    
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData1= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@"NotificationCenter"];
    }
    
    //    NSLog(@"register string is %@",[[UserXMLParser sharedManager] testStr]);
    return webServiceData1;
    
}
#pragma mark - end

#pragma mark - Country list
-(NSMutableDictionary *)customerapiDirectoryCountryListRequestParam
{
    
    NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiDirectoryCountryListRequestParam];
   id webServiceData1= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@"Country"];
    return webServiceData1;
    
}

//-(NSMutableDictionary *)directoryCountryListRequestParam
//{
//
//    NSDictionary *parameters= @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
//
//    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrldirectoryCountryListRequestParam];
//    //    if (data == nil)
//    //    {
//    //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    //        alert.tag = 3;
//    //        [alert show];
//    //    }
//    //    else
//    //    {
//    webserviceData= [[UserXMLParser sharedManager]loadxmlByData:data presentView:@"Country"];
//    //    }
//
//    //    NSLog(@"register string is %@",[[UserXMLParser sharedManager] testStr]);
//    return webserviceData;
//
//}
#pragma mark - end

#pragma mark - Clear Cart
-(NSMutableDictionary *)customerapiClearCartRequestParam:(NSString *)latitude longitude:(NSString *)longitude
{
    [webserviceData removeAllObjects];
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"latitude":latitude,@"longitude":longitude,@"clubCode":@"",@"quoteId":[UserDefaultManager getValue:@"quoteId"]
                                  };
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiClearCartRequestParam];
    
    
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webserviceData = [[UserXMLParser sharedManager]loadxmlByData:data presentView:@"ClearCart"];
    }
    
//    NSLog(@"final string is %@",[[UserXMLParser sharedManager] testStr]);
    return webserviceData;
}

#pragma mark - end

#pragma mark - Club authentication

-(id)customerapiClubAuthenticationRequestParam:(NSString *)clubCode uniqueCode:(NSString *)uniqueCode
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"club_code":clubCode,@"unique_code":uniqueCode,@"latitude":[UserDefaultManager getValue:@"latitudeValue"],@"longitude":[UserDefaultManager getValue:@"longitudeValue"],@"quoteId":[UserDefaultManager getValue:@"quoteId"]};
    
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiClubAuthenticationRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        webServiceData =[[UserXMLParser sharedManager]loadxmlByData:data presentView:@"club"];
    }
    
    return webServiceData;
    
}

#pragma mark - end

@end
