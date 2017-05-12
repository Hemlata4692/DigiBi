//
//  OrderService.m
//  Digibi_ecommerce
//
//  Created by Monika on 9/22/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "OrderService.h"
#import "OrderXMLParser.h"
//#define kUrlsalesOrderListRequestParam                  @"salesOrderListRequestParam"
#define kUrlsalesOrderListRequestParam                  @"customerapiCustomorderListRequestParam"

//#define kUrlsalesOrderCancelRequestParam                @"salesOrderCancelRequestParam"
#define kUrlsalesOrderCancelRequestParam                @"customerapicancelRequestParam"

#define kUrlcustomerapiRepeatOrderRequestParam          @"customerapiRepeatOrderRequestParam"

#define kUrlcustomerapiOrderDetailsRequestParam         @"customerapiOrderDetailsRequestParam"
#define kUrlcustomerapiClubListingRequestParam          @"customerapiClubListingRequestParam"
#define kUrlcustomerapiClubAuthenticationRequestParam @"customerapiClubAuthenticationRequestParam"
#define kUrlshoppingCartCreateRequestParam              @"shoppingCartCreateRequestParam"
#define kUrlshoppingCartProductAddRequestParam          @"shoppingCartProductAddRequestParam"
#define kUrlcustomerapiAddtoCartRequestParam         @"customerapiAddtoCartRequestParam"

//Mycart
#define kUrlcustomerapiMyCartResponseParam              @"customerapiMyCartRequestParam"
#define kUrlshoppingCartProductRemoveRequestParam       @"shoppingCartProductRemoveRequestParam"
#define kUrlshoppingCartProductUpdateRequestParam       @"shoppingCartProductUpdateRequestParam"

//Checkout
#define kUrlshoppingCartCustomerAddressesRequestParam @"shoppingCartCustomerAddressesRequestParam"
#define kUrlshoppingCartShippingList                    @"shoppingCartShippingListRequestParam"
#define kUrlshoppingCartShippingMethod                  @"shoppingCartShippingMethodRequestParam"
#define kUrlshoppingCartPaymentList                     @"shoppingCartPaymentListRequestParam"
#define kUrlshoppingCartPaymentMethodRequestParam       @"shoppingCartPaymentMethodRequestParam"

#define kUrlshoppingCartCouponAddRequestParam           @"shoppingCartCouponAddRequestParam"
#define kUrlshoppingCartCouponRemoveRequestParam        @"shoppingCartCouponRemoveRequestParam"
#define kUrlshoppingCartTotals                          @"shoppingCartTotalsRequestParam"
#define kUrlcustomerapiMiscServiceRequestParam          @"customerapiMiscServiceRequestParam"
#define kUrlshoppingCartOrderRequestParam               @"shoppingCartOrderRequestParam"
#define kUrlcustomerapiPayumoneyUpdateRequestParam      @"customerapiPayumoneyUpdateRequestParam"
#define kUrlcustomerapiServerTimeRequestParam           @"customerapiServerTimeRequestParam"
#define kUrlcustomerapiNewQuoteRequestParam             @"customerapiNewQuoteRequestParam"


@implementation OrderService
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
#pragma mark - Order history listing
-(id)salesOrderListRequestParam
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
//    NSLog(@"UserDefaultManager customerId:%@",[UserDefaultManager getValue:@"customer_id"]);
    
    NSDictionary * complexObjectArray=@{@"key":@"customer_id",@"value":[UserDefaultManager getValue:@"customer_id"]};
    
    // NSDictionary * complexObjectArray=@{@"key":@"customer_id",@"value":@"9"};
    
    NSDictionary * filter=@{@"complexObjectArray":complexObjectArray};
    
    NSDictionary * value=@{@"key":@"eq",@"value":[UserDefaultManager getValue:@"customer_id"]};
    //NSDictionary * value=@{@"key":@"eq",@"value":@"9"};
    
    NSDictionary * complexObjectArray1=@{@"key":@"customer_id",@"value":value};
    
    NSDictionary * complex_filter=@{@"complexObjectArray":complexObjectArray1};
    
    NSDictionary * filters=@{@"filter":filter,@"complex_filter":complex_filter};
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"filters":filters};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlsalesOrderListRequestParam];
    
    id webServiceData;
    
    if (data==nil)
    {
        UIAlertView *  alert1=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert1 show];
    }
    else
    {
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"orderHistory"];
    }
    return webServiceData;
}
#pragma mark - end
#pragma mark - Order detail

