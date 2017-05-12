//
//  OrderService.h
//  Digibi_ecommerce
//
//  Created by Monika on 9/22/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderService : NSObject

//Singleton instance
+ (id)sharedManager;
//end

//Order history listing
-(id)salesOrderListRequestParam;
//end

//Order Detail listing
-(id)customerapiOrderDetailsRequestParam:(NSString *)orderId;
//end

//Cancel order
-(id)salesOrderCancelRequestParam:(NSString *)orderId;
//end

//Repeat order
-(id)customerapiRepeatOrderRequestParam:(NSString *)orderId latitude:(NSString *)latitude longitude:(NSString *)longitude forceAdd:(NSString*)forceAdd;
//end

//Club listing
-(id)customerapiClubListingRequestParam;
//end

////Club authentication
//-(id)customerapiClubAuthenticationRequestParam:(NSString *)clubCode uniqueCode:(NSString *)uniqueCode;
////end

//Quote id
-(id)shoppingCartCreateRequestParam;
//end

//Add cart
-(id)shoppingCartProductAddRequestParam:(NSString*)quoteId productId:(NSString*)productId qty:(NSString*)qty forceAdd:(NSString*)forceAdd;
//end

//Remove product from cart
-(id)shoppingCartProductRemoveRequestParam:(NSString*)quoteId productId:(NSString*)productId qty:(NSString*)qty sku:(NSString*)sku;
//end

//My cart
-(id)customerapiMyCartRequestParam;
//end

// Update product from cart
-(id)shoppingCartProductUpdateRequestParam:(NSString*)quoteId productData:(NSMutableDictionary*)productId;
//end


//Checkout

//Set address
-(id)shoppingCartCustomerAddressesRequestParam:(NSString*)name shippingMode:(NSString*)shippingMode addressId:(NSString*)addressId streetAddress:(NSString*)streetAddress city:(NSString*)city mobile:(NSString*)mobile countryCode:(NSString*)countryCode postcode:(NSString*)postcode latLong:(NSString*)latLong state:(NSString*)state;
//end

//Fetch shipping type list
-(id)shoppingCartShippingListRequestParam;
//end

//Set shipping type
-(id)shoppingCartShippingMethodRequestParam:(NSString*)shippingMethod;
//end

//Shopping cart payment list
-(id)shoppingCartPaymentListRequestParam;
//end

//Shopping cart payment method
-(id)shoppingCartPaymentMethodRequestParam:(NSString *)method;
//end

//Add coupan
-(id)shoppingCartCouponAddRequestParam:(NSString *)coupanCode;
//end

//Remove coupan
-(id)shoppingCartCouponRemoveRequestParam;
//end

//Shopping cart totals
-(id)shoppingCartTotals;
//end

//Misc service
-(id)customerapiMiscServiceRequestParam;
//end

//Placeorder
-(id)shoppingCartOrderRequestParam;
//end

//PayU order update
-(id)customerapiPayumoneyUpdateRequestParam:(NSString*)orderId price:(NSString*)price transactionId:(NSString*)transactionId;
//end

//Magento current date and time
-(id)customerapiServerTimeRequestParam;
//end

//Clear complete cart
-(id)customerapiNewQuoteRequestParam:(NSString*)orderId isClub:(NSString*)isClub;
//end

@end
