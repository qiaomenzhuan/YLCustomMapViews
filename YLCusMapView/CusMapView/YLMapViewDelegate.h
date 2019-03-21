//
//  YLMapViewDelegate.h
//  MethodSwizzling
//
//  Created by 杨磊 on 2019/3/7.
//  Copyright © 2019年 csda_Chinadance. All rights reserved.
//
#import <UIKit/UIKit.h>

@class YLMapView;
@class YLAnnotation;

/**
 *  YLMapView代理。
 */
@protocol YLMapViewDelegate
@optional
/**
 *  大头针被点击.
 *
 *  @param mapView    被点击的大头针的底图
 *  @param annotation 被点击的大头针.
 */
- (void)mapView:(YLMapView *)mapView tappedOnAnnotation:(YLAnnotation *)annotation;

/**
 *  缩放级别改变.
 *
 *  @param mapView 缩放级别改变的底图.
 *  @param level   新的z缩放级别.
 */
- (void)mapView:(YLMapView *)mapView hasChangedZoomLevel:(CGFloat)level;

@end
