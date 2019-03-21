//
//  ViewController.m
//  YLCusMapView
//
//  Created by 杨磊 on 2019/3/21.
//  Copyright © 2019年 csda_Chinadance. All rights reserved.
//

#import "ViewController.h"
#import "YLCustomMapView.h"
#import "YLPinAnnotation.h"
@interface ViewController ()<YLMapViewDelegate>

@property (nonatomic, strong) YLCustomMapView *cusMapView;
@property (nonatomic, strong) NSMutableArray  *dataCusPois;//大头针数组
@property (nonatomic, strong) NSMutableArray  *dataCusLines;//连线数组
@property (nonatomic, strong) UIImage *baseImage;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UILabel *toastLabel;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_bg" ofType:@"png"];
    self.baseImage = [UIImage imageWithContentsOfFile:path];
    [self.cusMapView displayMap:self.baseImage.size andImagePath:path withCount:32];
    [self.cusMapView scrollToCenter:NO];

    [self reloadMaker];
    [self reloadLines];
    
    self.clearBtn.hidden = NO;
}

#pragma mark - YLMapViewDelegate
- (void)mapView:(YLMapView *)mapView tappedOnAnnotation:(YLAnnotation *)annotation
{
    YLPinAnnotation *ann = (YLPinAnnotation *)annotation;
    NSLog(@"%@ %ld",ann,ann.tag);
    self.toastLabel.text = [NSString stringWithFormat:@"你点%ld号大头针干嘛？",ann.tag];
    self.toastLabel.hidden = NO;
    self.toastLabel.alpha = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.toastLabel.alpha = 0;
        self.toastLabel.hidden = YES;
    });
    /*本来是要用地图瓦片来实现这种需求的，后来决定不依附于地图，采取自定义控件的方式。主要就是用UIScrollview上贴一张图片来缩放，在缩放过程中重新计算大头针的位置，保证针尖在图片的位置不变*/
}

#pragma mark - action
- (void)clearLines
{
    self.clearBtn.selected = !self.clearBtn.selected;
    if (!self.clearBtn.selected)
    {
        [self.clearBtn setTitle:@"开始连线" forState:UIControlStateNormal];
        [self.cusMapView removeAllOverlays];
    }else
    {
        [self.clearBtn setTitle:@"清除连线" forState:UIControlStateNormal];
        [self.cusMapView removeAllOverlays];
        [self.cusMapView addOverlays:self.dataCusLines];
    }
}

#pragma mark - private
- (void)reloadMaker
{
    for (int i = 0; i < 5; i++)
    {
        CGFloat w = self.baseImage.size.width;
        CGFloat h = self.baseImage.size.height;
        double posx = w*(arc4random()%10 + 1)/10.f;
        double posy = h*(arc4random()%10 + 1)/10.f;
        posx = MAX(50, posx);
        posx = MIN(w - 50, posx);
        posy = MAX(50, posy);
        posy = MIN(h - 50, posy);
        NSInteger type = arc4random()%6;
        YLPinAnnotation *dot = [YLPinAnnotation annotationWithPoint:CGPointMake(posx, posy)];
        dot.tag = i;
        dot.type = type;
        [self.dataCusPois addObject:dot];
    }

    [self.cusMapView removeAllAnnotaions];
    [self.cusMapView addAnnotations:self.dataCusPois animated:YES];
}

- (void)reloadLines
{
    [self.dataCusLines removeAllObjects];
    
    for (int i = 0; i < self.dataCusPois.count; i++)
    {
        YLPinAnnotation *dot = self.dataCusPois[i];
        if (i < self.dataCusPois.count - 1)
        {
            YLPinAnnotation *dot1 = self.dataCusPois[i+1];
            NSString *point2 = NSStringFromCGPoint(dot.point);
            NSString *point3 = NSStringFromCGPoint(dot1.point);
            YLOverlays *over = [YLOverlays overlaysWithLine:@[point2,point3]];
            UIColor *color = [UIColor purpleColor];
            over.lineColor = color;
            over.lineSpace = 2;
            over.lineWidth = 1.5;
            over.lineLength = 5;
            [self.dataCusLines addObject:over];
        }
    }
}
#pragma mark - getter

- (NSMutableArray *)dataCusPois
{
    if (!_dataCusPois)
    {
        _dataCusPois = [NSMutableArray array];
    }
    return _dataCusPois;
}

- (NSMutableArray *)dataCusLines
{
    if (!_dataCusLines)
    {
        _dataCusLines = [NSMutableArray array];
    }
    return _dataCusLines;
}

- (YLCustomMapView *)cusMapView
{
    if (!_cusMapView)
    {
        _cusMapView = [[YLCustomMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _cusMapView.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _cusMapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _cusMapView.minimumZoomScale = 0.12f;
        _cusMapView.maximumZoomScale = 1.0f;
        _cusMapView.zoomStep = 3;
        _cusMapView.mapViewDelegate = self;
        [self.view addSubview:_cusMapView];
    }
    return _cusMapView;
}

- (UIButton *)clearBtn
{
    if (!_clearBtn)
    {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearBtn.frame = CGRectMake(20, 20, 50, 50);
        _clearBtn.backgroundColor = [UIColor purpleColor];
        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _clearBtn.titleLabel.numberOfLines = 2;
        [self.view addSubview:_clearBtn];
        [self.clearBtn setTitle:@"开始连线" forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearLines) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UILabel *)toastLabel
{
    if (!_toastLabel)
    {
        _toastLabel = [UILabel new];
        _toastLabel.frame = CGRectMake((self.view.frame.size.width - 150)/2, (self.view.frame.size.height - 30)/2, 150, 30);
        _toastLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _toastLabel.textColor = [UIColor whiteColor];
        _toastLabel.font = [UIFont systemFontOfSize:12];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.userInteractionEnabled = NO;
        [self.view addSubview:_toastLabel];
    }
    return _toastLabel;
}
@end
