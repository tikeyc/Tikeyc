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

#import "TQRCodeWebViewController.h"

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
        
        
        [self initRACSignal];
    }
    
    return self;
}

- (TMenuLeftHeadView *)menuLeftHeadView{
    if (!_menuLeftHeadView) {
        _menuLeftHeadView = [[[NSBundle mainBundle] loadNibNamed:@"TMenuLeftHeadView" owner:nil options:NULL] lastObject];
    }
    return _menuLeftHeadView;
}


#pragma mark - bind RACSignal

- (void)initRACSignal{
    
}

- (void)excuseToGetMenuData{
    TWeakSelf(self)
    //
    if (_currentShowTableViewIsLeft) {
        
        NSArray *leftMenuTitles = @[@"个人技术博客",@"个人GitHub",@"title_test",@"title_test",@"title_test",@"title_test",@"登出"];
        __block NSMutableArray *leftMenuModels = [NSMutableArray array];
        self.leftMenuModels = leftMenuModels;
        [leftMenuTitles enumerateObjectsUsingBlock:^(NSString   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TLeftMenuModel *model = [[TLeftMenuModel alloc] init];
            model.title = obj;
            [leftMenuModels addObject:model];
            
            
        }];
    }else{
        
        //
        NSArray *rightMenuTitles = @[@"title_test",@"title_test",@"title_test",@"title_test",@"title_test"];
        __block NSMutableArray *rightMenuModels = [NSMutableArray array];
        self.rightMenuModels = rightMenuModels;
        [rightMenuTitles enumerateObjectsUsingBlock:^(NSString   * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            TRightMenuModel *model = [[TRightMenuModel alloc] init];
            model.title = obj;
            [rightMenuModels addObject:model];
            
            
        }];
    }

    [_currentTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_currentShowTableViewIsLeft) {
        return self.leftMenuModels.count;
    }
    return self.rightMenuModels.count;
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
         
         TLeftMenuModel *model = self.leftMenuModels[indexPath.row];
         
         cell.textLabel.text = model.title;//[NSString stringWithFormat:@"left cell %ld",(long)indexPath.row];
         
         return cell;
         
     }else if ([self.tableViewCellIdentifier isEqualToString:rightMenuTableViewCellIdentifier]){

         TMenuRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightMenuTableViewCellIdentifier forIndexPath:indexPath];
         
         if (!cell) {
             NSLog(@"!cell");
             cell = [[TMenuRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightMenuTableViewCellIdentifier];
         }
         
         TRightMenuModel *model = self.rightMenuModels[indexPath.row];
         cell.customTitleLabel.text = model.title;//[NSString stringWithFormat:@"right cell %ld",(long)indexPath.row];
         
         return cell;
     }
     
     
     return nil;
 }

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([tableView.viewController isKindOfClass:[TMenuLeftTableViewController class]] || [tableView.viewController isKindOfClass:[TMenuRightTableViewController class]]) {
        
        TMainMenuViewController *mainMenuVC = ((TMenuLeftTableViewController *)tableView.viewController).mainMenuViewController;
        if ([mainMenuVC isKindOfClass:[TMainMenuViewController class]]) {
            //        [((TMenuLeftTableViewController *)tableView.viewController).mainMenuViewController showCenterControllerWithAnimation:NO];
            //        [((TMenuLeftTableViewController *)tableView.viewController).mainMenuViewController showCenterControllerWithAnimation:YES toShowNextController:[[TBaseViewController alloc] init]];
            
            
            
            if (_currentShowTableViewIsLeft) {//leftMenu的特殊处理
                if (indexPath.row == self.leftMenuModels.count - 1) {//最后一个row
                    [TAlertView showWithTitle:@"提示" message:@"确定登出?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"立即登出"] type:UIAlertControllerStyleAlert andParentView:nil andAction:^(NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [TAppDelegateManager gotoLoginController];
                        }
                    } ];
                    
                    return;
                }else if (indexPath.row == 0){
                    TQRCodeWebViewController *codeWebVC = [[TQRCodeWebViewController alloc] initWithURL:[NSURL URLWithString:Tikeyc_Blog_CSDN_url]];
                    [mainMenuVC showCenterControllerWithAnimation:YES toShowNextController:codeWebVC];
                }else if (indexPath.row == 1){
                    TQRCodeWebViewController *codeWebVC = [[TQRCodeWebViewController alloc] initWithURL:[NSURL URLWithString:Tikeyc_GitHub_url]];
                    [mainMenuVC showCenterControllerWithAnimation:YES toShowNextController:codeWebVC];
                }else{
                    
                }
                
            }else{//rightMenu的特殊处理
                
            }
            
        }
    
        
    }
    
    
    
   
    
    
}

@end










