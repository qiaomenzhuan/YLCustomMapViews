//
//  YLPinAnnotation.h
//  SportChina
//
//  Created by 杨磊 on 2019/3/14.
//  Copyright © 2019年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import "YLAnnotation.h"
NS_ASSUME_NONNULL_BEGIN

@interface YLPinAnnotation : YLAnnotation

- (id)initWithPoint:(CGPoint)point;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
