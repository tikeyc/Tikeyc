//
//  TMainMenuViewController.m
//  Tikeyc
//
//  Created by ways on 16/8/15.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TMainMenuViewController.h"

#import "TPopButton.h"

#define Pan_left_MaxWith self.view.width*2/3
#define Pan_right_MaxWith self.view.width*1/3
#define Center_Animation_durition 1.0

@interface TMainMenuViewController ()

{
    CGPoint _startPoint;
    
    TPopButton *_leftPopButton;
    TPopButton *_rightPopButton;
}

@property (strong, nonatomic)  UIView *centerView;
@property (strong, nonatomic)  UIView *leftView;
@property (strong, nonatomic)  UIView *rightView;

@property (nonatomic,strong) UITapGestureRecognizer *backCenterTap;

@end

@implementation TMainMenuViewController

- (instancetype)initMainMenuWithCenterViewController:(UIViewController *)centerViewController
                                  leftViewController:(UIViewController *)leftViewController
                                 rightViewController:(UIViewController *)rightViewController{
    self = [super init];
    
    if (self) {
        NSAssert(centerViewController, @"没有设置中间控制器");
        
        
        //
        [self setCenterViewController:centerViewController];//必须第一个设置，以便self.centerView在最上面
        self.leftViewController = leftViewController;
        self.rightViewController = rightViewController;
        
        
        
    }
    
    return self;
}

- (instancetype _Nullable)initMainMenuWithCenterViewController:(UIViewController *_Nullable)centerViewController{
    self = [super init];
    
    if (self) {
        NSAssert(centerViewController, @"没有设置中间控制器");
        [self setCenterViewController:centerViewController];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setSubViewsProperty];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addGestureRecognizerToCenterView];
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

#pragma mark - set

- (void)setCenterViewController:(UIViewController * _Nullable)centerViewController{
    _centerViewController = centerViewController;
    
    //
    self.centerView = _centerViewController.view;
    [self.view addSubview:self.centerView];
    self.centerView.frame = self.view.frame;
    self.centerView.backgroundColor = [UIColor orangeColor];
}

- (void)setLeftViewController:(UIViewController *)leftViewController{
    _leftViewController = leftViewController;
    
    //
    self.leftView = _leftViewController.view;
    [self.view insertSubview:self.leftView belowSubview:self.centerView];//self.centerView已经创建
//    [self.view addSubview:self.leftView];
    self.leftView.frame = self.view.frame;
    self.leftView.backgroundColor = [UIColor redColor];
}

- (void)setRightViewController:(UIViewController *)rightViewController{
    _rightViewController = rightViewController;
    
    //
    self.rightView = _rightViewController.view;
    [self.view insertSubview:self.rightView belowSubview:self.centerView];//self.centerView已经创建
//    [self.view addSubview:self.rightView];
    self.rightView.frame = self.view.frame;
    
}

- (void)setShowLeftBarButtonItem:(BOOL)showLeftBarButtonItem{
    _showLeftBarButtonItem = showLeftBarButtonItem;
    
    if (![_centerViewController isKindOfClass:[UINavigationController class]]) {
        return;
    }
    if (!_leftPopButton) {
        _leftPopButton = [TPopButton button];
        _leftPopButton.tag = 1;
        [_leftPopButton addTarget:self action:@selector(showLeftOrRightView:) forControlEvents:UIControlEventTouchUpInside];
        _leftPopButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:_leftPopButton];
        self.centerViewController.navigationItem.leftBarButtonItem = barButton;
        
    }
    if (_showLeftBarButtonItem){
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:_leftPopButton];
        UIViewController *firstVC = [((UINavigationController *)self.centerViewController).viewControllers firstObject];
        firstVC.navigationItem.leftBarButtonItem = barButton;
    }else{
        UIViewController *firstVC = [((UINavigationController *)self.centerViewController).viewControllers firstObject];
        firstVC.navigationItem.leftBarButtonItem = nil;
    }
}


