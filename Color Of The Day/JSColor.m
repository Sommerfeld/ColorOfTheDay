//
//  JSColor.m
//  Color Of The Day
//
//  Created by Janik Sommerfeld on 23.07.14.
//  Copyright (c) 2014 Philip Heinser. All rights reserved.
//

#import "JSColor.h"

@implementation JSColor

#define lastColorOfTheDay @"lastColorOfTheDay"

- (UIColor *)colorOfTheDay
{
    if (!_colorOfTheDay) {
        _colorOfTheDay = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:lastColorOfTheDay]];
    }
    
    return _colorOfTheDay;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:colorChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            NSData *colorArchiveData = [[NSUserDefaults standardUserDefaults] objectForKey:lastColorOfTheDay];
            self.colorOfTheDay = [NSKeyedUnarchiver unarchiveObjectWithData:colorArchiveData];
        }];
    }
    return self;
}

+ (UIColor *)getColorOfTheDayFromServer
{
    
    NSURL* getColorURL = [[NSURL alloc] initWithString:@"http://coloroftheday.herokuapp.com/color"] ;
    NSMutableURLRequest* colorRequest = [[NSMutableURLRequest alloc] initWithURL:getColorURL];
    
    [colorRequest addValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSData* colorData = [NSURLConnection sendSynchronousRequest:colorRequest returningResponse:nil error:nil];
    
    UIColor* colorOfTheDay = [self colorWithData:colorData];
    
    NSData *colorArchiveData = [NSKeyedArchiver archivedDataWithRootObject:colorOfTheDay];
    
    [[NSUserDefaults standardUserDefaults] setObject:colorArchiveData forKey:lastColorOfTheDay];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:colorChangeNotification object:nil];
    
    return colorOfTheDay;
}

+ (UIColor*)colorWithData:(NSData*)data
{
    UIColor* colorOfTheDay;
    
    if (data) {
        NSDictionary* colorDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
        NSNumber* colorRed = colorDictionary[@"red"];
        NSNumber* colorGreen = colorDictionary[@"green"];
        NSNumber* colorBlue = colorDictionary[@"blue"];
    
        colorOfTheDay = [[UIColor alloc] initWithRed:colorRed.intValue/255. green:colorGreen.intValue/255. blue:colorBlue.intValue/255. alpha:1];
    }
    
    return colorOfTheDay;
}

+ (UIColor *)lighterColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.1, 1.0)
                               green:MIN(g + 0.1, 1.0)
                                blue:MIN(b + 0.1, 1.0)
                               alpha:a];
    return nil;
}

+ (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}

@end