-(id)customerapiOrderDetailsRequestParam:(NSString *)orderId
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"orderIncrementId":orderId};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiOrderDetailsRequestParam];
    
    id webServiceData;
    
    if (data==nil)
    {
        UIAlertView *  alert1=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert1 show];
    }
    else
    {
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"orderDetail"];
    }
    
    
    return webServiceData;
}

#pragma mark - end
#pragma mark - Cancel order

-(id)salesOrderCancelRequestParam:(NSString *)orderId;
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"orderIncrementId":orderId};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlsalesOrderCancelRequestParam];
    
    id webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@""];
    
    return webServiceData;
}

#pragma mark - end
#pragma mark - Repeat order

-(id)customerapiRepeatOrderRequestParam:(NSString *)orderId latitude:(NSString *)latitude longitude:(NSString *)longitude forceAdd:(NSString*)forceAdd
{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"] , @"orderIncrementId":orderId,@"latitude":latitude ,@"longitude":longitude, @"forceAdd":forceAdd};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiRepeatOrderRequestParam];
    
    
    if (data==nil)
    {
        UIAlertView *  alert1=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert1 show];
    }
    else
    {
        data =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"AddCart"];
    }
    return data;
}

#pragma mark - end

#pragma mark - Club listing

-(id)customerapiClubListingRequestParam
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiClubListingRequestParam];
    
    id webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"club"];
    
    return webServiceData;
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
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"club"];
    }
    
    return webServiceData;
    
}

#pragma mark - end
#pragma mark - Quote id

-(id)shoppingCartCreateRequestParam
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"store":@"1"};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartCreateRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"QuoteId"];
    }
    
    return webServiceData;
    
}
#pragma mark - end
#pragma mark - Add to cart
-(id)shoppingCartProductAddRequestParam:(NSString*)quoteId productId:(NSString*)productId qty:(NSString*)qty forceAdd:(NSString*)forceAdd
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    //    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":quoteId, @"productsData":
    //                                      @{@"complexObjectArray":
    //                                            @{@"product_id":productId, @"sku":sku, @"qty":qty, @"options":
    //                                                  @{@"complexObjectArray":
    //                                                        @{@"key":@"", @"value":@""}},
    //                                              @"links":
    //                                                  @{@"complexObjectArray":@""},@"bundle_option":@"",@"bundle_option_qty":@""
    //                                              }
    //                                        }
    //                                  ,@"store":@"1"
    //                                  };
    //
    
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":quoteId,@"productId":productId, @"productQty":qty, @"forceAdd":forceAdd};
    
    
    //    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartProductAddRequestParam];
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiAddtoCartRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"AddCart"];
    }
    
    return webServiceData;
    
}

#pragma mark - end
-(id)customerapiMyCartRequestParam
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiMyCartResponseParam];
    
    id webServiceData;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"myCart"];
    }
    
    return webServiceData;
    
}

#pragma mark - Remove product from cart
-(id)shoppingCartProductRemoveRequestParam:(NSString*)quoteId productId:(NSString*)productId qty:(NSString*)qty sku:(NSString*)sku
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":quoteId, @"productsData":
                                      @{@"complexObjectArray":
                                            @{@"product_id":productId, @"sku":sku, @"qty":qty, @"options":
                                                  @{@"complexObjectArray":
                                                        @{@"key":@"", @"value":@""}},
                                              @"links":
                                                  @{@"complexObjectArray":@""},@"bundle_option":@"",@"bundle_option_qty":@""
                                              }
                                        }
                                  ,@"store":@"1"
                                  };
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartProductRemoveRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"AddCart"];
    }
    
    return webServiceData;
    
}

#pragma mark - end

