//
//  JSViewController.m
//  Color Of The Day
//
//  Created by Janik Sommerfeld on 23.07.14.
//  Copyright (c) 2014 Philip Heinser. All rights reserved.
//

#import "JSViewController.h"

#import "JSColor.h"

@interface JSViewController ()

@property (nonatomic) JSColor* color;
@property (nonatomic) CAGradientLayer* backgroundLayer;

@end

@implementation JSViewController

- (CAGradientLayer *)backgroundLayer
{
    if (!_backgroundLayer) {
        _backgroundLayer = [CAGradientLayer layer];
        _backgroundLayer.frame = self.view.bounds;
        _backgroundLayer.locations = @[@(0),@(1)];
    }
    
    return _backgroundLayer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.color = [[JSColor alloc] init];
    
    [self setBackgroundColorWithMainColor:self.color.colorOfTheDay];
    
    [self.color addObserver:self forKeyPath:@"colorOfTheDay" options:NSKeyValueObservingOptionNew context:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // resize your layers based on the view’s new bounds
    self.backgroundLayer.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"colorOfTheDay"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setBackgroundColorWithMainColor:self.color.colorOfTheDay];
        });
        
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setBackgroundColorWithMainColor:(UIColor *)mainColor
{
    [self.backgroundLayer removeFromSuperlayer];
    
    UIColor* lighterColor = [JSColor lighterColorForColor:mainColor];
    UIColor* darkerColor = [JSColor darkerColorForColor:mainColor];
    
    if (lighterColor && darkerColor) {
        self.backgroundLayer.colors = @[(id)lighterColor.CGColor, (id)darkerColor.CGColor];
        
        [self.view.layer insertSublayer:self.backgroundLayer atIndex:0];
    }

}



@end
