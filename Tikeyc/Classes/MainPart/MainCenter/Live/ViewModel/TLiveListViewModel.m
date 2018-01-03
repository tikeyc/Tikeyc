//
//  TLiveListViewModel.m
//  Tikeyc
//
//  Created by ways on 16/9/22.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TLiveListViewModel.h"

#import "TLivePlayerViewController.h"

#import "TLiveListTableViewCell.h"


#define list_url1 @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1"
#define list_url2 @"http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=30&multiaddr=3"

@interface TLiveListViewModel ()<UITableViewDelegate,UITableViewDataSource>

{
    CGFloat _start_offSet_Y;
    BOOL _isUpScroll;
}

@end

@implementation TLiveListViewModel


- (instancetype)init{
    self = [super init];
    if (self) {
        [self initRACSignal];
    }
    return self;
}


#pragma mark - init bind

- (void)initRACSignal{
    
    @weakify(self)
    ////////////////////////////request
    self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [TServiceTool GET:list_url1 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [subscriber sendCompleted];
                [subscriber sendError:error];
            }];
            
            return nil;
        }];
        
        return signal;
    }];
    
    [self.requestCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *result) {
        @strongify(self)
        if ([result isKindOfClass:[NSDictionary class]] && [result[@"lives"] isKindOfClass:[NSArray class]]) {
            
            self.liveListModels = [TLiveListModel mj_objectArrayWithKeyValuesArray:result[@"lives"]];
            
        }
        
    }];
    
    /**
     //按理来说总共会执行3此监听请求执行状态，默认会执行一次（所以skip跳过第一次）。

     @param x 请求正在执行时x为1，介绍时x为0
     */
    [[self.requestCommand.executing skip:1] subscribeNext:^(id x) {
        [x boolValue] ? [SVProgressHUD show] : [SVProgressHUD dismiss];
    }];
    ////////////////////////////request
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.liveListModels.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

     TLiveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TLiveListTableViewCell class])];
 
     if (!cell) {
         cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TLiveListTableViewCell class]) owner:nil options:NULL] lastObject];
     }
     
     cell.liveListModel = self.liveListModels[indexPath.row];
 
     return cell;
 }


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isUpScroll) {//向下滑动
        
        cell.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else{//向上滑动
        
        cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    CGFloat cell_left = cell.left;
    cell.left = - cell.width/2;
    [UIView animateWithDuration:0.5 animations:^{
        cell.left = cell_left;
        cell.transform = CGAffineTransformIdentity;
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDragging");
    _start_offSet_Y = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSet_Y = scrollView.contentOffset.y;
    if (_start_offSet_Y - offSet_Y > 0) {//向下滑动
        
        _isUpScroll = YES;
    }else{//向上滑动
        
        _isUpScroll = NO;
    }
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
     TLivePlayerViewController *livePlayerVC = [[TLivePlayerViewController alloc] init];
     
     livePlayerVC.liveListModel = self.liveListModels[indexPath.row];
     
     [tableView.viewController.navigationController pushViewController:livePlayerVC animated:YES];
}



@end











