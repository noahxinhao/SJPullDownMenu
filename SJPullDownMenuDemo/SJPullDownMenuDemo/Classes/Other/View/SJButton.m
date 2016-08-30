//
//  SJButton.m
//  SJPullDownMenuDemo
//
//  Created by yeshaojian on 16/1/27.
//  Copyright © 2016年 yeshaojian. All rights reserved.
//

#import "SJButton.h"

@interface SJButton()

@end

@implementation SJButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.frame.origin.x < self.titleLabel.frame.origin.x) {  // 交换图片和文字位置
        
        CGRect titleFrame = self.titleLabel.frame;
        titleFrame.origin.x = self.imageView.frame.origin.x;
        self.titleLabel.frame = titleFrame;
        
        CGFloat titleMaxX = self.titleLabel.frame.origin.x + self.titleLabel.frame. size.width;
        
        CGRect imageFrame = self.imageView.frame;
        imageFrame.origin.x = titleMaxX + 10;
        self.imageView.frame = imageFrame;
    }
}

// 重写按钮高亮状态（取消高亮状态）
- (void)setHidden:(BOOL)hidden {

}

// 按钮图片旋转
- (void)rotateButton:(UIButton *)button {

    if (self.selected == NO) {
        
        button.imageView.transform = CGAffineTransformIdentity;
    } else {
        
        button.imageView.transform = CGAffineTransformRotate(self.imageView.transform, -M_PI);
    }
}

@end
