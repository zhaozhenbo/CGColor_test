//
//  ViewController.m
//  CGColor测试获取颜色
//
//  Created by 赵振波 on 16/8/19.
//  Copyright © 2016年 赵日天. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *testView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置testView相关属性
    self.testView.layer.cornerRadius = 10;
    self.testView.layer.borderColor = [UIColor grayColor].CGColor;
    self.testView.layer.borderWidth = 2;
    self.testView.clipsToBounds = YES;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //1.获取点击位置
    UITouch * touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    NSLog(@"touchPoint:%@",NSStringFromCGPoint(touchPoint));
    
    //2.根据点击位置获取颜色
    UIColor * color = [self colorOfPoint:touchPoint];
    
    NSLog(@"color:%@",color);
    
    //3.显示获取的颜色
    self.testView.backgroundColor = color;
    
}
//当前点击位置的颜色
- (UIColor *) colorOfPoint:(CGPoint)point
{
    
    unsigned char pixel[4] = {0};
    
    //创建RGB色彩空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /**
     *创建上下文
     data                指向要渲染的绘制内存的地址。这个内存块的大小至（bytesPerRow*height）个字节
     width               bitmap的宽度,单位为像素
     height              bitmap的高度,单位为像素
     bitsPerComponent    内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
     bytesPerRow         bitmap的每一行在内存所占的比特数
     colorspace          bitmap上下文使用的颜色空间。
     bitmapInfo          指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符串。
     */
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    //CGContext画图片是反的，需反转
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    //将界面内容渲染至上下文
    [self.view.layer renderInContext:context];
    
    //释放上下文及色彩空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //返回该点的颜色
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}
@end
