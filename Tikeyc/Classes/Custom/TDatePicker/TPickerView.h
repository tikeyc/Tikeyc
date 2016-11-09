//
//  TDatePicker.h
//  Tikeyc
//
//  Created by ways on 16/10/11.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 此类暂未封装完成...
 
 
 */

typedef enum : NSUInteger {
    TPickerViewTypeCustom = 0,
    TPickerViewTypeDatePicker,
} TPickerViewType;

typedef void(^PickerViewDidSelectRowBlock)(id object);

@interface TPickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(TPickerViewType)pickerViewType;

/////////////////////////commen

@property (nonatomic,assign)TPickerViewType pickerViewType;

@property (nonatomic,copy)PickerViewDidSelectRowBlock selectRowBlock;

@property (nonatomic,assign)BOOL isShowTopControlView;


////////////////////////////////////////////////TPickerViewTypeCustom

@property (nonatomic,strong)UIPickerView *customPickerView;


/**pickerRowDatas
 多维维数组: @[@[value,value,...],@[value,value,...],@[]...]
 外层确定pickerView的numberOfComponents
 内层确定pickerView的numberOfRowsInComponent 以及 titleForRow
 */
@property (nonatomic,strong)NSMutableArray *pickerRowDatas;


//////////////////////////////////////////////TPickerViewTypeDatePicker

@property (nonatomic,strong)UIDatePicker *datePicker;

@property (nonatomic,assign)UIDatePickerMode datePickerMode;

@end

