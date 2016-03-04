//
//  YLPhotoBrower.h
//  图片浏览器
//
//  Created by eviloo7 on 16/1/3.
//  Copyright © 2016年 eviloo7. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YLPhotoBrowerType) {
    YLPhotoBrowerTypeWeChat,
    YLPhotoBrowerTypeWeiBo,
};

@interface YLPhotoBrower : UIViewController
/**
 *  图片视图的父视图
 */
@property (nonatomic , weak) UIView *imageSuperView;
/**
 *  点击的图片视图
 */
@property (nonatomic, weak)UIView *currentImageView;

/**
 *  点击的第几张
 */
@property (nonatomic, assign) NSUInteger currentIndex;


/**
 *低质量图片
 */
@property (nonatomic, copy) NSArray<UIImage*> *lowQualityImage;
/**
 *  高质量图片URL
 */
@property (nonatomic, copy) NSArray<NSURL*> *highQualityImageURL;
/**
 *  高质量图片
 */
@property (nonatomic, copy) NSArray<UIImage *> *highQualityImage;
/**
 *  显示图片浏览器
 */
- (void)showPhotoBrower;
/**
 *  调用传值
 */
@property (nonatomic,copy) void (^imageActionSheet)(NSUInteger num,NSUInteger imageNum);
/**
 *  actionSheet
 */
@property (nonatomic,copy) NSArray<NSString *>*actiongSheetTitle;
@property (nonatomic,assign) YLPhotoBrowerType photoBrowerType;
@end
