//
//  Webservice.m
//  DigiBi
//
//  Created by Sumit on 07/09/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "Webservice.h"
#import "SoapGenerator.h"
#import "Internet.h"


@implementation Webservice
@synthesize webResponseData;
//Shared instance init
+ (id)sharedManager
{
    static Webservice *sharedMyManager = nil;
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

#pragma mark - Webservice method
-(NSData *)fireWebservice:(NSDictionary *)parameters methodName:(NSString *)methodName
{
    NSString *str = [SoapGenerator getSoapString:parameters methodName:methodName];
//    NSLog(@"SOAP request is %@",str);
    
    NSData * data =[self callSoapWebservice:str];
    return data;
}
-(NSData *)fireWebserviceWithArray:(NSDictionary *)parameters methodName:(NSString *)methodName
{
    NSString *str = [SoapGenerator getSoapStringWithArray:parameters methodName:methodName];
//    NSLog(@"SOAP request is %@",str);
    
    NSData * data =[self callSoapWebservice:str];
    return data;
}
-(NSData *)callSoapWebservice :(NSString *)soapStr
{
    NSURL *sRequestURL = [NSURL URLWithString:BASE_URL];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapStr length]];
    [myRequest setValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest setValue: @"urn:Magento" forHTTPHeaderField:@"SOAPAction"];
    [myRequest setValue: sMessageLength forHTTPHeaderField:@"Content-Length"];

//    [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [myRequest addValue: @"urn:Magento" forHTTPHeaderField:@"SOAPAction"];
//    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapStr dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *response = NULL;
    NSError *requestError = NULL;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:myRequest returningResponse:&response error:&requestError];
//    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//   NSLog(@"SOAP response is **%@",responseString);
    return responseData;
}
#pragma mark - end
@end
