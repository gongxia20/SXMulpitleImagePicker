//
//  SXMulpitleImageChooser_Time.m
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import "SXMulpitleImageChooser_Time.h"
#import "SXMImageFooterCell.h"
#define kInt(x) [@(x) intValue]

@interface SXMulpitleImageChooser_Time ()<UITableViewDataSource, UITableViewDelegate, SXMImageChooserCellDelegate>
{
    UITableView *_tableView;
    NSMutableDictionary *_assetsDic;
    NSArray *_orderAllKey;
    UIBarButtonItem *_doneButton;
    
    CGSize _imageSize;
    int _numberOfAssetsInRow;
    CGFloat _margin;
    BOOL _hasFooterCell;
    int _sectionCount;
    int _lastSectionRowCount;
    
    int _assetsCount;
}
@property (nonatomic, strong) NSMutableOrderedSet *selectedAssets;
@end
static NSString *cellIdentifier = @"ImageCell";
@implementation SXMulpitleImageChooser_Time

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _assetsDic = [[NSMutableDictionary alloc]init];
        self.selectedAssets = [[NSMutableOrderedSet alloc]init];
        
        _imageSize = CGSizeMake(75, 75);
        _numberOfAssetsInRow = self.view.bounds.size.width / _imageSize.width;
        _margin = round((self.view.bounds.size.width - _imageSize.width * _numberOfAssetsInRow) / (_numberOfAssetsInRow + 1));
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = self.view.frame;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadImageData];
    [self initUIBarButton];
    
    _hasFooterCell = _tableView.contentSize.height - _tableView.frame.size.height > 0;
    [_tableView reloadData];
    if(_hasFooterCell)
        [_tableView setContentOffset:CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height) animated:NO];
}


-(void)deallocDelegate
{
    SXMImageChooserCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    while (cell) {
        cell.delegate = nil;
        cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
}

#pragma mark -TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    _sectionCount = kInt([[_assetsDic allKeys] count]);
    return _sectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == _sectionCount - 1 && indexPath.row == _lastSectionRowCount)
    {
        return 44;
    }
    return _margin + _imageSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = _orderAllKey[section];
    NSArray *array = [_assetsDic objectForKey:key];
    if(!array) return 0;
    NSInteger count = array.count / _numberOfAssetsInRow;
    if((array.count - count * _numberOfAssetsInRow) > 0)
        count++;
    
    if(section == _sectionCount - 1)
    {
        _lastSectionRowCount = kInt(count);
        if(_hasFooterCell)
        {
            if(count == 0)
                return 0;
            else
                return count + 1;
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == _sectionCount - 1 && indexPath.row == _lastSectionRowCount)
    {
        SXMImageFooterCell *cell = [[SXMImageFooterCell alloc]initWithFooterString:[NSString stringWithFormat:@"%d张照片",_assetsCount]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    NSString *key = _orderAllKey[indexPath.section];
    NSArray *array = [_assetsDic objectForKey:key];

    SXMImageChooserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[SXMImageChooserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier imageSize:_imageSize numberOfAssets:_numberOfAssetsInRow margin:_margin];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setDelegate:self];
    }
    
    int offset = _numberOfAssetsInRow * kInt(indexPath.row);
    int numberOfAssets = (offset + _numberOfAssetsInRow > kInt(array.count)) ? (kInt(array.count) - offset) : _numberOfAssetsInRow;
    
    NSMutableArray *assets = [NSMutableArray array];
    for(int i = 0; i < numberOfAssets; i++) {
        ALAsset *asset = array[offset + i];
        
        [assets addObject:asset];
    }
    cell.allowsMulSelection = self.allowsMulSelection;
    cell.assets = assets;
    
    for(NSUInteger i = 0; i < numberOfAssets; i++) {
        ALAsset *asset = array[offset + i];
        
        if([self.selectedAssets containsObject:asset]) {
            [(SXMImageChooserCell *)cell selectAssetAtIndex:kInt(i)];
        } else {
            [(SXMImageChooserCell *)cell deselectAssetAtIndex:kInt(i)];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 40)];
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10 , _tableView.frame.size.width - 20, 30)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    
    label.text = [self convertDateFormat:_orderAllKey[section]];
    [header addSubview:label];
    return header;
}

#pragma mark - self methods
-(NSString*)convertDateFormat:(NSString*)dateStr
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0];
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    NSString *todayStr = [self convertStringFromDate:today];
    NSString *yesterdayStr = [self convertStringFromDate:yesterday];
    if([dateStr compare:todayStr] == NSOrderedSame)
    {
        return @"今天";
    }
    else if([dateStr compare:yesterdayStr] == NSOrderedSame)
    {
        return @"昨天";
    }
    else if([[todayStr substringToIndex:4] compare:[dateStr substringToIndex:4]]==NSOrderedSame)
    {
        return [dateStr substringFromIndex:5];
    }
    else
    {
        return dateStr;
    }
}

-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

-(NSString*) convertStringFromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

-(void)loadImageData
{
    _assetsCount = 0;
    for(ALAssetsGroup *group in _groups)
    {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result) {
                _assetsCount++;
                id date = [result valueForProperty:ALAssetPropertyDate];
                NSString *dateStr = [self convertStringFromDate:date];
                NSMutableArray *assetsForDate = [_assetsDic objectForKey:dateStr];
                if(assetsForDate)
                {
                    [assetsForDate addObject:result];
                }
                else
                {
                    assetsForDate = [[NSMutableArray alloc]initWithObjects:result, nil];
                    [_assetsDic setObject:assetsForDate forKey:dateStr];
                }
            }
        }];
    }
    
    // Aarray排序
    NSComparator cmptr = ^(NSString *obj1, NSString *obj2){
        return [obj1 compare:obj2];
    };
    
    _orderAllKey = [[_assetsDic allKeys] sortedArrayUsingComparator:cmptr];
    [_tableView reloadData];
}

-(void) initUIBarButton
{
    if(_allowsMulSelection)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
        doneButton.enabled = NO;
        self.navigationItem.rightBarButtonItem = doneButton;
        _doneButton = doneButton;
    }
    else
    {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        cancelButton.enabled = YES;
        self.navigationItem.rightBarButtonItem = cancelButton;

    }
}

- (void)done
{
    [self.delegate mulpitleImageChooserPicker:self didFinishPickingAssets:self.selectedAssets.array];
}

-(void)cancel
{
    [self.delegate mulpitleImageChooserDidCancel:self];
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
    NSIndexPath *indexPath = [_tableView indexPathForCell:imageChooserCell];
    
    NSString *key = _orderAllKey[indexPath.section];
    NSArray *array = [_assetsDic objectForKey:key];
    int assetIndex = kInt(indexPath.row) * _numberOfAssetsInRow + index;
    ALAsset *asset = array[assetIndex];
    
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

@end
