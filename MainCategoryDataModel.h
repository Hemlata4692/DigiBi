//
//  MainCategoryDataModel.h
//  Digibi_ecommerce
//
//  Created by Monika on 11/3/15.
//  Copyright © 2015 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainCategoryDataModel : NSObject
@property(nonatomic,retain)NSString * entityId;
@property(nonatomic,retain)NSString * parentId;
@property(nonatomic,retain)NSString * description;
@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)NSString * image;
@property(nonatomic,retain)NSString * position;
@property(nonatomic,retain)NSString * presentTag;
@property(nonatomic,retain)NSString * isActive;


@end
