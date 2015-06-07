//
//  SXMImageFooterCell.m
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import "SXMImageFooterCell.h"

@implementation SXMImageFooterCell

-(id)initWithFooterString:(NSString*)str
{
    self = [super init];
    if(self)
    {
        UILabel *footerLabel = [[UILabel alloc]initWithFrame:self.bounds];
        footerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        footerLabel.font = [UIFont systemFontOfSize:16];
        footerLabel.textColor = [UIColor blackColor];
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.text = str;
        [self addSubview:footerLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

-(void)dealloc
{
    
}

@end
