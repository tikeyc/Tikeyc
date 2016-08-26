//
//  PaperButton.h
//  Popping
//
//  Created by André Schneider on 12.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPopButton : UIControl


@property(nonatomic) BOOL showMenu;

+ (instancetype)button;
+ (instancetype)buttonWithOrigin:(CGPoint)origin;

- (void)animateToMenu;
- (void)animateToClose;

@end