#pragma mark - Update product from cart
-(id)shoppingCartProductUpdateRequestParam:(NSString*)quoteId productData:(NSMutableDictionary*)productId
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSArray* ids = productId.allKeys;
    NSMutableArray* productDatas = [NSMutableArray new];
    for (int i = 0; i < ids.count; i++) {
        NSDictionary *dataDic = @{@"complexObjectArray":
                                      @{@"product_id":[[productId objectForKey:[ids objectAtIndex:i]] objectForKey:@"productId"], @"sku":[[productId objectForKey:[ids objectAtIndex:i]] objectForKey:@"sku"], @"qty":[[productId objectForKey:[ids objectAtIndex:i]] objectForKey:@"qty"], @"options":
                                            @{@"complexObjectArray":
                                                  @{@"key":@"", @"value":@""}},
                                        @"links":
                                            @{@"complexObjectArray":@""},@"bundle_option":@"",@"bundle_option_qty":@""
                                        }
                                  };
        [productDatas addObject:dataDic];
    }
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":quoteId, @"productsData":
                                      productDatas
                                  ,@"store":@"1"
                                  };
    
    NSData * data = [[Webservice sharedManager] fireWebserviceWithArray:parameters methodName:kUrlshoppingCartProductUpdateRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"updateCart"];
    }
    
    return webServiceData;
    
}

#pragma mark - end
#pragma mark - Shopping cart address set

-(id)shoppingCartCustomerAddressesRequestParam:(NSString*)name shippingMode:(NSString*)shippingMode addressId:(NSString*)addressId streetAddress:(NSString*)streetAddress city:(NSString*)city mobile:(NSString*)mobile countryCode:(NSString*)countryCode postcode:(NSString*)postcode latLong:(NSString*)latLong state:(NSString*)state
{
    
    
    NSMutableArray* customerAddressData = [NSMutableArray new];
    NSString *is_default_shipping;
    NSString *is_default_billing;
    for (int i = 0; i < 2; i++) {
        if (i==0)
        {
            shippingMode=@"shipping";
            is_default_shipping=@"1";
            is_default_billing=@"0";
        }
        else
        {
            shippingMode=@"billing";
            is_default_shipping=@"0";
            is_default_billing=@"1";
        }
        if (state)
        {
            NSDictionary *dataDic = @{@"complexObjectArray":
                                          @{@"mode":shippingMode, @"address_id":addressId, @"firstname":name, @"lastname":@"",@"company":@"",@"street":streetAddress,@"city":city,@"region":state,@"region_id":@"0",@"postcode":postcode,@"country_id":countryCode,@"telephone":mobile,@"fax":latLong,@"is_default_billing":is_default_billing,@"is_default_shipping":is_default_shipping
                                            }
                                      
                                      };
            [customerAddressData addObject:dataDic];
            
        }
        else
        {
            NSDictionary *dataDic = @{@"complexObjectArray":
                                          @{@"mode":shippingMode, @"address_id":addressId, @"firstname":name, @"lastname":@"",@"company":@"",@"street":streetAddress,@"city":city,@"region":@"",@"region_id":@"0",@"postcode":postcode,@"country_id":countryCode,@"telephone":mobile,@"fax":latLong,@"is_default_billing":is_default_billing,@"is_default_shipping":is_default_shipping
                                            }
                                      
                                      };
            [customerAddressData addObject:dataDic];
        }
    }
    
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"], @"customerAddressData":customerAddressData,@"store":@"1" };
    
    
    
    NSData * data = [[Webservice sharedManager] fireWebserviceWithArray:parameters methodName:kUrlshoppingCartCustomerAddressesRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        [webServiceData setObject:@"check" forKey:@"myChecker"];
    }
    else
    {
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
//    if (data == nil)
//    {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//    }
//    else{
//        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@""];
//    }
    
    return webServiceData;
}
#pragma mark - end
#pragma mark - Fetch shipping type list
-(id)shoppingCartShippingListRequestParam
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"store":@"1" };
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartShippingList];
    
    id webServiceData;
    
    if (data == nil)
    {
        [webServiceData setObject:@"check" forKey:@"myChecker"];
    }
    else
    {
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"checkout"];
//        [webServiceData setObject:[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"checkout"] forKey:@"Data"];
    }
    
    return webServiceData;
}
#pragma mark - end
#pragma mark - Set shipping type
-(id)shoppingCartShippingMethodRequestParam:(NSString*)shippingMethod
{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"shippingMethod":shippingMethod,@"store":@"1" };
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartShippingMethod];
    
    id webServiceData;
    if (data == nil)
    {
        [webServiceData setObject:@"check" forKey:@"myChecker"];

    }
    else{
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
    return webServiceData;
    
}
#pragma mark - end
#pragma mark - Shopping cart payment list
-(id)shoppingCartPaymentListRequestParam
{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"store":@"1" };
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartPaymentList];
    id webServiceData;
    if (data == nil)
    {
        [webServiceData setObject:@"check" forKey:@"myChecker"];
    }
    else
    {
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"checkout"];
//        [webServiceData setObject:[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"checkout"] forKey:@"Data"];
//         webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"checkout"];
    }
    
    return webServiceData;
    
}
#pragma mark - end

