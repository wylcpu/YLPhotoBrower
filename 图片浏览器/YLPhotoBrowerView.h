//
//  YLPhotoBrowerView.h
//  图片浏览器
//
//  Created by eviloo7 on 16/1/4.
//  Copyright © 2016年 eviloo7. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLPhotoBrowerViewDeledate<NSObject>
- (void)didSelectImageIndex:(NSUInteger)number;
- (void)oneTapImage:(NSUInteger)number CGRect:(CGRect)imageFrame;

@end
@interface YLPhotoBrowerView : UIScrollView
@property (nonatomic,weak) UIImage *image;
@property (nonatomic,weak) NSURL *HighImageURL;
@property (nonatomic,weak)id<YLPhotoBrowerViewDeledate>imageDelegate;
@end
