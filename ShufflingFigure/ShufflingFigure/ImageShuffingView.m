//
//  ImageShuffingView.m
//  ShufflingFigure
//
//  Created by gdm on 16/5/7.
//  Copyright © 2016年 辜东明. All rights reserved.
//

#import "ImageShuffingView.h"
#import "UIImageView+WebCache.h"

@implementation ImageShuffingView
{
    UIScrollView *_scrollview;
    NSArray *_arr;
    UIPageControl *_pageControl;
    NSTimer *_timer;
    float _time;
}


-(instancetype)initWithFrame:(CGRect)frame andImageType:(ImageType)type andImageArr:(NSArray *)arr andCurrentPageColor:(UIColor *)cuColor andOtherPageColor:(UIColor *)otColor andTime:(float)time andFather:(UIView *)view{
    //    self.frame = frame;
    if (self = [super init]) {
        self = [[ImageShuffingView alloc]init];
        self.frame = frame;
        _time = time;
        NSMutableArray *muArr = @[].mutableCopy;
        [muArr addObject:[arr lastObject]];
        [muArr addObjectsFromArray:arr];
        [muArr addObject:[arr firstObject]];
        _arr = [NSArray arrayWithArray:muArr];
        
        _scrollview=[[UIScrollView alloc]init];
        _scrollview.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _scrollview.bounces = NO;
        _scrollview.pagingEnabled = YES;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.delegate = self;
        _scrollview.contentSize = CGSizeMake(frame.size.width * _arr.count, frame.size.height);
        
        [self addSubview:_scrollview];
        _pageControl=[[UIPageControl alloc]init];
        _pageControl.center=CGPointMake(CGRectGetWidth(_scrollview.frame)/2, CGRectGetMaxY(_scrollview.frame)-8);
        [self addSubview:_pageControl];
        //当前原点颜色
        _pageControl.currentPageIndicatorTintColor=cuColor;
        //其他原点颜色
        _pageControl.pageIndicatorTintColor=otColor;
        //    图片的宽
        CGFloat imageW = frame.size.width;
        //    CGFloat imageW = 300;
        //    图片高
        CGFloat imageH = frame.size.height;
        //    图片的Y
        CGFloat imageY = 0;
        _pageControl.numberOfPages = arr.count;
        
        [view addSubview:self];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wayTap:)];
        [_scrollview addGestureRecognizer:tap];
        
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 0; i < _arr.count; i++) {
                //        图片X
                CGFloat imageX = i * imageW;
                //        设置图片
                //                NSString *name = arr[i];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
                dispatch_async(dispatch_get_main_queue(),^{
                    switch (type) {
                        case ImageName:
                            imageView.image = [UIImage imageNamed:_arr[i]];
                            break;
                        case ImageData:
                            imageView.image = [UIImage imageWithData:_arr[i]];
                            break;
                        case ImageUrlStr:
                            [imageView sd_setImageWithURL:[NSURL URLWithString:_arr[i]]];
                            break;
                    }
                    [_scrollview addSubview:imageView];
                });
                
                
            }
            _scrollview.contentOffset = CGPointMake(frame.size.width, 0);
        });
        [self addTimer];
        
        return self;
    }else{
        return nil;
    }
}
-(void)wayTap:(UITapGestureRecognizer *)tap
{
    CGFloat scrollviewW =  _scrollview.frame.size.width;
    CGFloat x = _scrollview.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    if (self.chickBtn) {
        self.chickBtn(page - 1);
    }
}

#pragma mark 轮播下一张视图
- (void)nextImage
{
    
    int page = (int)_pageControl.currentPage;
    if (page == _arr.count-3) {
        page = 0;
    }else
    {
        page++;
    }
    //  滚动scrollview
    CGFloat x = (page + 1)* _scrollview.frame.size.width;
    //这个才有动画效果
    [_scrollview setContentOffset:CGPointMake(x , 0) animated:YES];
}

#pragma mark scrollview滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    计算页码
    //    页码 = (contentoffset.x + scrollView一半宽度)/scrollView宽度
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    
    int page = (x ) /  scrollviewW;
    
    //        NSLog(@"滚动中 %d",page);
    _pageControl.currentPage = page - 1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //0 1 2 3 4 5 6 7 8 9 10
    //9 1 2 3 4 5 6 7 8 9 1
    CGPoint point = scrollView.contentOffset;
    //    //判断第几张
    int i = point.x / scrollView.frame.size.width;
    
    NSLog(@"%d",i);
    if (i == 0 || i == _arr.count - 1) {
        if (i == 0) {
            i = (int)_arr.count - 2;
        }else{
            i = 1;
        }
        scrollView.contentOffset = CGPointMake(i * scrollView.frame.size.width, 0);
    }
    //    //pageControl是从0开始，而i是从1开始，所以i－1
    _pageControl.currentPage = i - 1;
    
}

#pragma mark 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}


#pragma mark 停止拽的时候调用-手指不再拖动时添加定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
    
}
/**
 *  开启定时器
 */
#pragma mark 定时器开始
- (void)addTimer{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_time target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
/**
 *  关闭定时器
 */
#pragma mark 关闭定时器
- (void)removeTimer
{
    [_timer invalidate];
}


@end
