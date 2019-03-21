//
//  YLAnnotation.m
//  MethodSwizzling
//
//  Created by 杨磊 on 2019/3/7.
//  Copyright © 2019年 csda_Chinadance. All rights reserved.
//

#import "YLAnnotation.h"
#import "YLMapView.h"

@implementation YLAnnotation


+ (id)annotationWithPoint:(CGPoint)point
{
    return [[[self class] alloc] initWithPoint:point];
}

- (id)initWithPoint:(CGPoint)point{
    self = [super init];
    if (self) {
        _point = point;
    }
    return self;
}

- (void)addToMapView:(YLMapView *)mapView animated:(BOOL)animate
{
    NSAssert(!self.mapView, @"Annotation already added to map.");
    
    if (!self.view) {
        _view = [self createViewOnMapView:mapView];
    }
    
    [mapView.annotationBackView addSubview:self.view];
    _mapView = mapView;
    
    _mapViewDelegate = mapView.mapViewDelegate;
    
    [self updatePosition];
}

- (void)removeFromMapView
{
    [self.view removeFromSuperview];
    _mapView = nil;
    _view = nil;
}

- (void)updatePosition
{
    if (!self.mapView) {
        return;
    }
    
    CGPoint point = [self.mapView zoomRelativePoint:self.point];
    self.view.frame = (CGRect) {
        .origin = point,
        .size = self.view.bounds.size
    };
}

- (UIView *)createViewOnMapView:(YLMapView *)mapView
{
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

@end
