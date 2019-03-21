//
//  YLAnnotation.h
//  MethodSwizzling
//
//  Created by 杨磊 on 2019/3/7.
//  Copyright © 2019年 csda_Chinadance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "YLMapViewDelegate.h"

@class YLMapView;
//底图上的大头针
NS_ASSUME_NONNULL_BEGIN

@interface YLAnnotation : NSObject

/**
 根据坐标创建大头针 类方法

 @param point 坐标
 @return 实例对象
 */
+ (id)annotationWithPoint:(CGPoint)point;

/**
 根据坐标创建大头针 实例方法

 @param point 坐标
 @return 实例对象
 */
- (id)initWithPoint:(CGPoint)point;

/**
 在底图上添加大头针

 @param mapView 底图
 @param animate 是否动画
 */
- (void)addToMapView:(YLMapView *)mapView animated:(BOOL)animate;

/**
 从底图上移除大头针
 */
- (void)removeFromMapView;

/**
 更新大头针位置
 */
- (void)updatePosition;


/**
 子类需要重写 在大头针上添加自定义view

 @param mapView 底图
 @return 自定义大头针
 */
- (UIView *)createViewOnMapView:(YLMapView *)mapView;

@property (nonatomic, weak) NSObject<YLMapViewDelegate> *mapViewDelegate;

/**
 当前大头针属于的底图
 */
@property (nonatomic, readonly, weak) YLMapView *mapView;

/**
 底图上的坐标
 */
@property (nonatomic, assign) CGPoint point;

/**
 添加在底图上的view
 */
@property (nonatomic, readonly) UIView *view;

@end

NS_ASSUME_NONNULL_END
