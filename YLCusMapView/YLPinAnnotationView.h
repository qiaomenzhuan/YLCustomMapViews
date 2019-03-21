//
//  YLPinAnnotationView.h
//  SportChina
//
//  Created by 杨磊 on 2019/3/14.
//  Copyright © 2019年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLPinAnnotation.h"
#import "YLMapView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YLPinAnnotationView : UIButton

@property (readwrite, nonatomic, weak)YLPinAnnotation *annotation;

- (id)initWithAnnotation:(YLPinAnnotation *)annotation onMapView:(YLMapView *)mapView;
//地图缩放的时候更新位置
- (void)updatePosition;

@end

NS_ASSUME_NONNULL_END
