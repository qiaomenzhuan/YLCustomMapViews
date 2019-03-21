//
//  YLPinAnnotation.m
//  SportChina
//
//  Created by 杨磊 on 2019/3/14.
//  Copyright © 2019年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "YLPinAnnotation.h"
#import "YLPinAnnotationView.h"

@interface YLPinAnnotation()

@property (nonatomic, readonly, weak) YLPinAnnotationView *view;

@end

@implementation YLPinAnnotation

@dynamic view;

- (id)initWithPoint:(CGPoint)point
{
    self = [super initWithPoint:point];
    if (self)
    {
    }
    return self;
}

- (UIView *)createViewOnMapView:(YLMapView *)mapView
{   //继承自父类 创建view显示在地图上的方法 必须重写
    return [[YLPinAnnotationView alloc] initWithAnnotation:self onMapView:mapView];
}

- (void)addToMapView:(YLMapView *)mapView animated:(BOOL)animate
{//添加点标动画
    [super addToMapView:mapView animated:animate];
    if (animate) {
        CGRect frame = self.view.frame;
        frame.origin.y -= 1000;
        self.view.frame = frame;
        frame.origin.y += 1000;
        __weak typeof(self) weakSelf = self;
        CGFloat duration = (CGFloat)(arc4random()%10 + 5.f)/10.f;
        [UIView animateWithDuration:0.5 delay:duration options:UIViewAnimationOptionTransitionCurlDown animations:^{
            weakSelf.view.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)updatePosition
{
    [self.view updatePosition];
}

@end
