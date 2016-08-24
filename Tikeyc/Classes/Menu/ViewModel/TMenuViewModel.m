//
//  TMenuViewModel.m
//  Tikeyc
//
//  Created by ways on 16/8/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMenuViewModel.h"

#import "TMainMenuViewController.h"

#import "TMenuLeftCell.h"
#import "TMenuRightCell.h"



@interface TMenuViewModel ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,assign)BOOL currentShowTableViewIsLeft;

@end

@implementation TMenuViewModel

- (instancetype)initMenuViewModelWitchTableViewCellIdentifier:(NSString *)tableViewCellIdentifier{
    self = [super init];
    if (self) {
        
        if ([tableViewCellIdentifier isEqualToString:leftMenuTableViewCellIdentifier]) {
            self.tableViewCellIdentifier = leftMenuTableViewCellIdentifier;
            self.currentShowTableViewIsLeft = YES;
        }else if ([tableViewCellIdentifier isEqualToString:rightMenuTableViewCellIdentifier]){
            self.tableViewCellIdentifier = rightMenuTableViewCellIdentifier;
            self.currentShowTableViewIsLeft = NO;
        }
        
        
        [self initSubViews];
        
        [self initRACSignal];
    }
    
    return self;
}

- (void)initSubViews{
    self.menuLeftHeadView = [[[NSBundle mainBundle] loadNibNamed:@"TMenuLeftHeadView" owner:nil options:NULL] lastObject];
}


#pragma mark - bind RACSignal

- (void)initRACSignal{
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}
/*如果是固定高度，为了优化速度，不必在此代理方法设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_currentShowTableViewIsLeft) {
        if (section == 0) {
            return self.menuLeftHeadView.height;
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_currentShowTableViewIsLeft) {
        if (section == 0) {
            return self.menuLeftHeadView;
        }
    }
    
    return nil;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
     if ([self.tableViewCellIdentifier isEqualToString:leftMenuTableViewCellIdentifier]) {

         TMenuLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftMenuTableViewCellIdentifier forIndexPath:indexPath];
         
         if (!cell) {
             NSLog(@"!cell");
             cell = [[TMenuLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftMenuTableViewCellIdentifier];
         }
         
         cell.textLabel.text = [NSString stringWithFormat:@"left cell %ld",(long)indexPath.row];
         
         return cell;
         
     }else if ([self.tableViewCellIdentifier isEqualToString:rightMenuTableViewCellIdentifier]){

         TMenuRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightMenuTableViewCellIdentifier forIndexPath:indexPath];
         
         if (!cell) {
             NSLog(@"!cell");
             cell = [[TMenuRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightMenuTableViewCellIdentifier];
         }
         cell.customTitleLabel.text = [NSString stringWithFormat:@"right cell %ld",(long)indexPath.row];
         
         return cell;
     }
     
     
     return nil;
 }

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView.viewController isKindOfClass:[TMenuLeftTableViewController class]] || [tableView.viewController isKindOfClass:[TMenuRightTableViewController class]]) {
//        [((TMenuLeftTableViewController *)tableView.viewController).mainMenuViewController showCenterControllerWithAnimation:NO];
        [((TMenuLeftTableViewController *)tableView.viewController).mainMenuViewController showCenterControllerWithAnimation:NO toShowNextController:[[TBaseViewController alloc] init]];
    }
    
    
}

@end










