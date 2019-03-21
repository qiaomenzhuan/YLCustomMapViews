//
//  YLPinAnnotationView.m
//  SportChina
//
//  Created by 杨磊 on 2019/3/14.
//  Copyright © 2019年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import "YLPinAnnotationView.h"
#define YLMapViewAnnotationPinWidth  50.0f//自己的控件宽
#define YLMapViewAnnotationPinHeight 81.0f//自己的控件高
#define YLMapViewAnnotationPinPointX 25.0f//减少会向左偏移 水平方向大头针尖距控件左边的距离 保证大头针尖在缩放过程中始终处于坐标点
#define YLMapViewAnnotationPinPointY 62.0f//减少会向上偏移 水平方向大头针尖距控件顶部的距离 保证大头针尖在缩放过程中始终处于坐标点
#define ZOOM_LEVEL 0.5555f

@interface YLPinAnnotationView()

@property (nonatomic, weak) YLMapView *mapView;

@end

@implementation YLPinAnnotationView

- (id)initWithAnnotation:(YLPinAnnotation *)annotation onMapView:(YLMapView *)mapView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabled = YES;
        self.mapView = mapView;
        self.annotation = annotation;
        
        UIImage *pinImage = [UIImage imageNamed:@"icon_map_gps"];
        switch (annotation.type) {
            case 1:
                pinImage = [UIImage imageNamed:@"icon_act_takephoto"];
                break;
            case 2:
                pinImage = [UIImage imageNamed:@"icon_act_task"];
                break;
            case 3:
                pinImage = [UIImage imageNamed:@"icon_act_video"];
                break;
            case 4:
                pinImage = [UIImage imageNamed:@"icon_act_vr"];
                break;
            case 5:
                pinImage = [UIImage imageNamed:@"icon_act_yinzhang"];
                break;
            default:
                break;
        }

        [self setImage:pinImage forState:UIControlStateNormal];
    }
    return self;
}

- (void)updatePosition
{
    CGPoint point = [self.mapView zoomRelativePoint:self.annotation.point];
    point.x = point.x - YLMapViewAnnotationPinPointX;
    point.y = point.y - YLMapViewAnnotationPinPointY;
    self.frame = CGRectMake(point.x, point.y, YLMapViewAnnotationPinWidth, YLMapViewAnnotationPinHeight);
}

@end
