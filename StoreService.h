//
//  StoreService.h
//  Digibi_ecommerce
//
//  Created by Ranosys on 17/11/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreService : NSObject
//Singleton instance
+ (id)sharedManager;
//end



//Main category listing
-(id)customerapiStoreListingRequestParam:(int)categoryId;
//end
//Add favourite store
-(id)customerapiFavouriteStoreAddRequestParam:(NSString*)storeId;
//end

//Delete favourite store
-(id)customerapiFavouriteStoreDeleteRequestParam:(NSString*)storeId;
//end

//Product category listing
-(id)customerapiCategoryListingRequestParam:(NSString*)sellerId;
//end

//Product sub category listing
-(id)customerapiProductListingRequestParam:(NSString *)vendorId categoryIdArr:(NSMutableArray *)categoryIdArr offset:(NSString *)offset;
//end
@end
