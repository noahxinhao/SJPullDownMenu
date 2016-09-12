//
//  SJPullDownMenu.m
//  SJPullDownMenuDemo
//
//  Created by yeshaojian on 16/1/27.
//  Copyright © 2016年 yeshaojian. All rights reserved.
//

#import "SJPullDownMenu.h"

// 分隔线间距
static NSInteger const separateLineMargin = 10;

@interface SJPullDownMenu()

@property (nonatomic, strong) NSMutableArray *separateLines;  // 记录分隔线
@property (nonatomic, strong) NSMutableArray *menuButtons;  // 记录菜单按钮
@property (nonatomic, strong) NSMutableArray *colsHeight;  // 记录列高
@property (nonatomic, strong) NSMutableArray *controllers;  // 记录控制器

@property (nonatomic, strong) UIView *contentView;  // 内容
@property (nonatomic, strong) UIButton *coverView;  // 蒙版
@property (nonatomic, weak) UIView *bottomLine;  // 底部分隔线

@property (nonatomic, weak) id observer;  // 观察者

@end

@implementation SJPullDownMenu

- (NSMutableArray *)separateLines {

    if (!_separateLines) {
        _separateLines = [NSMutableArray array];
    }
    return _separateLines;
}

- (NSMutableArray *)menuButtons {

    if (!_menuButtons) {
        _menuButtons = [NSMutableArray array];
    }
    return _menuButtons;
}

- (NSMutableArray *)colsHeight {

    if (!_colsHeight) {
        _colsHeight = [NSMutableArray array];
    }
    return _colsHeight;
}

- (NSMutableArray *)controllers {

    if (!_controllers) {
        _controllers = [NSMutableArray array];
    }
    return _controllers;
}

#pragma mark - 蒙版
- (UIView *)coverView {

    if (!_coverView) {
        
        // 计算蒙版frame
        CGFloat coverX = 0;
        CGFloat coverY = CGRectGetMaxY(self.frame);
        CGFloat coverW = self.frame.size.width;
        CGFloat coverH = 0;
        
        // 获取视图所在控制器
        UIViewController *currentVC = [self getCurrentViewController];
        
        if ([[currentVC class] isSubclassOfClass:[UITabBarController class]]) {  // 当前所在控制器是UITabBarController
            
            coverH = self.superview.bounds.size.height - (coverY + currentVC.tabBarController.tabBar.frame.size.height);
        } else {
            
            coverH = self.superview.bounds.size.height - coverY;
        }
        
        _coverView = [[UIButton alloc] initWithFrame:CGRectMake(coverX, coverY, coverW, coverH)];
        _coverView.backgroundColor = _coverColor;
        _coverView.hidden = YES;
        [_coverView addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:_coverView];
    }
    return _coverView;
}

/**
 *  获取当前view所在控制器
 */
- (UIViewController *)getCurrentViewController {
    
    UIResponder *next = [self nextResponder];
    
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;
}

#pragma mark - 内容View
- (UIView *)contentView {

    if (!_contentView) {
        
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor blackColor];
        _contentView.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        // 超出的部分隐藏
        _contentView.clipsToBounds = NO;
        
        [self.coverView addSubview:_contentView];
    }
    return _contentView;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        // 初始化
        [self setup];
    }
    return self;
}

#pragma mark - 即将显示窗口
- (void)willMoveToWindow:(UIWindow *)newWindow {

    [super willMoveToWindow:newWindow];
    
    // 更新数据
    [self reloadMenu];
}

#pragma mark - 初始化默认设置
/**
 *  初始化默认设置
 */
- (void)setup {
    
    // 默认背景颜色
    self.backgroundColor = [UIColor whiteColor];
    // 默认分隔线颜色
    _separateLineColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
    // 默认蒙版颜色
    _coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    // 默认动画时间
    _animateTime = 0.25;
    
    // 监听菜单按钮文字变化
    _observer = [[NSNotificationCenter defaultCenter] addObserverForName:SJUpdateMenuTitle object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        // 获取列
        NSInteger col = [self.controllers indexOfObject:note.object];
        // 获取对应按钮
        UIButton *btn = self.menuButtons[col];
        
        // 隐藏下拉菜单
        [self dismissDownMenu];
        
        // 获取所有值
        NSArray *allValues = note.userInfo.allValues;
        // 外部设置的值是否错误
        if (allValues.count > 1 || [allValues.firstObject isKindOfClass:[NSArray class]]) {
            
            @throw [NSException exceptionWithName:@"SJPullDownMenuError" reason:@"('userInfo'只能传一个Key)" userInfo:nil];
            return;
        }
        
        // 设置按钮标题
        [btn setTitle:allValues.firstObject forState:UIControlStateNormal];
    }];
}

