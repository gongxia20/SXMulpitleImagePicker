//
//  SXMulpitleImageChooser_Time.h
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXMulpitleImageChooser.h"

@interface SXMulpitleImageChooser_Time : UIViewController
@property (nonatomic, assign) id<SXMulpitleImageChooserDelegate> delegate;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic) BOOL allowsMulSelection;
@property (nonatomic) int minImageCount;
@property (nonatomic) int maxImageCount;

@end
