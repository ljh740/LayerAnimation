//
//  ViewController.m
//  LayerAnimation
//
//  Created by jie on 2020/5/26.
//  Copyright © 2020 jie. All rights reserved.
//
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]

#import "ViewController.h"

@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic,assign)CAGradientLayer *gradientLayer;

@property (nonatomic,strong) NSMutableArray *colors;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 200, 50);
    [self.view addSubview:btn];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 25.f;
    [btn setTitle:@"start" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    CAGradientLayer *layer = CAGradientLayer.new;
    layer.frame = btn.bounds;
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);
    // 渐变颜色
    self.colors = [NSMutableArray arrayWithArray: @[
        (id)RGB_COLOR(159, 72, 251).CGColor,
        (id)RGB_COLOR(255, 92, 137).CGColor,
        (id)RGB_COLOR(255, 150, 122).CGColor
    ]];
    
    layer.colors = self.colors.copy;
    
    // 分割点
    NSMutableArray *locations = [NSMutableArray arrayWithObject:@0];
    NSInteger count = self.colors.count;
    for (int i = 1; i < count; i++) {
        [locations addObject:[NSNumber numberWithFloat:i/(count - 1.f)]];
    }
    layer.locations =locations;
    self.gradientLayer = layer;
    [btn.layer addSublayer:layer];
    
}

- (void)onClickButton:(UIButton *)sender {
    if (!sender.selected) {
        [sender setTitle:nil forState:UIControlStateNormal];
        sender.selected = YES;
        [self gradientAnimation];
    }
}

/// 动画生成
- (void)gradientAnimation {
    // 将最后一个颜色移到第一个
    NSMutableArray *colors = self.colors;
    NSArray *startColors = self.colors.copy;
    id obj = colors.lastObject;
    [colors removeObject:obj];
    [colors insertObject:obj atIndex:0];
    NSArray *endColors = self.colors.copy;
    
    // 生成动画事件
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.duration = 1.f;
    animation.fromValue = startColors;
    animation.toValue = endColors;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [self.gradientLayer addAnimation:animation forKey:@"animateGradient"];
    
}

#pragma mark - CAAnimationDelegate
/* Called when the animation begins its active duration. */

- (void)animationDidStart:(CAAnimation *)anim {
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 结束后回调继续加载
    return [self gradientAnimation];
}

@end
