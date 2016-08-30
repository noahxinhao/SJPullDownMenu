# SJPullDownMenu

- 快速集成类似淘宝筛选下拉菜单
- 如果内容显示不全请转至：http://www.jianshu.com/p/d07c6393830c 查看使用教程

## Getting Started【开始使用】 

### Manually【手动导入】

- Drag all source files under floder SJPullDownMenu to your project.【将SJPullDownMenu文件夹中的所有源代码拽入项目中】
- Import the main header file：#import "SJPullDownMenu.h"【导入主头文件：#import "SJPullDownMenu.h"】

## SJPullDownMenu.h

- 代理方法

```
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

```

- 属性与方法

```
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

```

### 初始化菜单

``` 
	// 菜单按钮默认值
    NSArray *defaultTitleArray = @[@"综合排序", @"价格优先", @"更多"];
    
    // 初始化
    SJPullDownMenu *menuView = [[SJPullDownMenu alloc] init];
    // 设置尺寸
    menuView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 44);
    // 设置数据源
    menuView.dataSource = self;
    // 设置每列按钮默认值
    menuView.defaultTitleArray = defaultTitleArray;
    
    [self.view addSubview:menuView];
    self.menuView = menuView;
    
    // 添加内容控制器
    [self addContentViewController];

```

### 初始化内容控制器

```
/**
 *  添加内容控制器
 */
- (void)addContentViewController {
    
    SJTestOneViewController *testOneVC = [[SJTestOneViewController alloc] init];
    SJTestTwoViewController *testTwoVC = [[SJTestTwoViewController alloc] init];
    SJTestThreeViewController *testThreeVC = [[SJTestThreeViewController alloc] init];
    
    [self addChildViewController:testOneVC];
    [self addChildViewController:testTwoVC];
    [self addChildViewController:testThreeVC];
}

```

### 实现代理方法

```
// 返回下拉菜单多少列
- (NSInteger)numberOfColsInMenu:(SJPullDownMenu *)pullDownMenu
{
    return self.childViewControllers.count;
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
    // 设置高度
    if (index == 0) {
        
        return 390;
    } else if (index == 1) {
        
        return 130;
    } else if (index == 2) {
        
        return 260;
    } else {
        
        return 130;
    }
}

```

![效果图.gif](http://upload-images.jianshu.io/upload_images/1923109-3d3b1e9395d1e638.gif?imageMogr2/auto-orient/strip)
