//
//  TMethodDefine.h
//  Tikeyc
//
//  Created by ways on 16/9/14.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#ifndef TMethodDefine_h
#define TMethodDefine_h

//////////////////////set NavigationItem.titleView
#define TsetNavigationItem_titleView_withImgName(imageName) \
UIImage *image = [UIImage imageNamed:imageName]; \
UIImageView *titleView = [[UIImageView alloc] initWithImage:image]; \
titleView.frame = CGRectMake(0, 0, image.size.width, image.size.height); \
self.navigationItem.titleView = titleView; \

//////////////////////set navigationBar backgroundImage
#define TsetNavigationBarBackgroundImage_withImage(image) \
[self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault]; \

#endif /* TMethodDefine_h */
