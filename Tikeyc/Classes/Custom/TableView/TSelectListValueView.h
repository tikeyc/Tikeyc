//
//  TSelectListValueView.h
//  LoveShare
//
//  Created by ways on 2017/6/21.
//  Copyright © 2017年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SelectedValueBlock)(id value);

@interface TSelectListValueView : UIView

@property (nonatomic,strong)UITableView *myTableView;

@property (nonatomic,strong)NSArray *listValue;

@property (nonatomic,copy) SelectedValueBlock selectedValueBlock;

- (void)selectListValueViewIsShow:(BOOL)isShow
                    withListValue:(NSArray *)listValue;

@end
