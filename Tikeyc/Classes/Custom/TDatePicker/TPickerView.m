//
//  TDatePicker.m
//  Tikeyc
//
//  Created by ways on 16/10/11.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "TPickerView.h"

@interface TPickerView ()<UIPickerViewDataSource>


- (IBAction)topCancelButtonAction:(UIButton *)sender;

- (IBAction)topSureButtonAction:(UIButton *)sender;


@end

@implementation TPickerView

- (instancetype)initWithFrame:(CGRect)frame type:(TPickerViewType)pickerViewType{
    self = [super initWithFrame:frame];
    if (self) {
        self.pickerViewType = pickerViewType;
        [self initSubViewAndProperty];
    }
    return self;
}

#pragma mark - init

- (void)initSubViewAndProperty{
    switch (self.pickerViewType) {
        case TPickerViewTypeCustom:
        {
            self.customPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            self.customPickerView.delegate = (id)self;
            
            [self addSubview:self.customPickerView];
        }
            break;
        case TPickerViewTypeDatePicker:
        {
            self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            self.datePicker.datePickerMode = UIDatePickerModeDate;
            //locale calendar timeZone date minimumDate maximumDate  还是在外部设置吧
//            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//@"zh-Hant" @"en_US" ，@"fr_FR"（法文.法国）
//            self.datePicker.locale = locale;
//            self.datePicker.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
            
            [self addSubview:self.datePicker];
        }
            break;
            
        default:
            break;
    }
}


- (void)setIsShowTopControlView:(BOOL)isShowTopControlView{
    _isShowTopControlView = isShowTopControlView;
    
    if (_isShowTopControlView) {
        UIView *topControlView = [[[NSBundle mainBundle] loadNibNamed:@"TPickerViewTopControl" owner:self options:NULL] lastObject];
        topControlView.frame = CGRectMake(0, 0, self.width, 49);
        [self addSubview:topControlView];
        self.customPickerView.frame = CGRectMake(0, topControlView.bottom, self.width, self.height - topControlView.height);
        self.datePicker.frame = CGRectMake(0, topControlView.bottom, self.width, self.height - topControlView.height);
    }
}

#pragma mark - set

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode{
    
    _datePickerMode = datePickerMode;
    //
    self.datePicker.datePickerMode = _datePickerMode;
}

#pragma mark - UIPickerViewDataSource 当pickerViewType == TPickerViewTypeCustom时才关注以下代码

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _pickerRowDatas.count;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSMutableArray *rowDatas = _pickerRowDatas[component];
    //
    NSString *decsString = [NSString stringWithFormat:@"component=%ld 时传入的pickerRowDatas非二维数组，无法设置UIPickerView的rows",(long)component];
    NSAssert([rowDatas isKindOfClass:[NSArray class]], decsString);
    
    return rowDatas.count;
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 200;
    }
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSMutableArray *rowDatas = _pickerRowDatas[component];
    
    id title = rowDatas[row];
    
    if (![title isKindOfClass:[NSString class]]) {
        title = [NSString stringWithFormat:@"%@",title];
    }
    
    return title;
}

//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSMutableArray *rowDatas = _pickerRowDatas[component];
//    
//    NSString *title = rowDatas[row];
//    
//    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont fontNamesForFamilyName:@""]}];
//    
//    return attributedTitle;
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
//    return nil;
//}

//seleted row action
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSMutableArray *rowDatas = _pickerRowDatas[component];
    
    NSString *title = rowDatas[row];
    
    NSLog(@"%@",title);
}

#pragma mark - topControlView Actions method

- (IBAction)topCancelButtonAction:(UIButton *)sender {
    NSLog(@"Cancel");
    //or add animation
    self.hidden = YES;
}

- (IBAction)topSureButtonAction:(UIButton *)sender {
    NSLog(@"Sure");
    
    if (self.selectRowBlock) {
        self.selectRowBlock(@"call selectRowBlock...");
    }

    //or add animation
    self.hidden = YES;
}

@end