#pragma mark - Shopping cart payment method
-(id)shoppingCartPaymentMethodRequestParam:(NSString *)method{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],
                                  @"paymentData":
                                      @{@"po_number":@"", @"method":method, @"cc_cid":@"", @"cc_owner":@"",@"cc_number":@"",@"cc_type":@"",@"cc_exp_year":@"",@"cc_exp_month":@""
                                        }
                                  };
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartPaymentMethodRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
    return webServiceData;
    
}
#pragma mark - end

#pragma mark - Add coupan
-(id)shoppingCartCouponAddRequestParam:(NSString *)coupanCode{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"store":@"1",@"couponCode":coupanCode };
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartCouponAddRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Alert"
                                              message:@"Something went wrong, please try again later."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [alertController addAction:okAction];
        [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];

        
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
    }
    else{
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"checkout"];
    }
    
    return webServiceData;
    
}
#pragma mark - end

#pragma mark - Remove coupan
-(id)shoppingCartCouponRemoveRequestParam{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"store":@"1" };
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartCouponRemoveRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"checkout"];
    }
    
    return webServiceData;
    
}
#pragma mark - end

#pragma mark - Shopping cart totals
-(id)shoppingCartTotals{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"store":@"1" };
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartTotals];
    
    id webServiceData;
    
    if (data == nil)
    {
        [webServiceData setObject:@"check" forKey:@"myChecker"];
    }
    else
    {
         webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
    return webServiceData;
}
#pragma mark - end
#pragma mark - Misc service
-(id)customerapiMiscServiceRequestParam
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiMiscServiceRequestParam];
    
    id webServiceData2;
    
    if (data == nil)
    {
        [webServiceData2 setObject:@"check" forKey:@"myChecker"];
    }
    else
    {
        webServiceData2 =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@"checkout"];
    }
    
    return webServiceData2;
}
#pragma mark - end

#pragma mark - Placeorder
-(id)shoppingCartOrderRequestParam
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],
                                  @"agreements":
                                      @{@"complexObjectArray":@""
                                        }
                                  };
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlshoppingCartOrderRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
    return webServiceData;
}
#pragma mark -end


#pragma mark - PayU order update
-(id)customerapiPayumoneyUpdateRequestParam:(NSString*)orderId price:(NSString*)price transactionId:(NSString*)transactionId
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"], @"orderIncrementId":orderId, @"transectionId":transactionId, @"price": price};
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiPayumoneyUpdateRequestParam];
    
    id webServiceData;
    if (data == nil)
    {
        [webServiceData setObject:@"check" forKey:@"myChecker"];
    }
    else
    {
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
    return webServiceData;
}
#pragma mark - end
#pragma mark - Magento current date and time
-(id)customerapiServerTimeRequestParam
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiServerTimeRequestParam];
    
    
    id webServiceData;
    if (data == nil)
    {
        [webServiceData setObject:@"check" forKey:@"myChecker"];
    }
    else
    {
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
    return webServiceData;
}
#pragma mark - end
#pragma mark - Clear complete cart
-(id)customerapiNewQuoteRequestParam:(NSString*)orderId isClub:(NSString*)isClub;
{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"], @"quoteId":[UserDefaultManager getValue:@"quoteId"],@"customerId":[UserDefaultManager getValue:@"customer_id"],
                                  @"isclub":isClub,@"orderid":orderId};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiNewQuoteRequestParam];
    
    id webServiceData;
    
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        webServiceData =[[OrderXMLParser sharedManager]loadxmlByData:data presentView:@""];
    }
    
    return webServiceData;
}
#pragma mark - end
@end
