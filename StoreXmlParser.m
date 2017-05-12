//
//  StoreXmlParser.m
//  Digibi_ecommerce
//
//  Created by Ranosys on 17/11/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import "StoreXmlParser.h"
#import "StoreDataModel.h"

@implementation StoreXmlParser
{
    StoreDataModel *DataModel,*DataModel1,*DataModel2,*DataModel3;
    NSMutableArray *MainCatArray,*MainCatArray2,*MainCatArray3,*productListArray;
    NSString *presentView;
    NSString *key,*value, *isView, *levelString;
    BOOL isClose;
    int count;
    NSArray *levelArray;
    NSMutableDictionary *mainDict;
    NSString *msg;
}
@synthesize currentNodeContent,testStr,status;

+ (id)sharedManager
{
    static StoreXmlParser *sharedMyManager = nil;
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

-(id) loadxmlByData:(NSData *)data viewString:(NSString*)myView
{
    //NSLog(@"entered in loadxmlByData");
    count = 0;
    levelArray = nil;
    levelString = @"";
    
    isClose=false;
    status=nil;
    key = @"";
    value = @"";
    isView = myView;
    MainCatArray=[[NSMutableArray alloc]init];
    
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
//    if ((MainCatArray == nil) || (MainCatArray.count == 0)) {
//        if (isClose) {
//            NSMutableDictionary *isCloseChecker = [NSMutableDictionary new];
//            [isCloseChecker setValue:[NSString stringWithFormat:@"No stores are open currently, please try again after some time."] forKey:@"message"];
//            [MainCatArray addObject:isCloseChecker];
//        }
//    }
    return MainCatArray;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"%@",elementname);
    if ([isView isEqualToString:@"Level"])
    {
        if ([elementname isEqualToString:@"level1"]) {
            DataModel1 = [[StoreDataModel alloc]init];
            levelString = @"level1";
        }
        else if ([elementname isEqualToString:@"level2"]) {
            DataModel1 = DataModel;
            MainCatArray2 = [NSMutableArray new];
            DataModel2 = [[StoreDataModel alloc]init];
            levelString = @"level2";
        }
        else if ([elementname isEqualToString:@"level3"]) {
            DataModel2 = DataModel;
            MainCatArray3 = [NSMutableArray new];
            DataModel3 = [[StoreDataModel alloc]init];
            levelString = @"level3";
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            
            DataModel=[[StoreDataModel alloc]init];
        }
        
    }
    else if ([isView isEqualToString:@"ProductList"])
    {
        if ([elementname isEqualToString:@"data"])
        {
            productListArray=[[NSMutableArray alloc]init];
        }
        else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
        {
            
            DataModel=[[StoreDataModel alloc]init];
        }
//        if ([elementname isEqualToString:@"complexObjectArray"])
//        {
//            DataModel=[[StoreDataModel alloc]init];
//        }
    }
    else{
        if ([elementname isEqualToString:@"ns1:Map"])
        {
            DataModel=[[StoreDataModel alloc]init];
        }
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
    /************************** Main category listing *******************************************/
    
    if ([elementname isEqualToString:@"key"])
    {
        key = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"value"])
    {
        if ([key isEqualToString:@"mageuserid"]) {
            DataModel.selectedValue = false;
            DataModel.storeId = currentNodeContent;
        }
        else if ([key isEqualToString:@"store_open"]) {
            if ([currentNodeContent intValue] == 0) {
                DataModel.storeOpenStatus = false;
                isClose=true;
            }
            else{
                DataModel.storeOpenStatus = true;
            }
        }
        else if ([key isEqualToString:@"favouriteStore"]) {
            if ([currentNodeContent isEqualToString:@"true"]) {
                DataModel.isFavorite = true;
            }
            else{
                DataModel.isFavorite = false;
            }
        }
        else if ([key isEqualToString:@"shoptitle"]) {
            DataModel.storeName = currentNodeContent;
        }
        else if ([key isEqualToString:@"complocality"]) {
            DataModel.storeAddress = currentNodeContent;
        }
    }
    else if ([elementname isEqualToString:@"ns1:Map"])
    {
        
//        if (DataModel.storeOpenStatus) {
            [MainCatArray addObject:DataModel];
//        }
//        NSLog(@"MainCatArray : %lu", (unsigned long) MainCatArray.count);
        key = @"";
    }
    //**********************ProductListing**************
    else if ([elementname isEqualToString:@"entity_id"])
    {
        DataModel.isCheck = @"0";
        DataModel.entity_id = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"parent_id"])
    {
        DataModel.parent_id = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"position"])
    {
        DataModel.position = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"description"])
    {
        DataModel.description = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"name"])//
    {
        DataModel.name = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"image"])//
    {
        DataModel.image = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"sku"])//
    {
        DataModel.productSku = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"price"])//
    {
        DataModel.productPrice = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"product_id"])//
    {
        DataModel.productId = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"currency_symbol"])//
    {
        DataModel.productCurrencySymbol = currentNodeContent;
        
    }
    //    else if ([elementname isEqualToString:@"description"])//
    //    {
    //        DataModel.productDescription = currentNodeContent;
    //
    //    }
    else if ([elementname isEqualToString:@"stock_quantity"])//
    {
        DataModel.productQuantity = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"is_in_stock"])//
    {
        DataModel.productIsInStock = currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
    {
        
        if ([isView isEqualToString:@"Level"]){
            if ([levelString isEqualToString:@"level1"]) {
                [MainCatArray addObject:DataModel1];
                //            levelString = @"level1";
            }
            else if ([levelString isEqualToString:@"level2"]) {
                [MainCatArray2 addObject:DataModel2];
                //            [DataModel2.dataDic setObject:MainCatArray3 forKey:@"level3"];
            }
            else if ([levelString isEqualToString:@"level3"]) {
                [MainCatArray3 addObject:DataModel];
            }
        }
        else if ([isView isEqualToString:@"ProductList"])
            {
                if ((DataModel != nil) && (DataModel.name != nil) && (![DataModel.name isEqualToString:@""]))
                {
                    [MainCatArray addObject:DataModel];
                }

            }
        
    }
    else if ([elementname isEqualToString:@"level1"])
    {
        levelString = @"level1";
        //        if (MainCatArray.count != 0) {
        //            [DataModel1.dataDic setObject:MainCatArray2 forKey:@"level2"];
        //        }
        
    }
    else if ([elementname isEqualToString:@"level2"])
    {
        levelString = @"level1";
        if (MainCatArray2.count != 0) {
            DataModel1.dataDic = [NSMutableDictionary new];
            [DataModel1.dataDic setObject:MainCatArray2 forKey:@"level2"];
        }
    }
    else if ([elementname isEqualToString:@"level3"])
    {
        
        levelString = @"level2";
        if (MainCatArray3.count != 0) {
            DataModel2.dataDic = [NSMutableDictionary new];
            [DataModel2.dataDic setObject:MainCatArray3 forKey:@"level3"];
        }
        
    }
    else if ([elementname isEqualToString:@"count"])
    {
        if ([isView isEqualToString:@"ProductList"])
        {
            
            [MainCatArray addObject:currentNodeContent];
        }
    }
    else if ([elementname isEqualToString:@"data"])
    {
//        if ([isView isEqualToString:@"ProductList"])
//        {
//            [MainCatArray addObject:productListArray];
//        }
    }


//    else if ([elementname isEqualToString:@"complexObjectArray"])
//    {
//        if ([isView isEqualToString:@"ProductList"])
//        {
//            if ((DataModel != nil) && (DataModel.name != nil) && (![DataModel.name isEqualToString:@""]))
//            {
//                [MainCatArray addObject:DataModel];
//            }
//        }
//    }
    
    else if ([elementname isEqualToString:@"status"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        
        testStr = currentNodeContent;
        testStr = [testStr stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        status=testStr;
        if ([isView isEqualToString:@"Favorite"]) {
            [MainCatArray addObject:status];
        }
        else if ([isView isEqualToString:@"StoreListing"]){
            if([status isEqual:@"0"])
            {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setObject:@"Currently, there are no stores available for this category." forKey:@"message"];
                [MainCatArray addObject:dict];
            }
        }
        else if ([isView isEqualToString:@"ProductList"])
        {
            if([status isEqual:@"0"])
            {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                [dict setObject:@"No products are available currently, matching your request." forKey:@"message"];
                [MainCatArray addObject:dict];
            }
            
        }
    }
        else if ([elementname isEqualToString:@"message"])
        {
//            NSLog(@"status **** %@",status );
    
            if (![status isEqual:@"1"] && status!=nil)
            {
//                NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
                testStr = currentNodeContent;
    
            }
        }
       
        else if ([elementname isEqualToString:@"faultstring"])
        {
//            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            testStr = currentNodeContent;
            if ([currentNodeContent isEqualToString:@"Session expired. Try to relogin."]) {
//                 NSLog(@"**************** Store time fault string : %@",currentNodeContent);
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                myDelegate.navigationController = [storyboard instantiateViewControllerWithIdentifier:@"mainNavController"];
                
                myDelegate.window.rootViewController = myDelegate.navigationController;
                [myDelegate unrigisterForNotification];
                [UserDefaultManager removeValue:@"customer_id"];
                [UserDefaultManager removeValue:@"sessionId"];
                [UserDefaultManager removeValue:@"quoteId"];
                [UserDefaultManager removeValue:@"ProductDetail"];
            }
            else
            {
                [self showAlertMessage:testStr];
            }
        }
    
      currentNodeContent=nil;
    
}

-(void)showAlertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
