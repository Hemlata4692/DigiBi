//
//  ProductService.m
//  Digibi_ecommerce
//
//  Created by Monika on 9/22/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "ProductService.h"
#import "ProductXMLParser.h"
#import "MainCategoryDataModel.h"

//#define kUrlcatalogCategoryLevelRequestParam      @"catalogCategoryLevelRequestParam"
#define kUrlcustomerapiParentCategoryRequestParam   @"customerapiParentCategoryRequestParam"
#define kUrlcustomerapiStaticBlockInfoRequestParam  @"customerapiStaticBlockInfoRequestParam"
#define kUrlcustomerapiProductSearchRequestParam    @"customerapiProductSearchRequestParam"



@implementation ProductService
{
    MainCategoryDataModel *dataModal;
   
}
#pragma mark - singleton instance
+ (id)sharedManager
{
    static ProductService *sharedMyManager = nil;
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

-(id)catalogCategoryLevelRequestParam
{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"]};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiParentCategoryRequestParam];
    
    id webServiceDict;
    if (data == nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        NSMutableArray *webServiceData1 =[[ProductXMLParser sharedManager]loadxmlByData:data myView:@"Category"];
        //    NSLog(@"Main categories are %@",[[ProductXMLParser sharedManager] testStr]);
        NSMutableArray *categoryData = [NSMutableArray new];
        NSMutableArray *homeBannerData = [NSMutableArray new];
        NSMutableArray *clubBannerData = [NSMutableArray new];
        webServiceDict = [NSMutableDictionary new];
        if (webServiceData1 != nil && ([webServiceData1 count] != 0)) {
            for (int i = 0; i < webServiceData1.count; i++) {
                dataModal = [MainCategoryDataModel new];
                dataModal = [webServiceData1 objectAtIndex:i];
                
                if ([dataModal.presentTag isEqualToString:@"category"]) {
                    [categoryData addObject:dataModal];
                }
                else if ([dataModal.presentTag isEqualToString:@"home_banner"]){
                    homeBannerData = [self getDataFromHtmlCode:dataModal.image];
                    //                [homeBannerData addObject:dataModal];
                }
                else if ([dataModal.presentTag isEqualToString:@"club_banner"]){
                    clubBannerData = [self getDataFromHtmlCode:dataModal.image];
                    [clubBannerData addObject:dataModal.isActive];
                }
            }
            [webServiceDict setObject:categoryData forKey:@"category"];
            [webServiceDict setObject:homeBannerData forKey:@"home_banner"];
            [webServiceDict setObject:clubBannerData forKey:@"club_banner"];
        }
    }
    
    return webServiceDict;
}

#pragma mark - end

#pragma mark - Main category listing

-(id)customerapiStaticBlockInfoRequestParam:(NSString*)UrlKey
{
    
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
    
    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"urlkey":UrlKey};
    
    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiStaticBlockInfoRequestParam];
    id webServiceData = [[ProductXMLParser sharedManager]loadxmlByData:data myView:@"Banner"];
    if (webServiceData != nil && ([webServiceData count] != 0)) {
        dataModal = [MainCategoryDataModel new];
        dataModal = [webServiceData objectAtIndex:0];
        webServiceData = [self getDataFromHtmlCode:dataModal.image];
    }
    
    //    NSLog(@"Banner response %@",[[ProductXMLParser sharedManager] testStr]);
    return webServiceData;
}

#pragma mark - end

#pragma mark - Banner image

-(NSMutableArray*)getDataFromHtmlCode:(NSString*)content{
    NSMutableArray *webData = [NSMutableArray new];
    NSArray* arr = [content componentsSeparatedByString:@"<p>"];
    for (int i = 1; i < arr.count; i++) {
        content = [[arr objectAtIndex:i] stringByReplacingOccurrencesOfString:@"<img alt=\"\" src=\""
                                                                   withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\" /></p>"
                                                     withString:@""];
        [webData addObject:content];
    }
    return webData;
}
//#pragma mark - end
//#pragma mark - Search
//
//-(id)customerapiProductSearchRequestParam:(NSString*)searchKeyword
//{
//    NSLog(@"UserDefaultManager sessionId:%@",[UserDefaultManager getValue:@"sessionId"]);
//    NSLog(@"UserDefaultManager latitude:%@",[UserDefaultManager getValue:@"latitudeValue"]);
//    NSLog(@"UserDefaultManager longitude:%@",[UserDefaultManager getValue:@"longitudeValue"]);
//    NSLog(@"searchKeyword:%@",searchKeyword);
//
//    
////    NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"latitude":[UserDefaultManager getValue:@"latitudeValue"],@"longitude":[UserDefaultManager getValue:@"longitudeValue"],@"search_keyword":searchKeyword};
//    
//      NSDictionary * parameters = @{@"sessionId":[UserDefaultManager getValue:@"sessionId"],@"latitude":@"28.005910",@"longitude":@"73.326811",@"search_keyword":searchKeyword};
//    
//    NSData * data = [[Webservice sharedManager] fireWebservice:parameters methodName:kUrlcustomerapiProductSearchRequestParam];
//    id webServiceData =[[ProductXMLParser sharedManager]loadxmlByData:data myView:@"Category"];
//    return webServiceData;
//
//}
//#pragma mark - end

@end
