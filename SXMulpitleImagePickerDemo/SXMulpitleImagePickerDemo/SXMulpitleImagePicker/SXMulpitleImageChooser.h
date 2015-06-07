//
//  SXMulpitleImageChooser.h
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SXMImageChooserCell.h"

@class SXMulpitleImageChooser;
@protocol SXMulpitleImageChooserDelegate <NSObject>

@required
- (void)mulpitleImageChooserDidCancel:(id)picker;

@optional
- (void)mulpitleImageChooserPicker:(id)picker didFinishPickingAssets:(NSArray *)assets;
- (void)mulpitleImageChooserPicker:(id)picker didFinishPickingAsset:(ALAsset *)asset;
@end

@interface SXMulpitleImageChooser : UIViewController

@property (nonatomic) int  minImageCount;
@property (nonatomic) int  maxImageCount;
@property (nonatomic) BOOL allowsMulSelection;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, assign) id<SXMulpitleImageChooserDelegate> delegate;

@end
