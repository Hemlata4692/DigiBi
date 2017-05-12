//
//  SearchService.m
//  Digibi_ecommerce
//
//  Created by Ranosys on 20/11/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import "SearchService.h"
#import "SearchXmlParser.h"
#import "SearchDataModel.h"

#define kUrlcustomerapiProductSearchRequestParam  @"customerapiProductSearchRequestParam"


@implementation SearchService
{
    SearchDataModel *dataModal;
    
}
#pragma mark - singleton instance
+ (id)sharedManager
{
    static SearchService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedMyManager = [[self alloc] init];
                  });
    return sharedMyManager;
}
- (id)init
{
    
    if (self = [super init])
    {
        
    }
    return self;
}
#pragma mark - end
#pragma mark - Main category listing

-(id)customerapiProductSearchRequestParam:(NSString*)searchKeyword vendorId:(NSString*)vendorId
{
    //    <Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    //    <Body>
    //    <customerapiProductSearchRequestParam xmlns="urn:Magento">
    //    <sessionId xmlns="">68f089479e169418c336a3a0931ab9f9</sessionId>
    //    <search_keyword xmlns="">amul</search_keyword>
    //    <latitude xmlns="">28.005910</latitude>
    //    <longitude xmlns="">73.326811</longitude>
    //    <vendorid xmlns="">10</vendorid>
    //    </customerapiProductSearchRequestParam>
    //    </Body>
    //    </Envelope>
    
    NSDictionary * parameters;
    
    if ([vendorId isEqualToString:@""]) {
        parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"latitude":[UserDefaultManager getValue:@"latitudeValue"],@"longitude":[UserDefaultManager getValue:@"longitudeValue"],@"search_keyword":searchKeyword};
    }
    else{
        parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"latitude":[UserDefaultManager getValue:@"latitudeValue"],@"longitude":[UserDefaultManager getValue:@"longitudeValue"],@"search_keyword":searchKeyword , @"vendorid":vendorId};
    }
    
    //    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"latitude":@"28.005910",@"longitude":@"73.326811",@"search_keyword":@"amul"};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiProductSearchRequestParam];
    id webServiceData;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else
    {
        webServiceData =[[SearchXmlParser sharedManager]loadxmlByData:data];
    }
    return webServiceData;
}
#pragma mark - end

@end
