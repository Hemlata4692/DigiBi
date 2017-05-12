//
//  ProductXMLParser.m
//  Digibi_ecommerce
//
//  Created by Monika on 9/22/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "ProductXMLParser.h"
#import "UserDefaultManager.h"
#import "MainCategoryDataModel.h"
@implementation ProductXMLParser
{
    MainCategoryDataModel *MainCatDataModel;
    NSMutableArray *MainCatArray;
    NSString *presentView, *presentTag;
    //NSString *key,*value;
    
}
@synthesize currentNodeContent,testStr,status;

+ (id)sharedManager
{
    static ProductXMLParser *sharedMyManager = nil;
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

-(id) loadxmlByData:(NSData *)data myView:(NSString*)myView
{
    //NSLog(@"entered in loadxmlByData");
    status=nil;
    //  key = @"";
    //  value = @"";
    MainCatArray=[[NSMutableArray alloc]init];
    presentTag = @"";
    presentView=myView;
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return MainCatArray;
    
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //    if ([elementname isEqualToString:@"result"])
    //    {
    //        MainCatArray=[[NSMutableArray alloc]init];
    //    }
    //    else if ([elementname isEqualToString:@"ns1:Map"])
    //    {
    //        MainCatDataModel=[[MainCategoryDataModel alloc]init];
    //    }
    
    if ([elementname isEqualToString:@"category"]) {
        presentTag = @"category";
    }
    else if ([elementname isEqualToString:@"home_banner"]){
        presentTag = @"home_banner";
    }
    else if ([elementname isEqualToString:@"club_banner"]){
        presentTag = @"club_banner";
    }
    
    
    if ([elementname isEqualToString:@"category"] || [elementname isEqualToString:@"complexObjectArray"])
    {
        //        MainCatArray=[[NSMutableArray alloc]init];
    }
    else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
    {
        MainCatDataModel=[[MainCategoryDataModel alloc]init];
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
    
    //    if ([elementname isEqualToString:@"key"]) {
    //        key = currentNodeContent;
    //        //NSLog(@"Title : %@", ElementValue);
    //    }
    //    else if ([elementname isEqualToString:@"value"]) {
    if ([elementname isEqualToString:@"entity_id"]) {
        MainCatDataModel.presentTag = @"category";
        MainCatDataModel.entityId = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"parent_id"]) {
        MainCatDataModel.parentId = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"position"]) {
        MainCatDataModel.position = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"description"]) {
        MainCatDataModel.description = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"name"]) {
        MainCatDataModel.name = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"image"]) {
        MainCatDataModel.image = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"content"]) {
        if ([presentTag isEqualToString:@"club_banner"]) {
            MainCatDataModel.presentTag = @"club_banner";
        }
        else if ([presentTag isEqualToString:@"home_banner"]){
            MainCatDataModel.presentTag = @"home_banner";
        }
        
        MainCatDataModel.image = currentNodeContent;
    }
    //    else if ([elementname isEqualToString:@"club_banner"]) {
    ////        MainCatDataModel.presentTag = @"club_banner";
    //        MainCatDataModel.image = currentNodeContent;
    //    }
    else if ([elementname isEqualToString:@"is_active"]) {
        MainCatDataModel.isActive = currentNodeContent;
    }
    
    
    else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
    {
        
        //if (MainCatDataModel.name != nil) {
        [MainCatArray addObject:MainCatDataModel];
//        NSLog(@"MainCatArray : %lu", (unsigned long) MainCatArray.count);
        // }
    }
    //        key = @"";
    //    }
    else if ([elementname isEqualToString:@"status"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        
        testStr = currentNodeContent;
        testStr = [testStr stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        status=testStr;
        //        [dataDic setObject:currentNodeContent forKey:@"status"];
        
        
    }
    else if ([elementname isEqualToString:@"message"])
    {
//        NSLog(@"status **** %@",status );
        
        if (![status isEqual:@"1"] && status!=nil)
        {
//            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            testStr = currentNodeContent;
            
            if ([presentView isEqualToString:@"Category"]) {
                [self showAlertMessage:testStr];
            }
        }
    }
    //        else{
    //            [dataDic setObject:currentNodeContent forKey:@"message"];
    //        }
    
    
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
            if ([presentView isEqualToString:@"Category"]) {
                [self showAlertMessage:testStr];
            }
        }
    }      else if ([elementname isEqualToString:@"result"])
    {
        //        [dataDic setObject:MainCatArray forKey:@"dataArr"];
    }
    currentNodeContent=nil;
}

-(void)showAlertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
