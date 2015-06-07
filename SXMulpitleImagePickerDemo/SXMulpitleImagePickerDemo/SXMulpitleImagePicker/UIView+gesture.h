
//
//  UIView+gesture.h
//  te
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 快速UIView添加单击 长按手势 */
@interface UIView (gesture)


/** 给view添加单击手势 */

- (void)setTapActionWithBlock:(void (^)(void))block;


/** 给view添加长按手势 */
- (void)setLongPressActionWithBlock:(void (^)(void))block;

@end
