//
//  YLMapView.h
//  MethodSwizzling
//
//  Created by 杨磊 on 2019/3/7.
//  Copyright © 2019年 csda_Chinadance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLMapViewDelegate.h"
#import "YLOverlays.h"
#import "YLAnnotation.h"

//以一张图片为底图，可以进行缩放、双击等操作，可以添加点标、添加连线。
NS_ASSUME_NONNULL_BEGIN

@interface YLMapView : UIScrollView<UIScrollViewDelegate>

/**
 切片加载底图

 @param size 图片的像素尺寸
 @param path 图片的沙盒路径
 @param count 图片切片个数 大图内存吃不消 要进行切片重绘
 */
- (void)displayMap:(CGSize)size andImagePath:(NSString *)path withCount:(NSInteger)count;

/**
 回到当前底图的中心

 @param animated 是否动画
 */
- (void)scrollToCenter:(BOOL)animated;

/**
 向底图上添加一个大头针

 @param annotation 大头针对象
 @param animate 是否动画
 */
- (void)addAnnotation:(YLAnnotation *)annotation animated:(BOOL)animate;

/**
 向底图上添加一组大头针

 @param annotations 大头针对象数组
 @param animate 是否动画
 */
- (void)addAnnotations:(NSArray *)annotations animated:(BOOL)animate;

/**
 移除一个大头针

 @param annotation 是否动画
 */
- (void)removeAnnotation:(YLAnnotation *)annotation;


/**
 移除所有点标
 */
- (void)removeAllAnnotaions;
/**
 底图不同缩放级别下 大头针位置的转换

 @param point 原始坐标
 @return 转换后的坐标
 */
- (CGPoint)zoomRelativePoint:(CGPoint)point;

/**
 选中一个大头针

 @param annotation 大头针
 @param animate 是否动画
 */
- (void)selectAnnotation:(YLAnnotation *)annotation animated:(BOOL)animate;

/**
 让一个point处于屏幕中央

 @param point 坐标
 @param animate 是否动画
 */
- (void)centerOnPoint:(CGPoint)point animated:(BOOL)animate;

/**
 让底图的中心处于这个point

 @param point 坐标
 @param animate 是否动画
 */
- (void)updateContentOffsetToCenterPoint:(CGPoint)point animated:(BOOL)animate;

/**
 底图的初始化
 */
- (void)setupMap;

/**
 底图缩放过程中更新坐标
 */
- (void)updatePositions;

/**
 移除所有的连线
 */
- (void)removeAllOverlays;

/**
 添加连线

 @param overlays 线段数组
 */
- (void)addOverlays:(NSArray *)overlays;

/**
 返回当前缩放级别下 连线两个端点的坐标 以便于更新连线的坐标

 @param lines 线段坐标数组
 @return 更新后的坐标数组
 */
- (NSArray<NSString *> *)zoomRelativeLines:(NSArray<NSString *> *)lines;

/**
 当前底图的缩放级别
 */
@property (readonly, nonatomic, assign) CGFloat zoomLevel;

/**
 底图中心的坐标
 */
@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, weak) NSObject<YLMapViewDelegate> *mapViewDelegate;

/**
 图片放到最大的尺寸
 */
@property (nonatomic, assign) CGSize originalSize;

/**
 双击一下缩放的级别 默认1.5
 */
@property (nonatomic, assign) CGFloat zoomStep;

/**
 双击手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;

/**
 聚合手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *twoFingerTapGesture;


/**
 连线的父view 层级关系分别为 底图 -> 连线 -> 大头针 三层
 */
@property (nonatomic, strong) UIView *overlaysBackView;

/**
 大头针的父view 层级关系分别为 底图 -> 连线 -> 大头针 三层
 */
@property (nonatomic, strong) UIView *annotationBackView;

@end

NS_ASSUME_NONNULL_END
