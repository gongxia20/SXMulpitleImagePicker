//
//  SXMImageChooserCell.m
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import "SXMImageChooserCell.h"
#define kInt(x) [@(x) intValue]

@interface SXMImageChooserCell()
@property (nonatomic) int numberOfAssets;
@property (nonatomic) CGSize imageSize;
@property (nonatomic) CGFloat margin;
@end

@implementation SXMImageChooserCell

#pragma mark -public methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageSize:(CGSize)imageSize numberOfAssets:(int)numberOfAssets margin:(CGFloat)margin
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self) {
        
        self.numberOfAssets = numberOfAssets;
        self.imageSize = imageSize;
        self.margin = margin;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        for(UIView *subview in self.contentView.subviews) {
            if([subview isMemberOfClass:[SXImageDisplayerView class]]) {
                [subview removeFromSuperview];
            }
        }
        
        for(int i = 0; i < numberOfAssets; i++) {
            CGFloat offset = (margin + imageSize.width) * i;
            CGRect rect = CGRectMake(offset + margin, margin, imageSize.width, imageSize.height);
            SXImageDisplayerView *imageView = [[SXImageDisplayerView alloc] initWithFrame:rect];
            imageView.delegate = self;
            imageView.tag = 1 + i;
            imageView.autoresizingMask = UIViewAutoresizingNone;
            [self.contentView addSubview:imageView];
        }
        
    }
    
    return self;
}

- (void)selectAssetAtIndex:(int)index
{
    SXImageDisplayerView *assetView = (SXImageDisplayerView *)[self.contentView viewWithTag:(index + 1)];
    assetView.selected = YES;
}

- (void)deselectAssetAtIndex:(int)index
{
    SXImageDisplayerView *assetView = (SXImageDisplayerView *)[self.contentView viewWithTag:(index + 1)];
    assetView.selected = NO;
}

-(void)dealloc
{
    _assets = nil;
}

#pragma mark - property methods
- (void)setAssets:(NSArray *)assets
{
    _assets = assets;

    for(int i = 0; i < self.numberOfAssets; i++) {
        SXImageDisplayerView *assetView = (SXImageDisplayerView *)[self.contentView viewWithTag:(1 + i)];
        if(i < self.assets.count) {
            assetView.hidden = NO;
            assetView.asset = self.assets[i];
        } else {
            assetView.hidden = YES;
        }
    }
}

- (void)setAllowsMulSelection:(BOOL)allowsMulSelection
{
    _allowsMulSelection = allowsMulSelection;
    for(UIView *subview in self.contentView.subviews) {
        if([subview isMemberOfClass:[SXImageDisplayerView class]]) {
            [(SXImageDisplayerView *)subview setAllowsMulSelection:self.allowsMulSelection];
        }
    }
}

#pragma mark - SXImageDisplayerViewDelegate
- (BOOL)imageViewCanBeSelected:(SXImageDisplayerView *)imageDisplayerView
{
    return [self.delegate imageChooserCell:self atIndex:(kInt(imageDisplayerView.tag) - 1)];
}

- (void)imageView:(SXImageDisplayerView *)imageDisplayerView state:(BOOL)selected
{
    [self.delegate imageChooserCell:self state:selected atIndex:(kInt(imageDisplayerView.tag) - 1)];
}

@end