#pragma mark - 更新数据
// 更新数据
- (void)reloadMenu {

    // 隐藏下拉菜单
    [self dismissDownMenu];
    
    // 删除之前所有数据
    [self clearAllData];
    
    // 是否有数据源
    if (self.dataSource == nil) {
        return;
    }
    
    // 是否实现数据源方法
    if (self.menuButtons.count) {
        return;
    }
    
    // 是否实现numberOfColsInMenu:
    if (![self.dataSource respondsToSelector:@selector(numberOfColsInMenu:)]) {
        @throw [NSException exceptionWithName:@"SJPullDownMenuError" reason:@"没有实现（numberOfColsInMenu:）" userInfo:nil];
        return;
    }
    
    // 是否实现pullDownMenu:buttonForColAtIndex:
    if (![self.dataSource respondsToSelector:@selector(pullDownMenu:buttonForColAtIndex:)]) {
        @throw [NSException exceptionWithName:@"SJPullDownMenuError" reason:@"没有实现(pullDownMenu:buttonForColAtIndex:）" userInfo:nil];
        return;
    }
    
    // 每一列控制器的方法是否实现
    if (![self.dataSource respondsToSelector:@selector(pullDownMenu:viewControllerForColAtIndex:)]) {
        @throw [NSException exceptionWithName:@"SJPullDownMenuError" reason:@"没有实现(pullDownMenu:viewControllerForColAtIndex:）" userInfo:nil];
        return;
    }
    
    // 每一列控制器的方法是否实现
    if (![self.dataSource respondsToSelector:@selector(pullDownMenu:heightForColAtIndex:)]) {
        @throw [NSException exceptionWithName:@"SJPullDownMenuError" reason:@"没有实现(pullDownMenu:heightForColAtIndex:）" userInfo:nil];
        return;
    }
    
    // 获取列
    NSInteger cols = [self.dataSource numberOfColsInMenu:self];
    
    // 没有列直接返回
    if (cols == 0) {
        return;
    }
    
    // 添加按钮
    for (NSInteger col = 0; col < cols; col++) {
        
        // 获取按钮
        UIButton *menuButton = [self.dataSource pullDownMenu:self buttonForColAtIndex:col];
        // 设置默认title
        [menuButton setTitle:self.defaultTitleArray[col] forState:UIControlStateNormal];
        
        menuButton.tag = col;
        
        [menuButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (menuButton == nil) {
            @throw [NSException exceptionWithName:@"SJPullDownMenuError" reason:@"pullDownMenu:buttonForColAtIndex:这个方法不能返回空的按钮" userInfo:nil];
            return;
        }
        
        [self addSubview:menuButton];
        
        // 记录按钮
        [self.menuButtons addObject:menuButton];
        
        // 记录子控制器
        UIViewController *subVC = [self.dataSource pullDownMenu:self viewControllerForColAtIndex:col];
        [self.controllers addObject:subVC];
        
        // 记录列的高度
        CGFloat height = [self.dataSource pullDownMenu:self heightForColAtIndex:col];
        [self.colsHeight addObject:@(height)];
        
    }
    
    // 添加底部分割线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = _separateLineColor;
    _bottomLine = bottomLine;
    [self addSubview:bottomLine];
    
    // 添加分隔线
    NSInteger count = cols - 1;
    for (NSInteger i = 0; i < count; i++) {
        
        UIView *separateLine = [[UIView alloc] init];
        separateLine.backgroundColor = _separateLineColor;
        [self addSubview:separateLine];
        [self.separateLines addObject:separateLine];
        if (self.hiddenSeparateLine == YES) {
            separateLine.hidden = YES;
        }
    }
    
    // 所有子控件设置布局
    [self layoutSubviews];
}

#pragma mark - 隐藏下拉菜单
/**
 *  隐藏下拉菜单
 */
- (void)dismissDownMenu {

    // 所有按钮取消选中
    for (UIButton *button in self.menuButtons) {
        button.selected = NO;
    }
    
    // 下拉菜单动画
    [UIView animateWithDuration:_animateTime animations:^{
        
        CGRect frame = self.contentView.frame;
        frame.size.height = 0;
        self.contentView.frame = frame;
        // 蒙版颜色
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        // 隐藏蒙版
        self.coverView.hidden = YES;
        // 设置蒙版颜色为默认颜色
        self.coverView.backgroundColor = _coverColor;
        
    }];
}

#pragma mark - 布局
- (void)layoutSubviews {

    [super layoutSubviews];
    
    NSInteger count = self.menuButtons.count;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.bounds.size.width / count;
    CGFloat btnH = self.bounds.size.height;
    
    for (NSInteger i = 0; i < count; i++) {
        // 设置按钮
        UIButton *btn = self.menuButtons[i];
        btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        // 设置分割线
        if (i < count - 1) {
            UIView *separateLine = self.separateLines[i];
            separateLine.frame = CGRectMake(CGRectGetMaxX(btn.frame), separateLineMargin, 1, btnH - 2 * separateLineMargin);
        }
    }
    
    // 设置底部View
    CGFloat bottomH = 1;
    CGFloat bottomY = CGRectGetMaxY(self.frame) - (1 + self.frame.origin.y);
    _bottomLine.frame = CGRectMake(0, bottomY, self.bounds.size.width, bottomH);
}

#pragma mark - 按钮点击
- (void)btnClick:(UIButton *)button {

    // 设置选中状态
    button.selected = !button.selected;
    
    // 取消其它按钮选中状态
    for (UIButton *otherButton in self.menuButtons) {
        
        if (otherButton == button) {
            continue;
        }
        
        otherButton.selected = NO;
    }
    
    if (button.selected == YES) {  // 当按钮选中显示蒙版
        
        // 显示蒙版
        self.coverView.hidden = NO;

        NSInteger i = button.tag;
        
        // 移除当前内容控制器
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        // 添加对应内容控制器
        UIViewController *vc = self.controllers[i];
        vc.view.frame = self.contentView.bounds;
        [self.contentView addSubview:vc.view];
        
        // 设置内容的高度
        CGFloat height = [self.colsHeight[i] floatValue];
        
        [UIView animateWithDuration:_animateTime animations:^{
            
            CGRect frame = self.contentView.frame;
            frame.size.height = height;
            self.contentView.frame = frame;
        } ];
    } else {
        // 隐藏下拉菜单
        [self dismissDownMenu];
    }

}

#pragma mark - 蒙版操作
/**
 *  点击蒙版
 */
- (void)coverClick:(UIButton *)button {
    
    // 隐藏下拉菜单
    [self dismissDownMenu];
}

// 是否显示蒙版
- (void)setHiddenSeparateLine:(BOOL)hiddenSeparateLine {
    
    _hiddenSeparateLine = hiddenSeparateLine;
    
    if (self.separateLines.count < 1) {  // 没有数组的话不做处理
        return;
    }
    
    if (hiddenSeparateLine == YES) {  // 隐藏所以分隔线
        for (UIView *separateLine in self.separateLines) {
            separateLine.hidden = hiddenSeparateLine;
        }
    } else {  // 显示分隔线
        for (UIView *separateLine in self.separateLines) {
            separateLine.hidden = hiddenSeparateLine;
        }
    }
}

#pragma mark - 清除数据
/**
 *  清除所有数据
 */
- (void)clearAllData {
    
    self.bottomLine = nil;
    self.coverView = nil;
    self.contentView = nil;
    
    [self.separateLines removeAllObjects];
    [self.menuButtons removeAllObjects];
    [self.controllers removeAllObjects];
    [self.colsHeight removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - 销毁
- (void)dealloc {
    
    // 清除所有数据
    [self clearAllData];
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:_observer];
}

@end
