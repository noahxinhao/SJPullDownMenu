//
//  SJPullDownMenu.h
//  SJPullDownMenuDemo
//
//  Created by yeshaojian on 16/1/27.
//  Copyright © 2016年 yeshaojian. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SJPullDownMenu;

@protocol SJPullDownMenuDataSource <NSObject>
/**
 *  下拉菜单列数
 *
 *  @param pullDownMenu 下拉菜单
 *
 *  @return 下拉菜单列数
 */
- (NSInteger)numberOfColsInMenu:(SJPullDownMenu *)pullDownMenu;
/**
 *  下拉菜单每列按钮
 *
 *  @param pullDownMenu 下拉菜单
 *  @param index        第几列
 *
 *  @return 下拉菜单每列按钮
 */
- (UIButton *)pullDownMenu:(SJPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index;
/**
 *  下拉菜单每列对应的控制器
 *
 *  @param pullDownMenu 下拉菜单
 *  @param index        第几列
 *
 *  @return 下拉菜单每列对应的控制器
 */
- (UIViewController *)pullDownMenu:(SJPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index;
/**
 *  下拉菜单每列对应的高度
 *
 *  @param pullDownMenu 下拉菜单
 *  @param index        第几列
 *
 *  @return 下拉菜单每列对应的高度
 */
- (CGFloat)pullDownMenu:(SJPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index;

@end

/**
 *  更新菜单文字通知名称(如果没有冲突，建议不要修改)
 *  在需要更改标题文字的地方实现通知即可（传入的值限定一个KEY）
 */
static NSString * const SJUpdateMenuTitle = @"SJUpdateMenuTitle";

@interface SJPullDownMenu : UIView

/**
 *  数据源
 */
@property (nonatomic, weak) id<SJPullDownMenuDataSource> dataSource;
/**
 *  默认值
 */
@property (nonatomic, strong) NSArray *defaultTitleArray;
/**
 *  分割线颜色
 */
@property (nonatomic, strong) UIColor *separateLineColor;
/**
 *  蒙版颜色
 */
@property (nonatomic, strong) UIColor *coverColor;
/**
 *  隐藏分隔线
 */
@property (nonatomic, assign) BOOL hiddenSeparateLine;
/**
 *  动画持续时间
 */
@property (nonatomic, assign) CGFloat animateTime;

/**
 *  刷新菜单
 */
- (void)reloadMenu;

@end
