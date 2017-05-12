//
//  OrderXMLParser.m
//  Digibi_ecommerce
//
//  Created by Monika on 9/22/15.
//  Copyright (c) 2015 Ranosys. All rights reserved.
//

#import "OrderXMLParser.h"
#import "OrderHistoryDataModel.h"
#import "ClubDataModel.h"
#import "OrderDetailModel.h"
#import "CheckoutDataModel.h"
@implementation OrderXMLParser
{
    NSMutableDictionary *dataDic;
    NSMutableArray *orderHistoryArray;
    NSMutableArray *clubListingArray;
    NSMutableArray *orderDetailArray;
    NSMutableArray *mainDetailArray;
    NSMutableArray *checkoutArray;
    NSString *key,*value;
    OrderHistoryDataModel *orderHistDataModel;
    CheckoutDataModel *checkDataModel;
    
    ClubDataModel *clubModel;
    OrderDetailModel *orderDetailData;//this also use for MyCart
    
    
    NSMutableDictionary *detailDic;
    NSString *tagType;
    NSString *itemTag;
    
    NSMutableArray *clubArray;
    
    NSString *presentView;
    double priceCalculation;
    NSString *message;
    
}
@synthesize currentNodeContent,testStr,status;

+ (id)sharedManager
{
    static OrderXMLParser *sharedMyManager = nil;
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

-(id)loadxmlByData:(NSData *)data presentView:(NSString *)myView
{
    presentView=myView;
    status=nil;
    key = @"";
    value = @"";
    
    [dataDic removeAllObjects];
    if ([presentView isEqualToString:@"orderDetail"]||[presentView isEqualToString:@"myCart"]) {
        mainDetailArray=[[NSMutableArray alloc]init];
    }
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
    if ([presentView isEqualToString:@"club"]){
        if (![status isEqual:@"1"] && status!=nil)
        {
            [self showAlertMessage:message];
        }
    }
    
//    if ([presentView isEqualToString:@"checkout"])
//    {
//        return dataDic;
//        
//        //return checkoutArray;
//    }
//    else
//    {
        return dataDic;
        
    //}
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementname isEqualToString:@"result"])
    {
        if ([presentView isEqualToString:@"orderHistory"])
        {
            orderHistoryArray=[[NSMutableArray alloc]init];
        }
        else if ([presentView isEqualToString:@"checkout"])
        {
            //            checkoutArray=[[NSMutableArray alloc]init];
        }
    }
    else if ([elementname isEqualToString:@"complexObjectArray"])
    {
        if ([presentView isEqualToString:@"checkout"])
        {
            checkDataModel=[[CheckoutDataModel alloc]init];
        }
//        else
//        {
//            orderHistDataModel=[[OrderHistoryDataModel alloc]init];
//        }
    }
    else if ([elementname isEqualToString:@"shippingMethodList"])
    {
        if ([presentView isEqualToString:@"checkout"])
        {
            checkoutArray=[[NSMutableArray alloc]init];
        }
    }
    else if ([elementname isEqualToString:@"paymentMethodList"])
    {
        if ([presentView isEqualToString:@"checkout"])
        {
            checkoutArray=[[NSMutableArray alloc]init];
        }
    }
    
    
    else if ([elementname isEqualToString:@"clubList"])
    {
        clubListingArray=[[NSMutableArray alloc]init];
    }
    else if ([elementname isEqualToString:@"items"])
    {
        if ([presentView isEqualToString:@"orderDetail"]||[presentView isEqualToString:@"myCart"])
        {
            itemTag=@"items";
        }
    }
    else if ([elementname isEqualToString:@"BOGUS"])
    {
        if ([presentView isEqualToString:@"club"])
        {
            clubModel=[[ClubDataModel alloc]init];
        }
        else  if ([presentView isEqualToString:@"orderDetail"]||[presentView isEqualToString:@"myCart"])
        {
            detailDic = [NSMutableDictionary new];
            if ([presentView isEqualToString:@"myCart"]) {
                priceCalculation = 0.0;
            }
            tagType = @"BOGUS";
        }
    }
    
    //Details order
    else if ([elementname isEqualToString:@"product_details"])
    {
        orderDetailArray = [NSMutableArray new];
    }
    else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
    {
        if ([presentView isEqualToString:@"checkout"])
        {
            checkDataModel=[[CheckoutDataModel alloc]init];
        }
        else if([presentView isEqualToString:@"orderHistory"])
        {
            orderHistDataModel=[[OrderHistoryDataModel alloc]init];
        }
        else
        {
            orderDetailData = [OrderDetailModel new];
        }
        
        tagType = @"SOAP-ENC:Struct";
    }
    else if ([elementname isEqualToString:@"shipping_address"])
    {
        orderDetailData = [OrderDetailModel new];
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
    
    
    //***************************** Order history ********************************
    if ([elementname isEqualToString:@"is_club"]) {
//        NSLog(@"isclub");
    }
    if ([elementname isEqualToString:@"result"])
    {
        
        if ([presentView isEqualToString:@"orderHistory"])
        {
//            NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
            testStr = currentNodeContent;
            [dataDic setObject:currentNodeContent forKey:@"result"];
        }
        else  if ([presentView isEqualToString:@"QuoteId"]) {
            [UserDefaultManager setValue:currentNodeContent key:@"quoteId"];
        }
        else if ([presentView isEqualToString:@"AddCart"]) {
            [dataDic setObject:currentNodeContent forKeyedSubscript:@"result"];
        }
        [dataDic setObject:currentNodeContent forKeyedSubscript:@"result"];
    }
    
    else if ([elementname isEqualToString:@"increment_id"])
    {
        orderHistDataModel.OrderId=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"payment_method"])
    {
        orderHistDataModel.paymentMethod=currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"subtotal"])
    {
        orderHistDataModel.subTotal=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"discount_amount"])
    {
        orderHistDataModel.discount=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"shipping_amount"])
    {
        orderHistDataModel.charges=currentNodeContent;
    }

    else if ([elementname isEqualToString:@"created_at"])
    {
        orderHistDataModel.dateAndTime=currentNodeContent;
        
        
        //        //Convert UTC time format to GMT
        //        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //        [dateFormat setDateFormat:@"yyyy-mm-dd hh:mm:ss"];
        //        NSDate *UTCdate = [dateFormat dateFromString:currentNodeContent];
        //
        //        NSDate *someDateInUTC = UTCdate;
        //        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
        //        NSDate *GMTdate = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
        //        orderHistDataModel.gmtDate=GMTdate;
        //
        //        // Convert date object to desired output format
        //        [dateFormat setDateFormat:@"dd MMM yyyy - hh.mm a"];
        //        NSString *  dateStr = [dateFormat stringFromDate:GMTdate];
        //        NSLog(@"local date and time %@",dateStr);
        
        //UTC time
        NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
        [utcDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [utcDateFormatter setTimeZone :[NSTimeZone timeZoneForSecondsFromGMT: 0]];
        
        // utc format
        NSDate *dateInUTC = [utcDateFormatter dateFromString: currentNodeContent];
        
        orderHistDataModel.gmtDate=dateInUTC;
        
        
        // offset second
        NSInteger seconds = [[NSTimeZone systemTimeZone] secondsFromGMT];
        
        // format it and send
        NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
        [localDateFormatter setDateFormat:@"dd MMM yyyy - hh:mm a"];
        [localDateFormatter setTimeZone :[NSTimeZone timeZoneForSecondsFromGMT: seconds]];
        
        // formatted string
        NSString *localDate = [localDateFormatter stringFromDate: dateInUTC];
//        NSLog(@"outDateStr %@",localDate);
        
        
        
        NSArray * arr = [localDate componentsSeparatedByString:@"-"];
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"HH:mm a";
//        NSDate *date = [dateFormatter dateFromString:[arr objectAtIndex:1]];
//        
//        dateFormatter.dateFormat = @"hh:mm a";
//        NSString *pmamDateString = [dateFormatter stringFromDate:date];
//        
        
        orderHistDataModel.date=[arr objectAtIndex:0];
        orderHistDataModel.time=[arr objectAtIndex:1];
        
    }
    else if ([elementname isEqualToString:@"grand_total"])
    {
        orderHistDataModel.grandTotal=currentNodeContent;
        
    }
    
    else if ([elementname isEqualToString:@"order_currency_code"])
    {
        orderHistDataModel.currencyCode=currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"shipping_method"])
    {
        orderHistDataModel.method=currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"shipping_description"])
    {
        orderHistDataModel.shippingType=currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"status"])
    {
        [dataDic setObject:currentNodeContent forKey:@"status"];
        
        if ([presentView isEqualToString:@"orderHistory"])
        {
            testStr = currentNodeContent;
            orderHistDataModel.status=currentNodeContent;
            
            testStr = [testStr stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        status=currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"complexObjectArray"])
    {
//        if ([presentView isEqualToString:@"orderHistory"])
//        {
//            [orderHistoryArray addObject:orderHistDataModel];
//            [dataDic setObject:orderHistoryArray forKey:@"orderHistory"];
//            
//        }
//        else 
        
            if ([presentView isEqualToString:@"checkout"])
        {
            [checkoutArray addObject:checkDataModel];
            
        }
    }
    
    //***************************** Order Detail ********************************
    
    else if ([elementname isEqualToString:@"shoptitle"])
    {
        if ([tagType isEqualToString:@"BOGUS"]){
            [detailDic setObject:currentNodeContent forKey:@"shoptitle"];
        }
        else{
            orderDetailData.shoptitle  = currentNodeContent;
            
        }
        clubModel.shoptitle=currentNodeContent;
        
    }
    else  if ([elementname isEqualToString:@"method"])
    {
        [dataDic setObject:currentNodeContent forKey:@"paymentMethod"];

    }

    else  if ([elementname isEqualToString:@"vendor_id"])
    {
        if ([tagType isEqualToString:@"BOGUS"]){
            [detailDic setObject:currentNodeContent forKey:@"vendor_id"];
        }
        else{
            orderDetailData.vendorId  = currentNodeContent;
            
        }
    }
    
    else  if ([elementname isEqualToString:@"latitude"])
    {
        if ([tagType isEqualToString:@"BOGUS"]){
            [detailDic setObject:currentNodeContent forKey:@"latitude"];
        }
        else{
            orderDetailData.latitude  = currentNodeContent;
            
        }
    }
    
    else  if ([elementname isEqualToString:@"longitude"])
    {
        if ([tagType isEqualToString:@"BOGUS"]){
            [detailDic setObject:currentNodeContent forKey:@"longitude"];
        }
        else{
            orderDetailData.longitude  = currentNodeContent;
            
        }
    }
    
    else  if ([elementname isEqualToString:@"longitude"])
    {
        if ([tagType isEqualToString:@"BOGUS"]){
            [detailDic setObject:currentNodeContent forKey:@"longitude"];
        }
        else{
            orderDetailData.longitude  = currentNodeContent;
            
        }
    }
    
    else  if ([elementname isEqualToString:@"is_club"])
    {
        if ([tagType isEqualToString:@"BOGUS"]){
            [detailDic setObject:currentNodeContent forKey:@"is_club"];

        }
        //        orderDetailData.isClub = currentNodeContent;
    }
    else  if ([elementname isEqualToString:@"is_open"])
    {
        if ([tagType isEqualToString:@"BOGUS"]){
            [detailDic setObject:currentNodeContent forKey:@"is_open"];
//            orderDetailData.isClose  = currentNodeContent;

        }
    }

    else if ([elementname isEqualToString:@"name"])
    {
        orderDetailData.productName  = currentNodeContent;
        orderDetailData.shoptitle = [detailDic objectForKey:@"shoptitle"];
    }
    
    else if ([elementname isEqualToString:@"qty"])
    {
        orderDetailData.quantity  = currentNodeContent;
    }
    else if ([elementname isEqualToString:@"qty_ordered"])
    {
        orderDetailData.productQuantity  = currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"product_is_in_stock"])
    {
        orderDetailData.isInStock  = currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"items_count"])
    {
        orderDetailData.itemsCount  = currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"currency_symbol"])
    {
        //        quote_currency_code
        if ([presentView isEqualToString:@"myCart"]) {
            if (([detailDic objectForKey:@"currency"] == nil) || [[detailDic objectForKey:@"currency"] isEqualToString:@""]) {
                [detailDic setObject:currentNodeContent forKey:@"currency"];
            }
            
        }
        
        orderDetailData.productCurrencyCode  = currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"product_image"]) {
        orderDetailData.productImage  = currentNodeContent;
        
    }
    
    else if ([elementname isEqualToString:@"sku"]) {
        orderDetailData.sku  = currentNodeContent;
        
    }
    
    else if ([elementname isEqualToString:@"product_id"]) {
        orderDetailData.productId  = currentNodeContent;
        
    }
    
    else if ([elementname isEqualToString:@"price"])
    {
        if ([presentView isEqualToString:@"checkout"]) {
            checkDataModel.price=currentNodeContent;
        }
        else{
            orderDetailData.price  = currentNodeContent;
        }
        
    }
    
    else if ([elementname isEqualToString:@"product_available_stock"])
    {
        orderDetailData.availableQuantity  = currentNodeContent;
        
    }
    
    else if ([elementname isEqualToString:@"items"])
    {
        itemTag=@"";
    }
    
    else if ([elementname isEqualToString:@"BOGUS"])
    {
        if ([presentView isEqualToString:@"orderDetail"]||[presentView isEqualToString:@"myCart"])
        {
            if ([itemTag isEqualToString:@"items"])
            {
                if ([presentView isEqualToString:@"myCart"]) {
                    
                    [detailDic setObject:[NSString stringWithFormat:@"%.2f", priceCalculation] forKey:@"calculatedPrice"];
                }
                
                [mainDetailArray addObject:detailDic];
                
                //                if ([presentView isEqualToString:@"orderDetail"]) {
                
                [dataDic setObject:mainDetailArray forKey:@"orderDetail"];
                //                }
            }
        }
        else if ([presentView isEqualToString:@"club"])
        {
            [clubListingArray addObject:clubModel];
            [dataDic setObject:clubListingArray forKey:@"clubList"];
        }
        
    }
    
    else if ([elementname isEqualToString:@"product_details"])
    {
        [detailDic setObject:orderDetailArray forKey:@"productDetails"];
    }
    
    else if ([elementname isEqualToString:@"SOAP-ENC:Struct"])
    {
        if ([itemTag isEqualToString:@"items"])
        {
            if ([presentView isEqualToString:@"myCart"]) {
                
                priceCalculation = priceCalculation + [orderDetailData.price doubleValue] * [orderDetailData.quantity doubleValue];
            }
        }
        //        [orderDetailArray addObject:orderDetailData];
        
        if ([presentView isEqualToString:@"checkout"])
        {
            [checkoutArray addObject:checkDataModel];
        }
        else   if ([presentView isEqualToString:@"orderHistory"])
        {
            [orderHistoryArray addObject:orderHistDataModel];
            [dataDic setObject:orderHistoryArray forKey:@"orderHistory"];
            
        }
        else
        {
            [orderDetailArray addObject:orderDetailData];
        }
    }
    //Detail address
    else if ([elementname isEqualToString:@"firstname"])
    {
        orderDetailData.firstname=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"middlename"])
    {
        orderDetailData.middlename=currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"lastname"])
    {
        orderDetailData.lastname=currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"street"])
    {
        orderDetailData.street=currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"city"])
    {
        orderDetailData.city=currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"postcode"])
    {
        orderDetailData.postcode=currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"region"])
    {
        orderDetailData.region=currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"fax"])
    {
        orderDetailData.latLongStr=currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"address_id"])
    {
        orderDetailData.addressId=currentNodeContent;
        
    }
    else if ([elementname isEqualToString:@"telephone"])
    {
        orderDetailData.telephone=currentNodeContent;
        
    }
    
    else if ([elementname isEqualToString:@"shipping_address"])
    {
        [dataDic setObject:orderDetailData forKey:@"shipping_address"];
    }
    
    //***************************** Club listing ********************************
    else if ([elementname isEqualToString:@"entity_id"])
    {
        clubModel.entityId=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"email"])
    {
        clubModel.email=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"is_active"])
    {
        clubModel.isActive=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"isclub"])
    {
        clubModel.isClub=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"clubcode"])
    {
        clubModel.clubcode=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"complocality"])
    {
        clubModel.complocality=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"countrypic"])
    {
        clubModel.countrypic=currentNodeContent;
    }
    
    //***************************** Club authentication ********************************
    else if ([elementname isEqualToString:@"countrypic"])
    {
        clubModel.countrypic=currentNodeContent;
    }
    
    else if ([elementname isEqualToString:@"cid"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        [dataDic setObject:currentNodeContent forKey:@"cid"];
    }
    
    else if ([elementname isEqualToString:@"customer_id"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        [dataDic setObject:currentNodeContent forKey:@"customer_id"];
    }
    else if ([elementname isEqualToString:@"membership_id"])
    {
//        NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
        testStr = currentNodeContent;
        [dataDic setObject:currentNodeContent forKey:@"membership_id"];
    }
    
    //***************************** Checkout(get shipping types) ********************************
    //    else if ([elementname isEqualToString:@"code"])
    //    {
    //        checkDataModel.code=currentNodeContent;
    //    }
    //    else if ([elementname isEqualToString:@"carrier"])
    //    {
    //        checkDataModel.carrier=currentNodeContent;
    //    } else if ([elementname isEqualToString:@"carrier_title"])
    //    {
    //        checkDataModel.carrierTitle=currentNodeContent;
    //    } else if ([elementname isEqualToString:@"method"])
    //    {
    //        checkDataModel.method=currentNodeContent;
    //    }
    //    else if ([elementname isEqualToString:@"method_title"])
    //    {
    //        checkDataModel.methodTitle=currentNodeContent;
    //    }
    //      else if ([elementname isEqualToString:@"cc_types"])
    //    {
    //        checkDataModel.ccTypes=currentNodeContent;
    //    }
    
    //Shipping types
    else if ([elementname isEqualToString:@"shippingCode"])
    {
        checkDataModel.shippingCode=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"label"])
    {
        checkDataModel.label=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"methodName"])
    {
        checkDataModel.methodName=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"shippingMethodList"])
    {
        [dataDic setObject:checkoutArray forKey:@"shippingMethodList"];
    }
    
    //Payment types
    else if ([elementname isEqualToString:@"paymentCode"])
    {
        checkDataModel.paymentCode=currentNodeContent;
    }
    else if ([elementname isEqualToString:@"paymentMethodList"])
    {
        [dataDic setObject:checkoutArray forKey:@"paymentMethodList"];
    }
    
    //Cart totals
    else if ([elementname isEqualToString:@"title"])
    {
        checkDataModel.title=currentNodeContent;
        key = currentNodeContent;
        if ([key containsString:@"Discount"])
        {
            [dataDic setObject:currentNodeContent forKey:@"DiscountTitle"];
        }

    }
    else if ([elementname isEqualToString:@"amount"])
    {
        if ([key containsString:@"Discount"])
        {
            key=@"discount";
        }
        if ([key containsString:@"Shipping"])
        {
            key=@"Shipping";
        }
        
        if ([key isEqualToString:@"Subtotal"])
        {
            [dataDic setObject:currentNodeContent forKey:@"subTotal"];
        }
        else  if ([key containsString:@"Grand Total"])
        {
            [dataDic setObject:currentNodeContent forKey:@"Grand Total"];
            
        }
        else  if ([key isEqualToString:@"discount"])
        {
            [dataDic setObject:currentNodeContent forKey:@"discount"];
        }
        else  if ([key isEqualToString:@"Shipping"])
        {
            [dataDic setObject:currentNodeContent forKey:@"Shipping"];
            
        }
    }
    //Min cart values
    else  if ([elementname isEqualToString:@"ship_express_delivery_min_order_value"])
    {
        [dataDic setObject:currentNodeContent forKey:@"ship_express_delivery_min_order_value"];
    }
    else  if ([elementname isEqualToString:@"ship_normal_delivery_min_order_value_single"])
    {
        [dataDic setObject:currentNodeContent forKey:@"ship_normal_delivery_min_order_value_single"];
    }
    else  if ([elementname isEqualToString:@"ship_normal_delivery_min_order_value_multi"])
    {
        [dataDic setObject:currentNodeContent forKey:@"ship_normal_delivery_min_order_value_multi"];
    }
    else  if ([elementname isEqualToString:@"ship_big_order_min_order_value"])
    {
        [dataDic setObject:currentNodeContent forKey:@"ship_big_order_min_order_value"];
    }
    else  if ([elementname isEqualToString:@"club_min_order_value"])
    {
        [dataDic setObject:currentNodeContent forKey:@"club_min_order_value"];
    }
    //Magento current time
    
    else  if ([elementname isEqualToString:@"magento_currenttime"])
    {
        [dataDic setObject:currentNodeContent forKey:@"magento_currenttime"];
    }
    
    //***************************** Thank You (Clear cart) ********************************
    
    else  if ([elementname isEqualToString:@"newQuoteId"])
    {
        [dataDic setObject:currentNodeContent forKey:@"newQuoteId"];
    }
    
    //***************************** status ********************************
    else if ([elementname isEqualToString:@"message"])
    {
//        NSLog(@"status **** %@",status );
        if (![presentView isEqualToString:@"AddCart"]) {
            [dataDic setObject:currentNodeContent forKey:@"message"];
            
            if (![status isEqual:@"1"] && status!=nil)
            {
                if (![presentView isEqualToString:@"club"]){
//                    NSLog(@"currentNodeContent is --------------- %@",currentNodeContent);
                    testStr = currentNodeContent;
                    [self showAlertMessage:testStr];
                }
                else{
                    message = currentNodeContent;
                }
            }
        }
        else{
            [dataDic setObject:currentNodeContent forKey:@"message"];
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
        else
        {
            if (![presentView isEqualToString:@"AddCart"]) {
                
                [self showAlertMessage:testStr];
            }
            else{
                if (![status isEqualToString:@""] && status!=nil)
                {
                    [dataDic setObject:currentNodeContent forKey:@"faultstring"];
                }
                else{
                    [self showAlertMessage:testStr];
                }
                
            }
            
        }
    }        currentNodeContent=nil;
    
}


-(void)showAlertMessage:(NSString *)messageText
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert"
                                          message:messageText
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


#pragma mark - end

@end
