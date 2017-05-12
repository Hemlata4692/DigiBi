//
//  ProductService.h
//  Digibi_ecommerce
//
//  Created by Monika on 9/22/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductService : NSObject
//Singleton instance
+ (id)sharedManager;
//end


//Main category listing
-(id)catalogCategoryLevelRequestParam;
//end

//Banner
-(id)customerapiStaticBlockInfoRequestParam:(NSString*)UrlKey;
//end

//Search
//-(id)customerapiProductSearchRequestParam:(NSString*)searchKeyword;
//end
@end
