//
//  OrderDetailModel.h
//  Digibi_ecommerce
//
//  Created by Monika on 12/2/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject

@property(nonatomic,retain)NSString * shoptitle;
@property(nonatomic,retain)NSString * vendorId;
@property(nonatomic,retain)NSString * latitude;
@property(nonatomic,retain)NSString * longitude;

@property(nonatomic,retain)NSString * productName;
@property(nonatomic,retain)NSString * sku;
@property(nonatomic,retain)NSString * productId;
@property(nonatomic,retain)NSString * price;
@property(nonatomic,retain)NSString * productImage;

@property(nonatomic,retain)NSString * productCurrencyCode;
@property(nonatomic,retain)NSString * itemsCount;
@property(nonatomic,retain)NSString * quantity;
@property(nonatomic,retain)NSString * productQuantity;

@property(nonatomic,retain)NSString * availableQuantity;

@property(nonatomic,retain)NSString * firstname;
@property(nonatomic,retain)NSString * middlename;
@property(nonatomic,retain)NSString * lastname;
@property(nonatomic,retain)NSString * street;
@property(nonatomic,retain)NSString * city;
@property(nonatomic,retain)NSString * postcode;
@property(nonatomic,retain)NSString * region;

@property(nonatomic,retain)NSString * addressId;
@property(nonatomic,retain)NSString * telephone;
@property(nonatomic,retain)NSString * latLongStr;

@property(nonatomic,retain)NSString * isInStock;
@property(nonatomic,retain)NSString * isClose;

@property(nonatomic,retain)NSString * paymentMethod;


@end
