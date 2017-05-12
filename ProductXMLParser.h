//
//  ProductXMLParser.h
//  Digibi_ecommerce
//
//  Created by Monika on 9/22/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductXMLParser : NSObject<NSXMLParserDelegate>
{
    NSXMLParser	*parser;
    NSXMLParser	*bannerParser;
}

@property(nonatomic,retain) NSMutableString	*currentNodeContent;
@property(nonatomic,retain) NSString	*testStr;
@property(nonatomic,retain) NSString	*status;

//Shared instance init
+ (id)sharedManager;
//end
-(id) loadxmlByData:(NSData *)data myView:(NSString*)myView;

@end
