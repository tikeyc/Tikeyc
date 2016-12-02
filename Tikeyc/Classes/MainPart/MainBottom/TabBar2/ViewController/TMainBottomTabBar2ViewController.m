//
//  MainBottomTabBar2ViewController.m
//  Tikeyc
//
//  Created by ways on 2016/11/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainBottomTabBar2ViewController.h"

@interface TMainBottomTabBar2ViewController ()

@end

@implementation TMainBottomTabBar2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 20;
 }

/**/
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier1" forIndexPath:indexPath];
 
     
     cell.textLabel.text = [@"cell--" stringByAppendingString:[@(indexPath.row) stringValue]];
     
     return cell;
 
 }
 


@end
