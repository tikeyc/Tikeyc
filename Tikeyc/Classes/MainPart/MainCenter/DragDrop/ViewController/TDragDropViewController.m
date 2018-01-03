//
//  TDragDropViewController.m
//  Tikeyc
//
//  Created by ways on 2017/11/3.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import "TDragDropViewController.h"

#import "TDragCollectionView.h"
#import "TDragTableView.h"
#import "TDragView.h"

#import "TTopImgBottomTextControl.h"

@interface TDragDropViewController ()

@property (nonatomic,strong) TTopImgBottomTextControl *titleView;

@property (strong, nonatomic) IBOutlet UIView *animationBgView;
@property (nonatomic,strong) TDragCollectionView *dragCollectionView;
@property (nonatomic,strong) TDragTableView *dragTableView;
@property (nonatomic,strong) TDragView *dragView;

@property (nonatomic,assign) UIViewAnimationOptions lastDirection;

@end

@implementation TDragDropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Drag-Drop";
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initSubView];
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



#pragma mark - init

- (TDragCollectionView *)dragCollectionView {
    if (_dragCollectionView == nil) {
        _dragCollectionView = [[TDragCollectionView alloc] initWithFrame:self.view.bounds];
        [self.animationBgView addSubview:_dragCollectionView];
    }
    return _dragCollectionView;
}

- (TDragTableView *)dragTableView {
    if (_dragTableView == nil) {
        _dragTableView = [[TDragTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.animationBgView addSubview:_dragTableView];
    }
    return _dragTableView;
}

- (TDragView *)dragView {
    if (_dragView == nil) {
        _dragView = [[TDragView alloc] initWithFrame:self.view.bounds];
        _dragView.backgroundColor = [UIColor orangeColor];
        [self.animationBgView addSubview:_dragView];
    }
    return _dragView;
}


- (void)setNavigationTitleView {
    _titleView = [[TTopImgBottomTextControl alloc] initWithImageName:@"filter_arrow_drop" withLabelTitle:@"UICollectionView:Drag-Drop"];
    @weakify(self)
    _titleView.clickBlock = ^(TTopImgBottomTextControl *result) {
        @strongify(self)
        [self showAlterView];
    };
    self.navigationItem.titleView = _titleView;
}

- (void)initSubView {
    [self setNavigationTitleView];
    
    self.dragCollectionView.hidden = NO;

//    self.dragTableView.hidden = YES;
    
//    self.dragView.hidden = YES;
    
    _lastDirection = UIViewAnimationOptionTransitionFlipFromLeft;
}


#pragma mark -

- (void)showAlterView {
    [TAlertView showWithTitle:nil message:nil cancelButtonTitle:@"取消"
            otherButtonTitles:@[@"UICollectionView:Drag-Drop",@"UITableView:Drag-Drop",@"UIView:Drag-Drop"]
                         type:UIAlertControllerStyleActionSheet
                andParentView:nil
                    andAction:^(NSInteger buttonIndex) {
                        UIViewAnimationOptions direction = _lastDirection == UIViewAnimationOptionTransitionFlipFromLeft? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
                        [UIView transitionWithView:self.animationBgView duration:0.5 options:direction animations:^{
                            if (buttonIndex == 0) {
                                
                            } else if (buttonIndex == 1) {
                                self.dragCollectionView.hidden = NO;
                                self.dragTableView.hidden = YES;
                                self.dragView.hidden = YES;
                                _titleView.label.text = @"UICollectionView:Drag-Drop";
                            } else if (buttonIndex == 2) {
                                self.dragCollectionView.hidden = YES;
                                self.dragTableView.hidden = NO;
                                self.dragView.hidden = YES;
                                _titleView.label.text = @"UITableView:Drag-Drop";
                            } else if (buttonIndex == 3) {
                                self.dragCollectionView.hidden = YES;
                                self.dragTableView.hidden = YES;
                                self.dragView.hidden = NO;
                                _titleView.label.text = @"UIView:Drag-Drop";
                            }
                        } completion:^(BOOL finished) {
                            
                        }];
                        
                    }];
}

@end














