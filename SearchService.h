//
//  SearchService.h
//  Digibi_ecommerce
//
//  Created by Ranosys on 20/11/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchService : NSObject
//Singleton instance
+ (id)sharedManager;
//end

-(id)customerapiProductSearchRequestParam:(NSString*)searchKeyword vendorId:(NSString*)vendorId;
@end

