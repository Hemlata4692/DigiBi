//
//  MyAddressDataModel.h
//  Digibi_ecommerce
//
//  Created by Monika on 11/18/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAddressDataModel : NSObject

@property(nonatomic,retain)NSString * customerAddressId;
@property(nonatomic,retain)NSString * city;
@property(nonatomic,retain)NSString * countryId;
@property(nonatomic,retain)NSString * firstname;
@property(nonatomic,retain)NSString * lastname;
@property(nonatomic,retain)NSString * postcode;
@property(nonatomic,retain)NSString * street;
@property(nonatomic,retain)NSString * telephone;
@property(nonatomic)BOOL isDefaultBilling;
@property(nonatomic)BOOL isDefaultShipping;
@property(nonatomic,retain)NSString * latLongStr;
@property(nonatomic,retain)NSString * state;


@property(nonatomic,retain)NSString * message;
@property(nonatomic,retain)NSString * dateValue;
@property(nonatomic,retain)NSString * countryName;
@end
