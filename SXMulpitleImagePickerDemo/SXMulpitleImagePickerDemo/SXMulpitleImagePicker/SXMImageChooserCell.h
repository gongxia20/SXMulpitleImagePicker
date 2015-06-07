//
//  SXMImageChooserCell.h
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "SXImageDisplayerView.h"

@class SXMImageChooserCell;
@protocol SXMImageChooserCellDelegate <NSObject>

@required
- (BOOL)imageChooserCell:(SXMImageChooserCell *)imageChooserCell atIndex:(int)index;
- (void)imageChooserCell:(SXMImageChooserCell *)imageChooserCell state:(BOOL)selected atIndex:(int)index;
@end

@interface SXMImageChooserCell : UITableViewCell<SXImageDisplayerViewDelegate>
@property (nonatomic, assign) id<SXMImageChooserCellDelegate> delegate;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic) BOOL allowsMulSelection;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageSize:(CGSize)imageSize numberOfAssets:(int)numberOfAssets margin:(CGFloat)margin;

- (void)selectAssetAtIndex:(int)index;
- (void)deselectAssetAtIndex:(int)index;

@end
