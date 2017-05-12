//
//  StoreDataModel.h
//  Digibi_ecommerce
//
//  Created by Ranosys on 17/11/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreDataModel : NSObject
//Store listing
@property(nonatomic,retain)NSString * storeName;
@property(nonatomic,retain)NSString * storeAddress;
@property(nonatomic,retain)NSString * storeId;
@property(nonatomic,assign)BOOL storeOpenStatus;
@property(nonatomic,assign)BOOL isFavorite;
@property(nonatomic,assign)BOOL selectedValue;
@property(nonatomic,assign)BOOL isLoader;
//End

//Product category listing
@property(nonatomic,retain)NSMutableDictionary * dataDic;
@property(nonatomic,retain)NSString * entity_id;
@property(nonatomic,retain)NSString * parent_id;
@property(nonatomic,retain)NSString * position;
@property(nonatomic,retain)NSString * description;
@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)NSString * image;
@property(nonatomic,retain)NSString * isCheck;
//End

//Product sub category listing
@property(nonatomic,retain)NSString * productId;
@property(nonatomic,retain)NSString * productName;
@property(nonatomic,retain)NSString * productPrice;
@property(nonatomic,retain)NSString * productCurrencySymbol;
@property(nonatomic,retain)NSString * productDescription;
@property(nonatomic,retain)NSString * productQuantity;
@property(nonatomic,retain)NSString * productImage;
@property(nonatomic,retain)NSString * productIsInStock;
@property(nonatomic,retain)NSString * productSku;
//End
@end
