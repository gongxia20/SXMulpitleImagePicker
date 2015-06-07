//
//  SXMImagePickerCell.h
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface SXMImagePickerCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)setCellData:(ALAssetsGroup*)data hasLine:(BOOL)flg;
@end
