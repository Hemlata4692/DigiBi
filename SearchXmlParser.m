//
//  SearchXmlParser.m
//  Digibi_ecommerce
//
//  Created by Ranosys on 20/11/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import "SearchXmlParser.h"
#import "SearchDataModel.h"

@implementation SearchXmlParser
{
    SearchDataModel *DataModel;
    NSMutableArray *MainCatArray, *storeDetailArray;
    NSMutableDictionary *searchDic;
    NSString *tagType;
}
@synthesize currentNodeContent,testStr,status;

+ (id)sharedManager
{
    static SearchXmlParser *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
//end

-(id) loadxmlByData:(NSData *)data
{
    status=nil;
    tagType = @"";
    MainCatArray=[[NSMutableArray alloc]init];
    
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
    return MainCatArray;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
    {
        searchDic = [NSMutableDictionary new];
        tagType = @"SOAP-ENC:Struct";
    }
    else if ([elementname isEqualToString:@"storedetails"])
    {
        storeDetailArray = [NSMutableArray new];
    }
    else if ([elementname isEqualToString:@"BOGUS"])
    {
        DataModel = [SearchDataModel new];
        tagType = @"BOGUS";
    }
}
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (currentNodeContent==nil)
    {
        currentNodeContent = [[NSMutableString alloc] initWithString:string];
    }
    else
    {
        if ([string isEqualToString:@"&"]) {
            string = @" &";
        }
        
        [currentNodeContent appendString:string];
        NSString *trimString= [currentNodeContent stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        currentNodeContent = [trimString mutableCopy];
    }
}
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementname isEqualToString:@"storeid"])
    {
        if ([tagType isEqualToString:@"SOAP-ENC:Struct"])
        {
            [searchDic setObject:currentNodeContent forKey:@"storeId"];
        }
        else
        {
            DataModel.storeid  = currentNodeContent;
        }
    }
    else if ([elementname isEqualToString:@"storename"])
    {
        if ([tagType isEqualToString:@"SOAP-ENC:Struct"])
        {
            [searchDic setObject:currentNodeContent forKey:@"storename"];
        }
        else
        {
            DataModel.storeName  = currentNodeContent;
        }
    }
    else if ([elementname isEqualToString:@"product_id"])
    {
        DataModel.product_id  = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"name"])
    {
        DataModel.name  = currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"stock_quantity"]) {
        DataModel.quantity  = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"is_in_stock"]) {
        DataModel.isInStock  = currentNodeContent;
        
    }

    else if ([elementname isEqualToString:@"sku"])
    {
        DataModel.sku  = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"open_store"])
    {
        if ([currentNodeContent intValue] == 0)
        {
            DataModel.storeIsOpen = false;
        }
        else{
            DataModel.storeIsOpen = true;
        }
        
    }
    else if ([elementname isEqualToString:@"offers"]) {
        DataModel.offers  = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"image"]) {
        DataModel.image  = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"price"]) {
        DataModel.price  = [NSString stringWithFormat:@"%.2f", [currentNodeContent floatValue] ];
        
    }
    else if ([elementname isEqualToString:@"currency_symbol"]) {
        DataModel.currency  = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"weight"]) {
        DataModel.weight  = [NSString stringWithFormat:@"%.2f", [currentNodeContent floatValue] ];
        
    }
    else if ([elementname isEqualToString:@"SOAP-ENC:Struct"]) {
        //        if ((searchDic != nil) && (searchDic.count != 0)) {
        [MainCatArray addObject:searchDic];
        //        }
    }
    else if ([elementname isEqualToString:@"storedetails"]) {
        //        if ((storeDetailArray != nil) && (storeDetailArray.count != 0)) {
        [searchDic setObject:storeDetailArray forKey:@"storedetails"];
        //        }
        //        else{
        //            searchDic = nil;
        //        }
    }
    else if ([elementname isEqualToString:@"BOGUS"]) {
        //        if (DataModel.storeIsOpen) {
        [storeDetailArray addObject:DataModel];
        //        }
    }
    else if ([elementname isEqualToString:@"status"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        
        testStr = currentNodeContent;
        testStr = [testStr stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        status=testStr;
    }
    else if ([elementname isEqualToString:@"message"])
    {
//        NSLog(@"status **** %@",status );
        
        if (![status isEqual:@"1"] && status!=nil)
        {
//            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            testStr = currentNodeContent;
            [self showAlertMessage:testStr];
        }
    }
    else if ([elementname isEqualToString:@"faultstring"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        if ([currentNodeContent isEqualToString:@"Session expired. Try to relogin."]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
            
            myDelegate.window.rootViewController = myDelegate.navigationController;
            [myDelegate unrigisterForNotification];
            [UserDefaultManager removeValue:@"customer_id"];
            [UserDefaultManager removeValue:@"sessionId"];
            [UserDefaultManager removeValue:@"quoteId"];
            [UserDefaultManager removeValue:@"ProductDetail"];

        }
        else{
            [self showAlertMessage:testStr];
        }
        
        
    }        currentNodeContent=nil;
}
-(void)showAlertMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert"
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction *okAction = [UIAlertAction
                actionWithTitle:@"OK"
                style:UIAlertActionStyleDefault
                handler:^(UIAlertAction *action)
                {
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }];
    
    [alertController addAction:okAction];
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
   
}
@end
