//
//  JBDiscoverTableViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/1.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBProfileTableViewController.h"
#import "JBConst.h"

@interface JBProfileTableViewController ()

@end

@implementation JBProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int row=1;
    (section%2)?(row=2):(row);
    
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < 3)
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    else if(indexPath.section == 3 && indexPath.row == 0) {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchView addTarget:self action:@selector(updateSwitchValue:) forControlEvents:UIControlEventValueChanged];
        
        // 修改UISwitch的颜色样式
        // 定义OFF状态下的颜色
        //switchView.tintColor = [UIColor greenColor];
        // 定义ON状态下的颜色
        switchView.onTintColor = JBColor(73, 96, 140);
        // 定义圆形按钮的颜色
        //switchView.thumbTintColor = [UIColor redColor];

        
        cell.accessoryView = switchView;
        return cell;
    }else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

//获取switch数据：
- (IBAction)updateSwitchValue:(id)sender {
    
    
    UISwitch *switchView = (UISwitch *)sender;
    
    if ([switchView isOn])
    {
        //do something..     
    } 
    else 
    {
        //do something   
        
        
    }
    
}

@end
