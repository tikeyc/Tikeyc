//
//  TEchartsTypeListController.m
//  Tikeyc
//
//  Created by ways on 16/10/8.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TEchartsTypeListController.h"

#import "TEchartsAllTypeViewController.h"

#import "TEchartsLineViewController.h"
#import "TEchartsBarViewController.h"

@interface TEchartsTypeListController ()

{
    NSArray *_titles2D;
}

@end

@implementation TEchartsTypeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"iOS-Echarts";
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EchartsTypeCell"];
    
    _titles2D = @[@{@"Line And Bar":@[lineAndBarOption,lineAndStackedBarOption,basicAreaOption,stackedAreaOption,irregularLine2Option]},
                  @{@"特别的":@[timeLineOption,forceGuideOption]},
                  @{@"饼图":@[standardPieOption,nestedPieOption]},
                  @{@"地图":@[basicChinaMapOption,basicChinaMapCityOption,basicWorldMapOption,showMapMarkLine]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _titles2D.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *sectionDic = _titles2D[section];
    NSString *sectionTitle = [sectionDic.allKeys firstObject];
    
    return sectionTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSDictionary *sectionDic = _titles2D[section];
    NSArray *rows = [sectionDic.allValues firstObject];
    return rows.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EchartsTypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EchartsTypeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EchartsTypeCell"];
        //
        cell.textLabel.numberOfLines = 0;
    }
    NSDictionary *sectionDic = _titles2D[indexPath.section];
    NSArray *rows = [sectionDic.allValues firstObject];
    cell.textLabel.text = rows[indexPath.row];
    [cell.textLabel sizeToFit];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *sectionDic = _titles2D[indexPath.section];
    NSArray *rows = [sectionDic.allValues firstObject];
    NSString *rowTitle = rows[indexPath.row];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    TEchartsLineViewController *line = [[TEchartsLineViewController alloc] init];
                    [self.navigationController pushViewController:line animated:YES];
                }
                    break;
                case 1:
                {
                    TEchartsBarViewController *bar = [[TEchartsBarViewController alloc] init];
                    [self.navigationController pushViewController:bar animated:YES];
                }
                    break;
               
                    
                default:
                {
                    TEchartsAllTypeViewController *allTypeVC = [[TEchartsAllTypeViewController alloc] init];
                    allTypeVC.title = rowTitle;
                    [self.navigationController pushViewController:allTypeVC animated:YES];
                }
                    break;
            }
        }
            break;
            
        default:
        {
            
            TEchartsAllTypeViewController *allTypeVC = [[TEchartsAllTypeViewController alloc] init];
            allTypeVC.title = rowTitle;
            [self.navigationController pushViewController:allTypeVC animated:YES];
        }
            break;
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
