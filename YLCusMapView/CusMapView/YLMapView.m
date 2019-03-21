//
//  YLMapView.m
//  MethodSwizzling
//
//  Created by 杨磊 on 2019/3/7.
//  Copyright © 2019年 csda_Chinadance. All rights reserved.
//

#import "YLMapView.h"

#define NAMapViewDefaultZoomStep 1.5

@interface YLMapView()

//@property (nonatomic,  strong) LargeImageView *imageView;
@property (nonatomic,  strong) UIImageView *imageView;
@property (nonatomic,readonly) NSMutableArray *annotations;
@property (nonatomic,readonly) NSMutableArray *overlays;
@property (nonatomic,  assign) BOOL contentSizeObserving;
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation YLMapView

- (void)setupMap
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
    
    [twoFingerTap setNumberOfTouchesRequired:2];
    
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:twoFingerTap];
    
    _annotations = [NSMutableArray array];
    _overlays = [NSMutableArray array];
    _zoomStep = NAMapViewDefaultZoomStep;
    _doubleTapGesture = doubleTap;
    _twoFingerTapGesture = twoFingerTap;
    
    [self.panGestureRecognizer addTarget:self action:@selector(mapPanGestureHandler:)];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupMap];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alwaysBounceVertical = YES;
        self.alwaysBounceHorizontal = YES;
        [self setupMap];
    }
    return self;
}

- (void)mapPanGestureHandler:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan){
        _centerPoint = CGPointZero;
    }
}

- (void)registerObservers
{
    if (!self.contentSizeObserving) {
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        _contentSizeObserving = YES;
    }
}

- (void)displayMap:(CGSize)size andImagePath:(NSString *)path withCount:(NSInteger)count
{
    size.width  = round(size.width);
    size.height = round(size.height);
//    self.imageView = [[LargeImageView alloc]initWithImageName:path andTileCount:count];
    self.imageView.image = [UIImage imageWithContentsOfFile:path];
    self.overlaysBackView.hidden = NO;
    self.annotationBackView.hidden = NO;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat z = 0;
    CGFloat k = 0;
    
    if (size.width < self.frame.size.width)
    {
        x = (self.frame.size.width - size.width)/2;
    }else
    {
        z = (size.width - self.frame.size.width)/2;
    }
    
    if (size.height < self.frame.size.height)
    {
        y = (self.frame.size.height - size.height)/2;
    }else
    {
        k = (size.height - self.frame.size.height)/2;
    }
    self.imageView.frame = CGRectMake(x, y, size.width, size.height);
    CGRect imageFrame = self.imageView.frame;
    self.overlaysBackView.frame = imageFrame;
    self.annotationBackView.frame = imageFrame;
    self.originalSize = CGSizeMake(CGRectGetWidth(imageFrame) + 2*x, CGRectGetHeight(imageFrame) + 2*y);
    self.contentSize = self.originalSize;
    
    CGFloat zoomScale = 0;
    if (size.width < size.height)
    {//垂直长图
        zoomScale = (CGFloat)((CGFloat)self.bounds.size.width / (CGFloat)size.width);
        if (zoomScale*size.height < self.bounds.size.height)
        {//水平方向铺满屏幕 但是垂直方向未铺满屏幕
            zoomScale = (CGFloat)((CGFloat)self.bounds.size.height / (CGFloat)size.height);
        }
    }else
    {//水平长图 或方图
        zoomScale = (CGFloat)((CGFloat)self.bounds.size.height / (CGFloat)size.height);
    }
    self.zoomScale = zoomScale;
    self.minimumZoomScale = self.minimumZoomScale < self.zoomScale ? self.zoomScale : self.minimumZoomScale;
}

- (void)scrollToCenter:(BOOL)animated
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat nowW = self.imageView.frame.size.width;
    CGFloat nowH = self.imageView.frame.size.height;
    
    if (nowW > self.frame.size.width)
    {
        x = (nowW - self.frame.size.width)/2;
    }
    
    if (nowH > self.frame.size.height)
    {
        y = (nowH - self.frame.size.height)/2;
    }
    
    [self setContentOffset:CGPointMake(round(x), round(y)) animated:animated];
}

- (void)centerOnPoint:(CGPoint)point animated:(BOOL)animate
{
    CGFloat x = (point.x * self.zoomScale) - (self.frame.size.width / 2.0f);
    CGFloat y = (point.y * self.zoomScale) - (self.frame.size.height / 2.0f);
    x = MAX(0, x);
    x = MIN(self.contentSize.width - self.frame.size.width, x);
    
    y = MAX(0, y);
    y = MIN(self.contentSize.height - self.frame.size.height, y);

    [self setContentOffset:CGPointMake(round(x), round(y)) animated:animate];
    _centerPoint = point;
}

- (void)updateContentOffsetToCenterPoint:(CGPoint)point animated:(BOOL)animate
{
    CGFloat x = point.x - (self.frame.size.width / 2.0f);
    CGFloat y = point.y - (self.frame.size.height / 2.0f);
    [self setContentOffset:CGPointMake(round(x), round(y)) animated:animate];
}

