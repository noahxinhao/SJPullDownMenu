//
//  SJMainViewController.m
//  SJPullDownMenuDemo
//
//  Created by yeshaojian on 16/1/27.
//  Copyright © 2016年 yeshaojian. All rights reserved.
//

#import "SJMainViewController.h"
#import "SJPullDownMenu.h"
#import "SJTestOneViewController.h"
#import "SJTestTwoViewController.h"
#import "SJTestThreeViewController.h"
#import "SJButton.h"

@interface SJMainViewController ()<SJPullDownMenuDataSource>

@property (nonatomic, weak) SJPullDownMenu *menuView;  // 下拉菜单

@property (nonatomic, strong) NSArray *defaultTitleAry;  // 默认标题

@end

@implementation SJMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置控制器背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 默认标题
    _defaultTitleAry = @[@"综合排序", @"价格优先", @"更多"];
    
    SJPullDownMenu *menuView = [[SJPullDownMenu alloc] init];
    // 设置尺寸
    menuView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 44);
    menuView.dataSource = self;
    // 设置每列按钮默认值
    menuView.defaultTitleArray = _defaultTitleAry;
    self.menuView = menuView;
    
    [self.view addSubview:menuView];

    // 添加内容控制器
    [self addContentViewController];
}

/**
 *  添加内容控制器
 */
- (void)addContentViewController {
    
    SJTestOneViewController *testOneVC = [[SJTestOneViewController alloc] init];
    SJTestTwoViewController *testTwoVC = [[SJTestTwoViewController alloc] init];
    SJTestThreeViewController *testThreeVC = [[SJTestThreeViewController alloc] init];
    UITableViewController *testFourVC = [[UITableViewController alloc] init];
    
    [self addChildViewController:testOneVC];
    [self addChildViewController:testTwoVC];
    [self addChildViewController:testThreeVC];
    [self addChildViewController:testFourVC];
}

#pragma mark - 代理
// 返回下拉菜单多少列
- (NSInteger)numberOfColsInMenu:(SJPullDownMenu *)pullDownMenu
{
    return self.defaultTitleAry.count;
}

// 返回下拉菜单每列按钮
- (UIButton *)pullDownMenu:(SJPullDownMenu *)pullDownMenu buttonForColAtIndex:(NSInteger)index
{
    SJButton *button = [SJButton buttonWithType:UIButtonTypeCustom];

    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"icon_more_highlighted"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateSelected];
    
    return button;
}

// 返回下拉菜单每列对应的控制器
- (UIViewController *)pullDownMenu:(SJPullDownMenu *)pullDownMenu viewControllerForColAtIndex:(NSInteger)index
{
    return self.childViewControllers[index];
}

// 返回下拉菜单每列对应的高度
- (CGFloat)pullDownMenu:(SJPullDownMenu *)pullDownMenu heightForColAtIndex:(NSInteger)index
{
    if (index == 0) {
        
        return 390;
    } else if (index == 1) {
        
        return 130;
    } else if (index == 2) {
        
        return 260;
    } else {
        
        return 200;
    }
}

@end
