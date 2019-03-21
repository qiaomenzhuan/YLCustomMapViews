//
//  YLCustomMapView.m
//  SportChina
//
//  Created by 杨磊 on 2019/3/14.
//  Copyright © 2019年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import "YLCustomMapView.h"

#import "YLPinAnnotationView.h"
#import "YLPinAnnotation.h"

@interface YLCustomMapView()

@property (nonatomic,assign) NSTimeInterval yl_acceptEventTime;//最小点击间隔
@property (nonatomic,assign) NSTimeInterval yl_acceptEventInterval;//上一次点击的时间

@property (nonatomic, readonly) NSMutableArray *annotations;

@end

@implementation YLCustomMapView

- (void)setupMap
{
    [super setupMap];
    _annotations = @[].mutableCopy;
    self.yl_acceptEventTime = 1;
}

- (void)addAnnotation:(YLAnnotation *)annotation animated:(BOOL)animate
{
    [annotation addToMapView:self animated:animate];
    [self.annotations addObject:annotation];
    
    if ([annotation.view isKindOfClass:NSClassFromString(@"YLPinAnnotationView")]) {
        YLPinAnnotationView *annotationView = (YLPinAnnotationView *) annotation.view;
        [annotationView addTarget:self action:@selector(showCallOut:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - action
- (void)showCallOut:(id)sender
{
    if ([NSDate date].timeIntervalSince1970 - self.yl_acceptEventTime < self.yl_acceptEventInterval) {
        return;
    }
    if (self.yl_acceptEventTime > 0) {
        self.yl_acceptEventInterval = [NSDate date].timeIntervalSince1970;
    }
    
    if([sender isKindOfClass:[YLPinAnnotationView class]])
    {
        YLPinAnnotationView *annontationView = (YLPinAnnotationView *)sender;
                
        if (annontationView.annotation)
        {
            [self centerOnPoint:annontationView.annotation.point animated:YES];
        }
        
        if ([self.mapViewDelegate respondsToSelector:@selector(mapView:tappedOnAnnotation:)])
        {
            [self.mapViewDelegate mapView:self tappedOnAnnotation:annontationView.annotation];
        }
    }
}

@end
