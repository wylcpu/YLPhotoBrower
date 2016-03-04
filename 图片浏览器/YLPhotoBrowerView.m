//
//  YLPhotoBrowerView.m
//  图片浏览器
//
//  Created by eviloo7 on 16/1/4.
//  Copyright © 2016年 eviloo7. All rights reserved.
//

#import "YLPhotoBrowerView.h"
#import "YLPhotoBrowerConfig.h"
#import "UIImageView+WebCache.h"

@interface YLPhotoBrowerView ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIImageView *imageView;
/**
 *  图片原始位置
 */
@property (nonatomic,assign)CGRect imageRect;
@end

@implementation YLPhotoBrowerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        self.bounces                        = NO;
        //
        self.maximumZoomScale               = 2.f;
        self.minimumZoomScale               = 1.0f;
        self.delegate                       = self;
    }
    return self;
}


#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView                        = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}


#pragma mark - 动态加载
- (void)setImage:(UIImage *)image {
    _image            = image;
    CGSize originSize = image.size;
    //    合适的大小
    //    这个地方还没有考虑图片长宽比极端的情况（两个极端）
    CGFloat imageScale   = YLScreenWidth/originSize.width;
    CGFloat imageHeigth  = image.size.height * imageScale;
    CGRect imageRect     = CGRectMake(0, YLScreenHeight/2-imageHeigth/2, YLScreenWidth, imageHeigth);

    self.imageRect       = imageRect;
    self.imageView.frame = imageRect;
    self.imageView.image = image;
    self.contentSize     = CGSizeMake(YLScreenWidth,imageHeigth);
    [self addSubview:self.imageView];
    
    //长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
//    单击和双击手势
    UITapGestureRecognizer *oneTap          = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    UITapGestureRecognizer *twoTap          = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoTapClick:)];
    oneTap.numberOfTapsRequired             = 1;
    twoTap.numberOfTapsRequired             = 2;
    [oneTap requireGestureRecognizerToFail:twoTap];
    [self addGestureRecognizer:oneTap];
    [self.imageView addGestureRecognizer:twoTap];
}
- (void)setHighImageURL:(NSURL *)HighImageURL {
    _HighImageURL = HighImageURL;
//    [self.imageView  sd_setImageWithURL:HighImageURL placeholderImage:self.image];
    [self.imageView  sd_setImageWithURL:HighImageURL placeholderImage:self.image];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {

}
//缩放时
//当进行缩放的时候，contentSize是包含内容的实际大小，而不是你指定的
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat centX        = scrollView.bounds.size.width >= scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width)/2 :0;
    CGFloat centY        = scrollView.bounds.size.height >= scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2:0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width/2+centX, scrollView.contentSize.height/2+centY);
}
//缩放要用到，很关键
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


#pragma mark - 手势事件
//长按
- (void)longPress:(UIGestureRecognizer*)sender {

    if (self.imageDelegate && [self.imageDelegate respondsToSelector:@selector(didSelectImageIndex:)]) {
        [self.imageDelegate didSelectImageIndex:self.tag - 20000];
    }
}
//单击
- (void)tapClick:(UIGestureRecognizer*)sender{
    if (self.imageDelegate && [self.imageDelegate respondsToSelector:@selector(oneTapImage:CGRect:)]) {
        [self.imageDelegate oneTapImage:self.tag - 20000 CGRect:self.imageView.frame];
    }
}
//双击
- (void)twoTapClick:(UIGestureRecognizer*)sender {
    CGPoint touchPoint = [sender locationInView:self];
//    CGFloat scale = self.imageRect.size.height/self.imageRect.size.width;
    if (self.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + self.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.contentOffset.y;//需要放大的图片的Y点
        [self zoomToRect:CGRectMake(scaleX, sacleY, 1, 1) animated:YES];
    } else {
        [self setZoomScale:1.f animated:YES];
        }
    
}


@end
