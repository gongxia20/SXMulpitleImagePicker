//
//  SXImageDisplayerView.m
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import "SXImageDisplayerView.h"

@interface SXImageDisplayerView()
{
    UIImageView *_imageView;
    UIImageView *_selectedView;
}
@end

@implementation SXImageDisplayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //image
        UIImageView *image = [[UIImageView alloc]initWithFrame:self.bounds];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        image.clipsToBounds = YES;
        [self addSubview:image];
        _imageView = image;
        
        //chooseImage
        UIImageView *choosed = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 24 - 5, self.frame.size.height - 24 - 5, 24, 24)];
        choosed.contentMode = UIViewContentModeScaleAspectFill;
        choosed.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleRightMargin;
        
        choosed.image = [UIImage imageNamed:@"image_choosed.png"];
        
        choosed.hidden = YES;
        [self addSubview:choosed];
        _selectedView = choosed;
    }
    return self;
}
- (void)dealloc
{
    _imageView = nil;
    _selectedView = nil;
    _asset = nil;
    
}

#pragma mark - property methods
- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    _imageView.image = [self getThumbImage];
}

- (void)setSelected:(BOOL)selected
{
    if(self.allowsMulSelection)
        _selectedView.hidden = !selected;
}

- (BOOL)selected
{
    return !_selectedView.hidden;
}


#pragma mark - Touch Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self.delegate imageViewCanBeSelected:self]) {
        _imageView.image = [self getShadowImage];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self.delegate imageViewCanBeSelected:self])
    {
        self.selected = !self.selected;
        _imageView.image = [self getThumbImage];
        [self.delegate imageView:self state:self.selected];
    }
    else
    {
        if(self.selected)
        {
            self.selected = !self.selected;
            _imageView.image = [self getThumbImage];
            [self.delegate imageView:self state:self.selected];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _imageView.image = [self getThumbImage];
}

#pragma mark - myself Methods
-(UIImage*)getThumbImage
{
    return [UIImage imageWithCGImage:[self.asset thumbnail]];
}

-(UIImage*)getShadowImage
{
    UIImage *image = [self getThumbImage];
    
    UIGraphicsBeginImageContext(image.size);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [image drawInRect:rect];
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceAtop);
    UIImage *shoadowImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return shoadowImage;
}

@end
