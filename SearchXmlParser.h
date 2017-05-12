//
//  SearchXmlParser.h
//  Digibi_ecommerce
//
//  Created by Ranosys on 20/11/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchXmlParser : NSObject<NSXMLParserDelegate>
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
-(id) loadxmlByData:(NSData *)data;



@end
