//
//  YLOverlays.m
//  MethodSwizzling
//
//  Created by 杨磊 on 2019/3/7.
//  Copyright © 2019年 csda_Chinadance. All rights reserved.
//

#import "YLOverlays.h"
#import "YLMapView.h"

@interface YLOverlays()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation YLOverlays

+ (id)overlaysWithLine:(NSArray<NSString *> *)lines;
{
    return [[[self class] alloc] initWithLine:lines];
}

- (id)initWithLine:(NSArray<NSString *> *)lines
{
    self = [super init];
    if (self) {
        self.shapeLayer = [CAShapeLayer layer];
        _lines = lines;
        self.lineWidth = 2;
        self.lineSpace = 2;
        self.lineLength = 4;
        self.lineColor = [UIColor redColor];
    }
    return self;
}

- (void)addToMapView:(YLMapView *)mapView animated:(BOOL)animate
{
    NSAssert(!self.mapView, @"line already added to map.");
    
    if (!self.view) {
        _view = [UIView new];
    }
    
    [self.shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [self.shapeLayer setStrokeColor:[self.lineColor CGColor]];
    [self.shapeLayer setLineWidth:self.lineWidth];
    [self.shapeLayer setLineJoin:kCALineJoinRound];
    [self.shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInteger:self.lineLength],[NSNumber numberWithInteger:self.lineSpace],nil]];
    [[self.view layer] addSublayer:self.shapeLayer];
    
    [mapView.overlaysBackView addSubview:self.view];
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
    
    NSArray *linesZoom = [self.mapView zoomRelativeLines:self.lines];
    CGPoint point1 = CGPointFromString(linesZoom[0]);
    CGPoint point2 = CGPointFromString(linesZoom[1]);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, point1.x, point1.y);
    CGPathAddLineToPoint(path, NULL, point2.x,point2.y);
    [self.shapeLayer setPath:path];
    [self.view layoutIfNeeded];
    CGPathRelease(path);
}

#pragma mark - setter
- (void)setLineWidth:(CGFloat)lineWidth
{
    if (lineWidth <= 0)
    {
        return;
    }
    
    _lineWidth = lineWidth;
    [self.shapeLayer setLineWidth:lineWidth];
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    if (lineSpace < 0)
    {
        return;
    }
    
    _lineSpace = lineSpace;
    [self.shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithFloat:self.lineLength],[NSNumber numberWithFloat:self.lineSpace],nil]];
}

- (void)setLineLength:(CGFloat)lineLength
{
    if (lineLength <= 0)
    {
        return;
    }
    
    _lineLength = lineLength;
    [self.shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithFloat:self.lineLength],[NSNumber numberWithFloat:self.lineSpace],nil]];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [self.shapeLayer setStrokeColor:[self.lineColor CGColor]];
}

@end
