//
//  OrderHistoryDataModel.h
//  Digibi_ecommerce
//
//  Created by Monika on 11/27/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderHistoryDataModel : NSObject

@property(nonatomic,retain)NSString * OrderId;
@property(nonatomic,retain)NSString * dateAndTime;
@property(nonatomic,retain)NSString * grandTotal;
@property(nonatomic,retain)NSString * currencyCode;
@property(nonatomic,retain)NSString * shippingType;
@property(nonatomic,retain)NSString * shippingMethod;

@property(nonatomic,retain)NSString * status;
@property(nonatomic,retain)NSString * date;
@property(nonatomic,retain)NSString * time;
@property(nonatomic,retain)NSDate * gmtDate;

@property(nonatomic,retain)NSString * code;
@property(nonatomic,retain)NSString * carrier;
@property(nonatomic,retain)NSString * carrierTitle;
@property(nonatomic,retain)NSString * method;
@property(nonatomic,retain)NSString * methodTitle;

@property(nonatomic,retain)NSString * subTotal;
@property(nonatomic,retain)NSString * charges;
@property(nonatomic,retain)NSString * discount;

@property(nonatomic,retain)NSString * paymentMethod;


@end
