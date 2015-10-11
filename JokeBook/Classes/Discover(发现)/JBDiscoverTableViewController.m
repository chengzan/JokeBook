//
//  JBDiscoverTableViewController.m
//  JokeBook
//
//  Created by shanzy on 15/9/1.
//  Copyright (c) 2015年 shanzy. All rights reserved.
//

#import "JBDiscoverTableViewController.h"
#import "JBJokeMartViewController.h"

@interface JBDiscoverTableViewController ()

@end

@implementation JBDiscoverTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int row=1;
    (section%2)?(row=3):(row);

    return row;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        UIStoryboard *martStoryBoard=[UIStoryboard storyboardWithName:@"JokeMart" bundle:nil];
        JBJokeMartViewController *martVC=martStoryBoard.instantiateInitialViewController;
        [self.navigationController pushViewController:martVC animated:YES];
    }
    
}
@end
