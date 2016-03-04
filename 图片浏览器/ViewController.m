//
//  ViewController.m
//  图片浏览器
//
//  Created by eviloo7 on 16/1/3.
//  Copyright © 2016年 eviloo7. All rights reserved.
//

#import "ViewController.h"
#import "YLPhotoBrower.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 400, 50, 50)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor blackColor];
    imageView.image = [UIImage imageNamed:@"liqin_0"];
    imageView.tag = 10000;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(150, 400, 50, 50)];
    imageView2.userInteractionEnabled = YES;
    imageView2.backgroundColor = [UIColor blackColor];
    imageView2.tag = 10001;
    imageView2.image = [UIImage imageNamed:@"liqin_1"];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
    [imageView2 addGestureRecognizer:tap2];
    [self.view addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 500, 50, 50)];
    imageView3.userInteractionEnabled = YES;
    imageView3.backgroundColor = [UIColor blackColor];
    imageView3.image = [UIImage imageNamed:@"liqin_2"];
    imageView3.tag = 10002;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
    [imageView3 addGestureRecognizer:tap3];
    [self.view addSubview:imageView3];
}

- (void)imageViewClick:(UIGestureRecognizer*)sender {
    YLPhotoBrower *brower = [[YLPhotoBrower alloc] init];
    brower.lowQualityImage = @[[UIImage imageNamed:@"liqin_0"],[UIImage imageNamed:@"liqin_1"],[UIImage imageNamed:@"liqin_2"]];
    brower.highQualityImage = @[[UIImage imageNamed:@"liqin_0"],[UIImage imageNamed:@"liqin_0"],[UIImage imageNamed:@"liqin_0"]];
    brower.currentImageView = sender.view;
    brower.currentIndex = sender.view.tag - 10000;
    brower.actiongSheetTitle = @[@"保存",@"收藏",@"举报"];
    brower.highQualityImageURL = @[[NSURL URLWithString:@"http://7xj3gz.com1.z0.glb.clouddn.com/2015061902.PNG"],[NSURL URLWithString:@"http://7xj3gz.com1.z0.glb.clouddn.com/2015061902.PNG"],[NSURL URLWithString:@"http://7xj3gz.com1.z0.glb.clouddn.com/2015061902.PNG"]];
    brower.photoBrowerType = YLPhotoBrowerTypeWeiBo;
    brower.imageActionSheet = ^(NSUInteger num,NSUInteger imageNum){
        NSLog(@"你是点击%@,%@",@(num),@(imageNum));
    };
    [brower showPhotoBrower];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