- (void)setShowRighBarButtonItem:(BOOL)showRighBarButtonItem{
    _showRighBarButtonItem = showRighBarButtonItem;
    
    if (![_centerViewController isKindOfClass:[UINavigationController class]]) {
        return;
    }
    if (!_rightPopButton) {
        _rightPopButton = [TPopButton button];
        _rightPopButton.tag = 2;
        [_rightPopButton addTarget:self action:@selector(showLeftOrRightView:) forControlEvents:UIControlEventTouchUpInside];
        _rightPopButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:_rightPopButton];
        
        self.centerViewController.navigationItem.rightBarButtonItem = barButton;
    }
    if (_showRighBarButtonItem){
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:_rightPopButton];
        UIViewController *firstVC = [((UINavigationController *)self.centerViewController).viewControllers firstObject];
        firstVC.navigationItem.rightBarButtonItem = barButton;
    }else{
        UIViewController *firstVC = [((UINavigationController *)self.centerViewController).viewControllers firstObject];
        firstVC.navigationItem.rightBarButtonItem = nil;
    }

}

#pragma mark - init


- (void)setSubViewsProperty{
//    [self.view addSubview:self.leftView];
//    [self.view addSubview:self.rightView];
//    [self.view addSubview:self.centerView];
//    self.centerView.frame = self.view.frame;
//    self.centerView.backgroundColor = [UIColor orangeColor];
//    self.leftView.frame = self.view.frame;
//    self.leftView.backgroundColor = [UIColor redColor];
//    self.rightView.frame = self.view.frame;
}

- (void)addGestureRecognizerToCenterView{
    if (!_leftViewController && !_rightViewController) {
        return;
    }
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];

    [self.centerView addGestureRecognizer:_panGestureRecognizer];
    //
    _backCenterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    if ([_centerViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *firstVC = [((UINavigationController *)self.centerViewController).viewControllers firstObject];
        [firstVC.view addGestureRecognizer:_backCenterTap];
    }else{
        [self.centerView addGestureRecognizer:_backCenterTap];
    }

}


#pragma mark - Method Actions

- (void)showLeftOrRightView:(TPopButton *)button{
    CGFloat left_X;
    if (button == _leftPopButton) {
        NSAssert(_leftViewController, @"没有设置左侧控制器");
        if (_rightPopButton.showMenu) {
            [_rightPopButton animateToMenu];
        }
        
        if (button.selected) {
            left_X = 0;
            button.selected = NO;
        }else{
            left_X = Pan_left_MaxWith;
            button.selected = YES;
        }
    }else if (button == _rightPopButton){
        NSAssert(_leftViewController, @"没有设置右侧控制器");
        if (_leftPopButton.showMenu) {
            [_leftPopButton animateToMenu];
        }
        
        if (button.selected) {
            left_X = 0;
            button.selected = NO;
        }else{
            left_X = -Pan_right_MaxWith;
            button.selected = YES;
        }
        
    }
    
    _panGestureRecognizer.enabled = NO;//防止动画过程中滑动手势
    [UIView animateWithDuration:Center_Animation_durition delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.centerView.left = left_X;
        if (left_X > 0) {
            self.leftView.hidden = NO;
            self.rightView.hidden = YES;
        }else{
            self.leftView.hidden = YES;
            self.rightView.hidden = NO;
        }
    } completion:^(BOOL finished) {
        _panGestureRecognizer.enabled = YES;
        
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)backCenterTap{
    self.leftView.hidden = YES;
    self.rightView.hidden = YES;
    [_leftPopButton animateToMenu];
    [_rightPopButton animateToMenu];
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.centerView.left = 0;
    } completion:^(BOOL finished) {
        
        
    }];
}


