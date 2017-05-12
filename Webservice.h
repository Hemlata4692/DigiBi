//
//  Webservice.h
//  DigiBi
//
//  Created by Sumit on 07/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
//Live link
//#define BASE_URL                                 @"http://ranosys.net/client/digibi/index.php/api/v2_soap/index/"

//Beta link
//#define BASE_URL  @"http://ranosys.net/client/digibi/beta/index.php/api/v2_soap/index/"

//new link
#define BASE_URL    @"http://digibi.in/index.php/api/v2_soap/index/"

@interface Webservice : NSObject
@property(nonatomic,retain)NSMutableData *webResponseData;
//Singleton instance
+ (id)sharedManager;
//end

//Global webservice method
-(NSData *)fireWebservice:(NSDictionary *)parameters methodName:(NSString *)methodName;
//end

-(NSData *)fireWebserviceWithArray:(NSDictionary *)parameters methodName:(NSString *)methodName;

@end
