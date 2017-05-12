//
//  UIButton+ButtonBorder.m
//  Sure
//
//  Created by Hema on 16/04/15.
//  Copyright (c) 2015 Shivendra. All rights reserved.
//

#import "UIButton+ButtonBorder.h"

@implementation UIButton (ButtonBorder)

-(void)addBorder: (UIButton *)button
{
    
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:[UIColor colorWithRed:132.0/255.0 green:167.0/255.0 blue:0.0/255.0 alpha:1.0].CGColor];
}


@end