- (CGPoint)zoomRelativePoint:(CGPoint)point
{
    BOOL hasContentSize = ABS(self.originalSize.width) > 0 && ABS(self.originalSize.height) > 0;
    NSAssert(hasContentSize, @"originalSize dimension is zero, will result in NaN in returned value.");
    
    CGFloat x = (self.contentSize.width / self.originalSize.width) * point.x;
    CGFloat y = (self.contentSize.height / self.originalSize.height) * point.y;
    return CGPointMake(round(x), round(y));
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    BOOL zoomedOut = self.zoomScale == self.minimumZoomScale;
    if (!CGPointEqualToPoint(self.centerPoint, CGPointZero) && !zoomedOut) {
        [self centerOnPoint:self.centerPoint animated:NO];
    }
    
    if (!CGRectIsEmpty(frame)) {
        [self registerObservers];
    }
}

#pragma mark - 点标相关
- (void)addAnnotation:(YLAnnotation *)annotation animated:(BOOL)animate
{
    [annotation addToMapView:self animated:animate];
    [self.annotations addObject:annotation];
}

- (void)addAnnotations:(NSArray *)annotations animated:(BOOL)animate
{
    for (YLAnnotation *annotation in annotations) {
        [self addAnnotation:annotation animated:animate];
    }
}

- (void)removeAnnotation:(YLAnnotation *)annotation
{
    [annotation removeFromMapView];
    [self.annotations removeObject:annotation];
}

- (void)removeAllAnnotaions
{
    [self.annotations enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        YLAnnotation *annot = obj;
        [annot removeFromMapView];
        [self.annotations removeObject:annot];
    }];
}

- (void)selectAnnotation:(YLAnnotation *)annotation animated:(BOOL)animate
{
    [self centerOnPoint:annotation.point animated:animate];
}

#pragma mark - 连线相关
- (void)addOverlays:(NSArray *)overlays
{
    for (YLOverlays *overlay in overlays) {
        [overlay addToMapView:self animated:NO];
        [self.overlays addObject:overlay];
    }
}

- (void)removeAllOverlays
{
    [self.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        YLOverlays *overlay = obj;
        [overlay removeFromMapView];
        [self.overlays removeObject:overlay];
    }];
}

- (NSArray<NSString *> *)zoomRelativeLines:(NSArray<NSString *> *)lines
{
    BOOL hasContentSize = ABS(self.originalSize.width) > 0 && ABS(self.originalSize.height) > 0;
    NSAssert(hasContentSize, @"originalSize dimension is zero, will result in NaN in returned value.");
    CGPoint point1 = CGPointFromString(lines[0]);
    CGPoint point2 = CGPointFromString(lines[1]);
    
    CGFloat x1 = (self.contentSize.width / self.originalSize.width) * point1.x;
    CGFloat y1 = (self.contentSize.height / self.originalSize.height) * point1.y;
    
    CGFloat x2 = (self.contentSize.width / self.originalSize.width) * point2.x;
    CGFloat y2 = (self.contentSize.height / self.originalSize.height) * point2.y;
    
    point1 = CGPointMake(x1, y1);
    point2 = CGPointMake(x2, y2);
    
    NSArray *array = @[NSStringFromCGPoint(point1),NSStringFromCGPoint(point2)];
    return array;
}
#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([self.mapViewDelegate respondsToSelector:@selector(mapView:hasChangedZoomLevel:)]) {
        [self.mapViewDelegate mapView:self hasChangedZoomLevel:self.zoomLevel];
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    self.overlaysBackView.hidden = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.overlaysBackView.hidden = NO;
}

- (CGFloat)zoomLevel
{
    return self.zoomScale / self.maximumZoomScale;
}

#pragma mark - Tap to Zoom

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.zoomScale >= self.maximumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGPoint tapCenter = [gestureRecognizer locationInView:self.imageView];
        CGFloat newScale = MIN(self.zoomScale * self.zoomStep, self.maximumZoomScale);
        CGRect maxZoomRect = [self rectAroundPoint:tapCenter atZoomScale:newScale];
        [self zoomToRect:maxZoomRect animated:YES];
    }
}

- (CGRect)rectAroundPoint:(CGPoint)point atZoomScale:(CGFloat)zoomScale
{
    CGSize boundsSize = self.bounds.size;
    CGSize scaledBoundsSize = CGSizeMake(boundsSize.width / zoomScale, boundsSize.height / zoomScale);
    
    return CGRectMake(point.x - scaledBoundsSize.width / 2,
                      point.y - scaledBoundsSize.height / 2,
                      scaledBoundsSize.width,
                      scaledBoundsSize.height);
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGFloat newScale = self.zoomScale <= self.minimumZoomScale ? self.maximumZoomScale : self.zoomScale / self.zoomStep;
    [self setZoomScale:newScale animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self updatePositions];
    }
}

- (void)updatePositions
{
    [self.annotations makeObjectsPerformSelector:@selector(updatePosition)];
    [self.overlays makeObjectsPerformSelector:@selector(updatePosition)];
}

#pragma mark - getter
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIView *)overlaysBackView
{
    if (!_overlaysBackView)
    {
        _overlaysBackView = [UIView new];
        [self addSubview:_overlaysBackView];
    }
    return _overlaysBackView;
}

- (UIView *)annotationBackView
{
    if (!_annotationBackView)
    {
        _annotationBackView = [UIView new];
        [self addSubview:_annotationBackView];
    }
    return _annotationBackView;
}

- (void)dealloc
{
    if (self.contentSizeObserving) {
        [self removeObserver:self forKeyPath:@"contentSize"];
    }
}


@end
