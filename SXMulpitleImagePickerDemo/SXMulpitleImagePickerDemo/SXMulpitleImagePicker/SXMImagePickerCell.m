//
//  SXMImagePickerCell.m
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import "SXMImagePickerCell.h"
#import "SXMulpitleImagePicker.h"
@interface SXMImagePickerCell()
{
    UIImageView *_image;
    UILabel *_name;
    UILabel *_count;
    UIImageView *_line;
}
@end
@implementation SXMImagePickerCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView setFrame:CGRectMake(0,0,320,66)];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleLeftMargin;
        [self initLayout];
    }
    return self;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *cellIdentifier = @"MImagePickerCell";
    SXMImagePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[SXMImagePickerCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)dealloc
{
    _image = nil;
    _count = nil;
    _name = nil;
    _line = nil;
    
}

-(void)initLayout
{
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(8,5,56,56)];
    [self.contentView addSubview:_image];
    
    _name = [[UILabel alloc]initWithFrame:CGRectMake(80,14,200,21)];
    _name.font = [UIFont systemFontOfSize:17];
    _name.textColor = [UIColor blackColor];
    [self.contentView addSubview:_name];
    
    _count = [[UILabel alloc]initWithFrame:CGRectMake(80,35,200,21)];
    _count.font = [UIFont systemFontOfSize:15];
    _count.textColor = [UIColor blackColor];
    [self.contentView addSubview:_count];

    CGRect rect = self.contentView.frame;
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x,rect.size.height - 1,rect.size.width,1)];
    _line.image = [UIImage  imageNamed:@"im_cellLine.png"];
    [self.contentView addSubview:_line];
}

-(void)setCellData:(ALAssetsGroup*)data hasLine:(BOOL)flg
{
    if(flg)
    {
        _name.text = IMAGEPICKER_ALLIMAGE;
        CGRect viewRect = self.contentView.frame;
        CGRect labelRect = _name.frame;
        labelRect.origin.y = (viewRect.size.height - labelRect.size.height)/2;
        [_name setFrame:labelRect];
        _count.hidden = YES;
    }
    else
    {
        _name.text = [NSString stringWithFormat:@"%@", [data valueForProperty:ALAssetsGroupPropertyName]];
        _count.text = [NSString stringWithFormat:@"%ld", (long)data.numberOfAssets];
        _count.hidden = NO;
    }
    _image.image = [UIImage imageWithCGImage:data.posterImage];
    _line.hidden = !flg;
}

@end
