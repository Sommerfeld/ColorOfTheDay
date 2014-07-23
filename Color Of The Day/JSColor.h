//
//  JSColor.h
//  Color Of The Day
//
//  Created by Janik Sommerfeld on 23.07.14.
//  Copyright (c) 2014 Philip Heinser. All rights reserved.
//

#import <Foundation/Foundation.h>

#define colorChangeNotification @"colorChangeNotification"

@interface JSColor : NSObject

@property (weak, nonatomic) UIColor* colorOfTheDay;

+ (UIColor *)getColorOfTheDayFromServer;
+ (UIColor *)lighterColorForColor:(UIColor *)c;
+ (UIColor *)darkerColorForColor:(UIColor *)c;

@end
