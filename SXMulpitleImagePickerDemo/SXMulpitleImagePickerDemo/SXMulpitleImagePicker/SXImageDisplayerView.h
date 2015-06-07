//
//  SXImageDisplayerView.h
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@class SXImageDisplayerView;
@protocol SXImageDisplayerViewDelegate <NSObject>
@required
- (BOOL)imageViewCanBeSelected:(SXImageDisplayerView *)imageDisplayerView;
- (void)imageView:(SXImageDisplayerView *)imageDisplayerView state:(BOOL)selected;
@end

@interface SXImageDisplayerView : UIView
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL allowsMulSelection;
@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic,assign) id<SXImageDisplayerViewDelegate> delegate;
@end