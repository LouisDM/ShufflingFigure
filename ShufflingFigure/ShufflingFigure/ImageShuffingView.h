//
//  ImageShuffingView.h
//  ShufflingFigure
//
//  Created by gdm on 16/5/7.
//  Copyright © 2016年 辜东明. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ImageType) {
    ImageName = 0,
    ImageData,
    ImageUrlStr
};

typedef void(^BLOCK)(int index);

@interface ImageShuffingView : UIView<UIScrollViewDelegate>

@property(nonatomic,copy) void(^chickBtn)();

/**
 *  图片
 *
 *  @param frame   展示图片的区域
 *  @param type    存图片的类型
 *  @param arr     存图片的数组（类型为名字，data，网址之一）
 *  @param cuColor 当前进度点颜色
 *  @param otColor 其他进度点颜色
 *  @param time    每张图片展示时间
 *  @param view    父视图
 *
 *  @return self
 */
-(instancetype)initWithFrame:(CGRect)frame andImageType:(ImageType)type andImageArr:(NSArray *)arr andCurrentPageColor:(UIColor *)cuColor andOtherPageColor:(UIColor *)otColor andTime:(float)time andFather:(UIView *)view;



@end
