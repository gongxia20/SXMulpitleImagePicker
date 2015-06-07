//
//  SXMulpitleImageChooser.m
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import "SXMulpitleImageChooser.h"
#import "SXMImageFooterCell.h"
#define kInt(x) [@(x) intValue]

@interface SXMulpitleImageChooser ()<UITableViewDataSource, UITableViewDelegate, SXMImageChooserCellDelegate>
{
    CGFloat         _margin;
    CGSize          _imageSize;
    BOOL            _hasFooterCell;
    NSInteger       _dataRowCount;
    int             _numberOfAssetsInRow;
    UIBarButtonItem * _doneButton;
}

@property (strong, nonatomic) UITableView         *tableView;
@property (strong, nonatomic) NSMutableArray      *assets;
@property (strong, nonatomic) NSMutableOrderedSet *selectedAssets;

@end

static NSString *cellIdentifier = @"ImageCell";

@implementation SXMulpitleImageChooser

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.assets = [NSMutableArray array];
        self.selectedAssets = [NSMutableOrderedSet orderedSet];
        
        _imageSize = CGSizeMake(75, 75);
        _numberOfAssetsInRow = self.view.bounds.size.width / _imageSize.width;
        _margin = round((self.view.bounds.size.width - _imageSize.width * _numberOfAssetsInRow) / (_numberOfAssetsInRow + 1));
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAssets];
    [self initUIBarButton];
    
    _hasFooterCell = self.tableView.contentSize.height - self.tableView.frame.size.height > 0;
    [self.tableView reloadData];
    if(_hasFooterCell)
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height) animated:NO];
}


-(void)deallocDelegate
{
    SXMImageChooserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    while (cell) {
        cell.delegate = nil;
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  (indexPath.row == _dataRowCount) ? 44 : (_margin + _imageSize.height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.assets.count / _numberOfAssetsInRow;
    // 大于0
    if(self.assets.count - count * _numberOfAssetsInRow)
        count++;
    _dataRowCount = count;
    
    if(_hasFooterCell)
    {
        return count ? (count + 1) : 0;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _dataRowCount)
    {
        SXMImageFooterCell *cell = [[SXMImageFooterCell alloc] initWithFooterString:[NSString stringWithFormat:@"%lu张照片",(unsigned long)self.assets.count]];
        return cell;
    }
    
    SXMImageChooserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[SXMImageChooserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier imageSize:_imageSize numberOfAssets:_numberOfAssetsInRow margin:_margin];
        cell.delegate = self;
    }
    
    int offset = kInt(_numberOfAssetsInRow) * kInt(indexPath.row);
    int numberOfAssets = (offset + _numberOfAssetsInRow > self.assets.count) ? (kInt(self.assets.count) - offset) : _numberOfAssetsInRow;
    
    NSMutableArray *assets = [NSMutableArray array];
    for(int i = 0; i < numberOfAssets; i++) {
        ALAsset *asset = self.assets[offset + i];
        
        [assets addObject:asset];
    }
    [cell setAllowsMulSelection:self.allowsMulSelection];
    [cell setAssets:assets];
    
    for(NSUInteger i = 0; i < numberOfAssets; i++) {
        ALAsset *asset = self.assets[offset + i];
        
        if([self.selectedAssets containsObject:asset]) {
            [(SXMImageChooserCell *)cell selectAssetAtIndex:kInt(i)];
        } else {
            [(SXMImageChooserCell *)cell deselectAssetAtIndex:kInt(i)];
        }
    }
    
    return cell;
}

#pragma mark - myself Methods
- (void)done
{
    [self.delegate mulpitleImageChooserPicker:self
                       didFinishPickingAssets:self.selectedAssets.array];
}

-(void)cancel
{
    [self.delegate mulpitleImageChooserDidCancel:self];
}

-(void)getAssets
{
    // 获取相片
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            [self.assets addObject:result];
        }
    }];
    
    [self.tableView reloadData];
}

-(void) initUIBarButton
{
    if(_allowsMulSelection)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(done)];
        doneButton.enabled = NO;
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
        _doneButton = doneButton;
    }
    else
    {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(cancel)];
        cancelButton.enabled = YES;
        [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
    }
}

#pragma mark - SXMImageChooserCellDelegate
- (BOOL)imageChooserCell:(SXMImageChooserCell *)imageChooserCell atIndex:(int)index
{
    if(self.maxImageCount == 0 || self.allowsMulSelection == NO)
    {
        return YES;
    }
    return self.selectedAssets.count < self.maxImageCount;
}

- (void)imageChooserCell:(SXMImageChooserCell *)imageChooserCell state:(BOOL)selected atIndex:(int)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:imageChooserCell];
    
    int assetIndex = kInt(indexPath.row) * kInt(_numberOfAssetsInRow) + index;
    ALAsset *asset = self.assets[assetIndex];
    
    if(_allowsMulSelection)
    {
        if(selected) {
            [self.selectedAssets addObject:asset];
        } else {
            [self.selectedAssets removeObject:asset];
        }
        
        _doneButton.enabled = self.selectedAssets.count > self.minImageCount;
    }
    else
    {
        [self.delegate mulpitleImageChooserPicker:self didFinishPickingAsset:asset];
    }
}
#pragma mark - getters and setters

-(UITableView *)tableView
{
    if (!_tableView) {
        CGRect rect = self.view.frame;
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = YES;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}
@end
