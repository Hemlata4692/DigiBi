//
//  SearchDataModel.h
//  Digibi_ecommerce
//
//  Created by Monika on 11/19/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDataModel : NSObject
@property(nonatomic,retain)NSString * product_id;
@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)NSString * sku;
@property(nonatomic,retain)NSString * image;
@property(nonatomic,retain)NSString * price;
@property(nonatomic,retain)NSString * weight;
@property(nonatomic,retain)NSString * storeid;
@property(nonatomic,retain)NSString * storeName;
@property(nonatomic,retain)NSString * offers;
@property(nonatomic,retain)NSString * currency;
@property(nonatomic,assign)BOOL storeIsOpen;
@property(nonatomic,retain)NSString * isInStock;
@property(nonatomic,retain)NSString * quantity;

@end
