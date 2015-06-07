//
//  SXMulpitleImagePicker.h
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SXMulpitleImageChooser_Time.h"

#define IMAGEPICKER_ALLIMAGE (@"所有照片")

@class SXMulpitleImagePicker;

@protocol MulpitleImagePickerDelegate <NSObject>

@required
- (void)mulpitleImagePickerDidCancel:(SXMulpitleImagePicker *)picker;

@optional
- (void)mulpitleImagePicker:(SXMulpitleImagePicker *)picker didFinishPickingAssets:(NSArray *)assets;
- (void)mulpitleImagePicker:(SXMulpitleImagePicker *)picker didFinishPickingAsset:(ALAsset *)asset;

@end

@interface SXMulpitleImagePicker : UIViewController

@property (nonatomic) int  minImageCount;
@property (nonatomic) int  maxImageCount;
@property (nonatomic) BOOL allowsMulSelection;
@property (nonatomic, assign) id<MulpitleImagePickerDelegate> delegate;

@end