- (void)panAction:(UIPanGestureRecognizer *)pan{
    CGPoint point = [pan locationInView:self.centerView];
    NSLog(@"move point:%@",NSStringFromCGPoint(point));
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            _startPoint = point;
            _backCenterTap.enabled = YES;//当出现左右视图时打开手势
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat x_offSet = point.x - _startPoint.x;
            NSLog(@"x_offSet:%f",x_offSet);
            
            self.centerView.left = self.centerView.left + x_offSet;
            //控制leftView，rightView的隐藏状态
            if (self.centerView.left > 0) {
                
                if (self.leftViewController) {
                    self.leftView.hidden = NO;
                    self.rightView.hidden = YES;
                }else{
                    //当不存在左控制器时
//                    pan.enabled = NO;
                    self.centerView.left = 0;
                    return;
                }
            }else{
                
                if (self.rightViewController) {
                    self.leftView.hidden = YES;
                    self.rightView.hidden = NO;
                }else{
                    //当不存在右控制器时
//                    pan.enabled = NO;
                    self.centerView.left = 0;
                    return;
                }
 
            }
            //////////控制centerView的位置
            //显示左侧视图逻辑
            if (self.centerView.left > Pan_left_MaxWith/3/*控制主动滑动到当前方向所设置的极限位置*/) {
                if (x_offSet > 0) {
                    [_leftPopButton animateToClose];
                    pan.enabled = NO;//防止动画过程中滑动手势
                    [UIView animateWithDuration:Center_Animation_durition delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.centerView.left = Pan_left_MaxWith;
                    } completion:^(BOOL finished) {
                        pan.enabled = YES;
                        
                    }];
                }else{
                    
                }
                
            }else if (self.centerView.left > 0 && self.centerView.left < Pan_left_MaxWith*2/3){
                if (x_offSet < 0) {
                    [_leftPopButton animateToMenu];
                    pan.enabled = NO;//防止动画过程中滑动手势
                    [UIView animateWithDuration:Center_Animation_durition delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.centerView.left = 0;
                    } completion:^(BOOL finished) {
                        pan.enabled = YES;
                        
                    }];
                }
            }
            //显示右侧视图逻辑
            if (self.centerView.left < -Pan_right_MaxWith/3/*控制主动滑动到当前方向所设置的极限位置*/) {
                if (x_offSet < 0) {
                    [_rightPopButton animateToClose];
                    pan.enabled = NO;
                    [UIView animateWithDuration:Center_Animation_durition delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.centerView.left = -Pan_right_MaxWith;
                    } completion:^(BOOL finished) {
                        pan.enabled = YES;
                    }];
                }
                
                
            }else if (self.centerView.left < 0 && self.centerView.left > -Pan_right_MaxWith*2/3){
                if (x_offSet > 0) {
                    [_rightPopButton animateToMenu];
                    pan.enabled = NO;//防止动画过程中滑动手势
                    [UIView animateWithDuration:Center_Animation_durition delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.centerView.left = 0;
                    } completion:^(BOOL finished) {
                        pan.enabled = YES;
                        
                    }];
                }
            }
            
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            pan.enabled = YES;
            
            CGFloat x_offSet = point.x - _startPoint.x;
            NSLog(@"x_offSet:%f",x_offSet);
            
            self.centerView.left = self.centerView.left + x_offSet;
            //控制leftView，rightView的隐藏状态
            if (self.centerView.left > 0) {
                
                if (self.leftViewController) {
                    self.leftView.hidden = NO;
                    self.rightView.hidden = YES;
                }else{
                    //当不存在左控制器时
                    self.centerView.left = 0;
                    return;
                }
            }else{
                
                if (self.rightViewController) {
                    self.leftView.hidden = YES;
                    self.rightView.hidden = NO;
                }else{
                    //当不存在右控制器时
                    self.centerView.left = 0;
                    return;
                }
                
            }
            //控制centerView的位置
            //显示左侧视图逻辑
            if (x_offSet <= 0 && self.centerView.left > 0) {
                
                _backCenterTap.enabled = NO;//当左右视图消失时关闭手势
                
                CGFloat left_X;
                if (self.centerView.left <= Pan_left_MaxWith*2/3) {
                    [_leftPopButton animateToMenu];
                    left_X = 0;
                }else{
                    [_leftPopButton animateToClose];
                    left_X = Pan_left_MaxWith;
                }
                [UIView animateWithDuration:Center_Animation_durition delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.centerView.left = left_X;
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            //显示右侧视图逻辑
            if (x_offSet >= 0 && self.centerView.left < 0) {
                [_rightPopButton animateToMenu];
                _backCenterTap.enabled = NO;//当左右视图消失时关闭手势
                
                CGFloat left_X;
                if (self.centerView.left >= -Pan_right_MaxWith*2/3) {
                    [_leftPopButton animateToMenu];
                    left_X = 0;
                }else{
                    [_leftPopButton animateToClose];
                    left_X = Pan_right_MaxWith;
                }
                [UIView animateWithDuration:Center_Animation_durition delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.centerView.left = left_X;
                } completion:^(BOOL finished) {
                    
                }];
                
                
            }

        }
            break;
            
        default:
            break;
    }
}

@end










