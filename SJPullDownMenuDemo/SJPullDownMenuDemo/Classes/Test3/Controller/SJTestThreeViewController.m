//
//  SJTestThreeViewController.m
//  SJPullDownMenuDemo
//
//  Created by yeshaojian on 16/1/27.
//  Copyright © 2016年 yeshaojian. All rights reserved.
//

#import "SJTestThreeViewController.h"
#import "SJPullDownMenu.h"


static NSString *const cellID = @"cellID";

@interface SJTestThreeViewController ()

@end

@implementation SJTestThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = [NSString stringWithFormat:@"随机%ld", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SJUpdateMenuTitle object:self userInfo:@{@"title" : cell.textLabel.text}];
}

@end
