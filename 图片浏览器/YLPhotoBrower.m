//
//  YLPhotoBrower.m
//  图片浏览器
//
//  Created by eviloo7 on 16/1/3.
//  Copyright © 2016年 eviloo7. All rights reserved.
//

#import "YLPhotoBrower.h"
#import "YLPhotoBrowerConfig.h"
#import "YLPhotoBrowerView.h"

#import "UIImageView+WebCache.h"

@interface YLPhotoBrower ()<UIScrollViewDelegate,YLPhotoBrowerViewDeledate>
/**
 *  容器
 */
@property (nonatomic,strong) UIScrollView *scrollView;
/**
 *  Weibo
 */
@property (nonatomic,strong) UIImageView *navigatioinView;
@property (nonatomic,strong) UIImageView *tabBarView;
/**
 *  WeChat
 */
@property (nonatomic,strong) UIPageControl *pageControl;
/**
 *  结束时的ImageView
 */
@property (nonatomic,strong) UIImageView *endImageView;
@property (nonatomic,assign) CGRect endRect;
/**
 *  储存低质量或高质量图片
 */
@property (nonatomic,copy) NSArray *imageArr;
@end

@implementation YLPhotoBrower

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        //初始化
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}
- (UIImageView *)navigatioinView {
    if (_navigatioinView ==nil) {
        _navigatioinView = [[UIImageView alloc] initWithFrame:CGRectMake(0, YLScreenHeight-44, YLScreenWidth, 44)];
    }
    return _navigatioinView;
}
- (UIImageView *)tabBarView {
    if (_tabBarView == nil) {
        _tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, YLScreenHeight-44, YLScreenWidth, 44)];
    }
    return _tabBarView;
}
- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.680 alpha:1];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.877 alpha:1.000];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}


#pragma mark - initView
- (void)addInitView {
    
    UIView *originImageView = self.currentImageView;
    UIView *originImageSuperView = originImageView.superview;
    CGRect rect = [originImageSuperView convertRect:originImageView.frame toView:self.view];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    UIImage *image = self.imageArr[self.currentIndex];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    
//    获取低质量图片的大小
    CGSize originSize = image.size;
//    合适的大小
//    这个地方还没有考虑图片长宽比极端的情况（两个极端）
    CGFloat imageScale = YLScreenWidth/originSize.width;
    CGFloat imageHeigth = image.size.height * imageScale;
    
    CGRect imageRect =  CGRectMake(0, YLScreenHeight/2-imageHeigth/2, YLScreenWidth, imageHeigth);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        imageView.frame = imageRect;
    } completion:^(BOOL finished) {
        if (finished) {
         [imageView removeFromSuperview];
            weakSelf.scrollView.hidden = NO;
            if (weakSelf.photoBrowerType == YLPhotoBrowerTypeWeiBo) {
                weakSelf.pageControl.hidden = YES;
                weakSelf.navigatioinView.hidden = NO;
                weakSelf.tabBarView.hidden = NO;
            } else if(weakSelf.photoBrowerType == YLPhotoBrowerTypeWeChat) {
                weakSelf.pageControl.hidden = NO;
                weakSelf.navigatioinView.hidden = YES;
                weakSelf.tabBarView.hidden = YES;
            }
            
//            加载高质量照片
            if (self.highQualityImage.count == 0) {
                YLPhotoBrowerView *photoView =  weakSelf.scrollView.subviews[weakSelf.currentIndex];
                photoView.HighImageURL = weakSelf.highQualityImageURL[weakSelf.currentIndex];
            }
            
        }
    }];
}
- (void)addPageView {
    NSUInteger num = self.imageArr.count;
    self.scrollView.contentSize = CGSizeMake(YLScreenWidth * num, YLScreenHeight);
    for (NSUInteger i=0; i<self.imageArr.count; i++) {
        YLPhotoBrowerView *photoView = [[YLPhotoBrowerView alloc] initWithFrame:CGRectMake(YLScreenWidth*i, 0, YLScreenWidth, YLScreenHeight)];
        photoView.image = self.imageArr[i];
        photoView.imageDelegate = self;
        photoView.tag = i+20000;
        [self.scrollView addSubview:photoView];
    }
    
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.scrollView];
//    设置显示点击图片
    self.scrollView.contentOffset = CGPointMake(YLScreenWidth * self.currentIndex, 0);
    self.pageControl.numberOfPages = num;
    self.pageControl.currentPage = self.currentIndex;
    
    self.pageControl.frame = CGRectMake(0, YLScreenHeight - 20, YLScreenWidth, 10);
    
    self.scrollView.hidden = YES;
    self.pageControl.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.highQualityImage) {
        self.imageArr = self.highQualityImage;
    } else {
        self.imageArr = self.lowQualityImage;
    }
    [self addInitView];
    [self addPageView];
}
- (void)showPhotoBrower {
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:self animated:nil completion:nil];
    
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger current = scrollView.contentOffset.x/YLScreenWidth;
    self.pageControl.currentPage = current;
//    加载高质量照片
    if (self.highQualityImage.count == 0) {
        YLPhotoBrowerView *photoView = scrollView.subviews[current];
        photoView.HighImageURL = self.highQualityImageURL[current];
    }
    
}


#pragma mark - YLPhotoBrowerViewDelegate

- (void)didSelectImageIndex:(NSUInteger)number {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    for (NSUInteger i=0; i<self.actiongSheetTitle.count; i++) {
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:self.actiongSheetTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (weakSelf.imageActionSheet) {
                weakSelf.imageActionSheet(i,number);
            }
        }];
        [alert addAction:alertAction];
    }
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:alertActionCancel];
    [self presentViewController:alert animated:YES completion:^{
    }];
}
- (void)oneTapImage:(NSUInteger)number CGRect:(CGRect)imageFrame{
    UIView *originImageView = self.currentImageView;
    UIView *originImageSuperView = originImageView.superview;
    NSArray *subViews = originImageSuperView.subviews;
//    
    NSMutableArray<UIView *> *subImageViews = [NSMutableArray new];
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]]|| [view isKindOfClass:[UIButton class]]) {
            [subImageViews addObject:view];
        }
    }
    self.endImageView = [[UIImageView alloc] init];
    self.endImageView.image = self.imageArr[number];
    self.endImageView.frame = imageFrame;
    [originImageSuperView addSubview:self.endImageView];
    CGRect originFrame = subImageViews[number].frame;
    self.endRect = originFrame;
    [self dismissViewControllerAnimated:nil completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.endImageView .frame = weakSelf.endRect;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakSelf.endImageView removeFromSuperview];
        }
        
    }];
}

@end
