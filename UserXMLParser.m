//
//  XMLParser.m
//  SleepApp
//
//  Created by Isolpc32 on 04/03/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "UserXMLParser.h"
#import "UserDefaultManager.h"
#import "MyAddressDataModel.h"
@implementation UserXMLParser
{
    NSMutableDictionary *dataDic, *countryCode;
    MyAddressDataModel *myAddressDataModel;
    NSMutableArray *myAddressArray;
    NSString *myPresentView;
    NSString* key;

}
@synthesize currentNodeContent;
@synthesize testStr,status;

//Shared instance init
+ (id)sharedManager
{
    static UserXMLParser *sharedMyManager = nil;
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
        dataDic = [NSMutableDictionary new];
        
    }
    return self;
}
//end

-(NSMutableDictionary *) loadxmlByData:(NSData *)data presentView:(NSString*)myView
{
    status=nil;
    key = @"";

    myPresentView = myView;
    [dataDic removeAllObjects];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return dataDic;
    
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementname isEqualToString:@"result"] )
    {
       
        if (![myPresentView isEqualToString:@"NotificationCenter"] && ![myPresentView isEqualToString:@"Country"]) {
            myAddressArray=[[NSMutableArray alloc]init];
        }
        else{
            if ([myPresentView isEqualToString:@"Country"]) {
                countryCode = [NSMutableDictionary new];
            }
            
        }
        
    }
    else if ([elementname isEqualToString:@"complexObjectArray"])
    {
        myAddressDataModel=[[MyAddressDataModel alloc]init];
    }
    
    else  if ([elementname isEqualToString:@"notification_message"]) {
        myAddressArray=[[NSMutableArray alloc]init];
    }
    else  if ([elementname isEqualToString:@"SOAP-ENC:Struct"]) {
        if ([myPresentView isEqualToString:@"NotificationCenter"]) {
            myAddressDataModel = [MyAddressDataModel new];
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
        
        NSString *trimString= [currentNodeContent stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        currentNodeContent = [trimString mutableCopy];
        [currentNodeContent appendString:string];
    }
}
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    /************************** SessionId *******************************************/
    
    if ([elementname isEqualToString:@"result"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        
        [dataDic setObject:currentNodeContent forKey:@"result"];
        
        if (myDelegate.isSessionId ==1)
        {
            [UserDefaultManager setValue:testStr key:@"sessionId"];
            myDelegate.isSessionId=0;
        }
        if ([myPresentView isEqualToString:@"Country"]) {
            [dataDic setObject:countryCode forKey:@"CountryCode"];
        }
        
    }
    /************************** Login *******************************************/
    
    else if ([elementname isEqualToString:@"customer_id"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        if (![myPresentView isEqualToString:@"infoRequest"]) {
            if (![currentNodeContent isEqualToString:@"\n"]) {
                            
                if ([myPresentView isEqualToString:@"club"]) {
                    [dataDic setObject:currentNodeContent forKey:@"customer_id"];
                }
                else{
                    [UserDefaultManager setValue:currentNodeContent key:@"customer_id"];
                }
                
                
            }
        }
    }
    else if ([elementname isEqualToString:@"customer_name"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        if (![currentNodeContent isEqualToString:@"\n"]) {
            [dataDic setObject:currentNodeContent forKey:@"customer_name"];
            
            [UserDefaultManager setValue:currentNodeContent key:@"customer_name"];
        }
    }
    else if ([elementname isEqualToString:@"quoteId"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        if (![currentNodeContent isEqualToString:@""]) {
            if (![currentNodeContent isEqualToString:@"\n"]) {
                [UserDefaultManager setValue:currentNodeContent key:@"quoteId"];
            }
        }
    }
    else if ([elementname isEqualToString:@"total_cart_item"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        if (![currentNodeContent isEqualToString:@""]) {
            if (![currentNodeContent isEqualToString:@"\n"]) {
                [dataDic setObject:currentNodeContent forKey:@"total_cart_item"];
            }
        }
    }
    else if ([elementname isEqualToString:@"product_id"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        if (![currentNodeContent isEqualToString:@""]) {
            key = currentNodeContent;
        }
    }
    else if ([elementname isEqualToString:@"product_quantity"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        if (![currentNodeContent isEqualToString:@""]) {
            NSMutableDictionary* dic = [[UserDefaultManager getValue:@"ProductDetail"] mutableCopy];
            
            if (dic == nil) {
                dic = [NSMutableDictionary new];
            }
            
            [dic setValue:currentNodeContent forKey:key];
            [UserDefaultManager setValue:dic key:@"ProductDetail"];
        }
    }
    
    else if ([elementname isEqualToString:@"datetime"]){
        if ([myPresentView isEqualToString:@"NotificationCenter"]) {
            NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
            [utcDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [utcDateFormatter setTimeZone :[NSTimeZone timeZoneForSecondsFromGMT: 0]];
            
            // utc format
            NSDate *dateInUTC = [utcDateFormatter dateFromString: currentNodeContent];
            
            //        orderHistDataModel.gmtDate=dateInUTC;
            
            
            // offset second
            NSInteger seconds = [[NSTimeZone systemTimeZone] secondsFromGMT];
            
            // format it and send
            NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
            [localDateFormatter setDateFormat:@"dd MMM yyyy - hh:mm a"];
            [localDateFormatter setTimeZone :[NSTimeZone timeZoneForSecondsFromGMT: seconds]];
            
            // formatted string
            NSString *localDate = [localDateFormatter stringFromDate: dateInUTC];
//            NSLog(@"outDateStr %@",localDate);
            
            
            NSArray * arr = [localDate componentsSeparatedByString:@"-"];
            myAddressDataModel.dateValue=[arr objectAtIndex:0];
        }
        //        orderHistDataModel.time=[arr objectAtIndex:1];
    }
    
    else if ([elementname isEqualToString:@"mobileno"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        if (![currentNodeContent isEqualToString:@"\n"]) {
            [dataDic setObject:currentNodeContent forKey:@"mobile"];
            
            [UserDefaultManager setValue:currentNodeContent key:@"mobile"];
        }
    }
    else if ([elementname isEqualToString:@"mobile_no"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        if (![currentNodeContent isEqualToString:@"\n"]) {
            [dataDic setObject:currentNodeContent forKey:@"mobile"];
            
            [UserDefaultManager setValue:currentNodeContent key:@"mobile"];
        }
    }
    
    else if ([elementname isEqualToString:@"email"])
    {
        testStr = currentNodeContent;
        [dataDic setObject:currentNodeContent forKey:@"email"];
        
    }
    else if ([elementname isEqualToString:@"status"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        
        testStr = currentNodeContent;
        testStr = [testStr stringByTrimmingCharactersInSet:
                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        status=testStr;
        [dataDic setObject:currentNodeContent forKey:@"status"];
        
        if ([myPresentView isEqualToString:@"ClearCart"]) {
            [UserDefaultManager removeValue:@"ProductDetail"];
        }
    }
    else if ([elementname isEqualToString:@"message"])
    {
//        NSLog(@"status **** %@",status );
        
        if (![status isEqual:@"1"] && status!=nil)
        {
//            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            testStr = currentNodeContent;
            
            
            if (![myPresentView isEqualToString:@"ClearCart"]){
                [self showAlertMessage:testStr];
            }
        }
        else{
            if ([myPresentView isEqualToString:@"NotificationCenter"]) {
                myAddressDataModel.message = currentNodeContent;
            }
            else{
                [dataDic setObject:currentNodeContent forKey:@"message"];
            }
            
        }
        
    }
    else  if ([elementname isEqualToString:@"SOAP-ENC:Struct"]) {
        if ([myPresentView isEqualToString:@"NotificationCenter"]) {
            [myAddressArray addObject:myAddressDataModel];
        }
    }
    else  if ([elementname isEqualToString:@"notification_message"]) {
        [dataDic setObject:myAddressArray forKey:@"NotificationDetail"];
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
            if ([myPresentView isEqualToString:@"Session"]) {
                [UserDefaultManager removeValue:@"sessionId"];
                [UserDefaultManager removeValue:@"quoteId"];
                [UserDefaultManager removeValue:@"ProductDetail"];
                
            }
            else{
                
                if (![myPresentView isEqualToString:@"ClearCart"]){
                    [self showAlertMessage:testStr];
                }
            }
        }
    }
    /************************** Terms & conditions *******************************************/
    
    else if ([elementname isEqualToString:@"content"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        [dataDic setObject:currentNodeContent forKey:@"content"];
        
    }
    //Club authentication
    
    else if ([elementname isEqualToString:@"cid"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        [dataDic setObject:currentNodeContent forKey:@"cid"];
    }
    
//    else if ([elementname isEqualToString:@"customer_id"])
//    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
//        testStr = currentNodeContent;
//        [dataDic setObject:currentNodeContent forKey:@"customer_id"];
//    }
    else if ([elementname isEqualToString:@"membership_id"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        [dataDic setObject:currentNodeContent forKey:@"membership_id"];
    }

    /************************** My address list *******************************************/
    
    
    
    else if ([elementname isEqualToString:@"customer_address_id"]) {
        myAddressDataModel.customerAddressId = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"city"]) {
        myAddressDataModel.city = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"country_id"]) {
        myAddressDataModel.countryId = currentNodeContent;
        key = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"name"]) {
        //        [myAddressArray addObject:
        [countryCode setObject:currentNodeContent forKey:key];
        //        myAddressDataModel.countryName = currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"firstname"]) {
        if ([myPresentView isEqualToString:@"infoRequest"]) {
            [dataDic setObject:currentNodeContent forKey:@"firstname"];
        }
        else{
            myAddressDataModel.firstname = currentNodeContent;
        }
        
    }
    else if ([elementname isEqualToString:@"street"]) {
        myAddressDataModel.street = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"telephone"]) {
        myAddressDataModel.telephone = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"region"]) {
        myAddressDataModel.state = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"postcode"]) {
        myAddressDataModel.postcode = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"fax"]) {
        myAddressDataModel.latLongStr = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"complexObjectArray"])
    {
        
        if (![myPresentView isEqualToString:@"Country"]) {
            [myAddressArray addObject:myAddressDataModel];
            [dataDic setObject:myAddressArray forKey:@"myaddress"];
        }
        else{
            key = @"";
        }
//        NSLog(@"address list : %@", dataDic);
    }
    
    currentNodeContent=nil;
    
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


-(void)dealloc
{
    parser = nil;
    currentNodeContent =nil;
    
}
@end
