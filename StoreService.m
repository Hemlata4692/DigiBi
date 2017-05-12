//
//  StoreService.m
//  Digibi_ecommerce
//
//  Created by Ranosys on 17/11/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import "StoreService.h"
#import "StoreXmlParser.h"
#import "StoreDataModel.h"

#define kUrlcustomerapiCategoryListingRequestParam          @"customerapiCategoryListingRequestParam"
#define kUrlcustomerapiStoreListingRequestParam             @"customerapiStoreListingRequestParam"
#define kUrlcustomerapiFavouriteStoreAddRequestParam        @"customerapiFavouriteStoreAddRequestParam"
#define kUrlcustomerapiFavouriteStoreDeleteRequestParam     @"customerapiFavouriteStoreDeleteRequestParam"
#define kUrlcustomerapiProductListingRequestParam           @"customerapiProductListingRequestParam"

@implementation StoreService
{
    StoreDataModel *dataModal;
    
}
#pragma mark - singleton instance
+ (id)sharedManager
{
    static StoreService *sharedMyManager = nil;
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
        
    }
    return self;
}
#pragma mark - end

#pragma mark - Main category listing


-(id)customerapiStoreListingRequestParam:(int)categoryId
{
//    NSLog(@"**************** Store screen webservice time session id : %@",[UserDefaultManager getValue:@"sessionId"]);
    //    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
//    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"latitude":[NSString stringWithFormat:@"%f",28.005910 ], @"longitude":[NSString stringWithFormat:@"%f",73.326811 ], @"category_id":[NSString stringWithFormat:@"%d",categoryId], @"customer_id":@"10"};
    
        NSDictionary * parameters;
        if ([UserDefaultManager getValue:@"customer_id"] !=nil){
            parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"latitude":[UserDefaultManager getValue:@"latitudeValue"], @"longitude":[UserDefaultManager getValue:@"longitudeValue"], @"category_id":[NSString stringWithFormat:@"%d",categoryId ], @"customer_id":[UserDefaultManager getValue:@"customer_id"]};
        }
        else{
            parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"latitude":[UserDefaultManager getValue:@"latitudeValue"], @"longitude":[UserDefaultManager getValue:@"longitudeValue"], @"category_id":[NSString stringWithFormat:@"%d",categoryId ], @"customer_id":@""};
        }
    
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiStoreListingRequestParam];
    id webServiceData1;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData1 =[[StoreXmlParser sharedManager]loadxmlByData:data viewString:@"StoreListing"];
    }
    return webServiceData1;
}
#pragma mark - end

-(id)customerapiFavouriteStoreAddRequestParam:(NSString*)storeId
{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"store_id":storeId, @"customer_id":[UserDefaultManager getValue:@"customer_id"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiFavouriteStoreAddRequestParam];
    id webServiceData1 =[[StoreXmlParser sharedManager]loadxmlByData:data viewString:@"Favorite"];
//    NSLog(@"Main categories are %@",@"next1");
    return webServiceData1;
}
#pragma mark - end

-(id)customerapiFavouriteStoreDeleteRequestParam:(NSString*)storeId
{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"store_id":storeId, @"customer_id":[UserDefaultManager getValue:@"customer_id"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiFavouriteStoreDeleteRequestParam];
    id webServiceData1;
    if (data != nil) {
        webServiceData1 =[[StoreXmlParser sharedManager]loadxmlByData:data viewString:@"Favorite"];
    }
    else{
        webServiceData1 = nil;
    }
    
    return webServiceData1;
}
#pragma mark - end

#pragma mark - Product category listing
-(id)customerapiCategoryListingRequestParam:(NSString*)sellerId;
{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"seller_id":sellerId};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiCategoryListingRequestParam];
    id webServiceData1;
    
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData1 =[[StoreXmlParser sharedManager]loadxmlByData:data viewString:@"Level"];
    }
    
    return webServiceData1;
}
#pragma mark - end

#pragma mark - Product sub category listing
-(id)customerapiProductListingRequestParam:(NSString *)vendorId categoryIdArr:(NSMutableArray *)categoryIdArr offset:(NSString *)offset
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"vendor_id":vendorId, @"category_id":categoryIdArr,@"offset":offset};
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiProductListingRequestParam];
    id webServiceData1;
    
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData1 =[[StoreXmlParser sharedManager]loadxmlByData:data viewString:@"ProductList"];
    }
    
    return webServiceData1;
}
#pragma mark - end
@end
