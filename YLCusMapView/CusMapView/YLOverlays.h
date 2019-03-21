//
//  YLOverlays.h
//  MethodSwizzling
//
//  Created by 杨磊 on 2019/3/7.
//  Copyright © 2019年 csda_Chinadance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLMapViewDelegate.h"

@class YLMapView;

NS_ASSUME_NONNULL_BEGIN

@interface YLOverlays : NSObject

/// Create an line at a given lines.

/**
 给定两个端点坐标 创建一个线段 类方法

 @param lines 两个坐标
 @return 线段对象
 */
+ (id)overlaysWithLine:(NSArray<NSString *> *)lines;

/**
 给定两个端点坐标 创建一个线段 实例方法
 
 @param lines 两个坐标
 @return 线段对象
 */
- (id)initWithLine:(NSArray<NSString *> *)lines;


/**
 往底图上添加一个i线段

 @param mapView 底图
 @param animate 是否动画
 */
- (void)addToMapView:(YLMapView *)mapView animated:(BOOL)animate;

/**
 移除线段
 */
- (void)removeFromMapView;

/**
 更新端点坐标
 */
- (void)updatePosition;

@property (nonatomic, weak) NSObject<YLMapViewDelegate> *mapViewDelegate;


/**
 当前线段属于的底图
 */
@property (nonatomic, readonly, weak) YLMapView *mapView;

/**
 线段数组
 */
@property (nonatomic, copy) NSArray<NSString *>* lines;

/**
 添加在底图上的view
 */
@property (nonatomic, readonly) UIView *view;

/**
 线的宽度
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 线的间隙 为0的话就是实线 大于0就是虚线
 */
@property (nonatomic, assign) CGFloat lineSpace;

/**
 虚线的长度
 */
@property (nonatomic, assign) CGFloat lineLength;

/**
 线的颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

@end

NS_ASSUME_NONNULL_END
