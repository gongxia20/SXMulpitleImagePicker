//
//  SXMulpitleImagePicker.m
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import "SXMImagePickerCell.h"
#import "SXMulpitleImagePicker.h"

@interface SXMulpitleImagePicker ()<UITableViewDataSource, UITableViewDelegate, SXMulpitleImageChooserDelegate>

@property (nonatomic, retain) UITableView     *tableView;
@property (nonatomic, retain) NSMutableArray  *assetsGroups;
@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;

@end

@implementation SXMulpitleImagePicker
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        
        self.title              = @"照片";
        self.minImageCount      = 0;
        self.maxImageCount      = CGFLOAT_MAX;
        self.allowsMulSelection = YES;
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        self.assetsLibrary = assetsLibrary;
        self.assetsGroups  = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getAssetsGroups];
    [self initLayout];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.rowHeight = 66.0f;
}

#pragma mark - UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count ? (self.assetsGroups.count + 1) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SXMImagePickerCell *cell = [SXMImagePickerCell cellWithTableView:tableView];
    
    ALAssetsGroup *assetsGroup;
    if(indexPath.row == 0)
    {
        assetsGroup= self.assetsGroups[0];
        [cell setCellData:assetsGroup hasLine:YES];
    }
    else
    {
        assetsGroup= self.assetsGroups[indexPath.row - 1];
        [cell setCellData:assetsGroup hasLine:NO];
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!indexPath.row)
    {
        SXMulpitleImageChooser_Time *viewController = [[SXMulpitleImageChooser_Time alloc]init];
        viewController.title = IMAGEPICKER_ALLIMAGE;
        viewController.groups = self.assetsGroups;
        viewController.minImageCount = self.minImageCount;
        viewController.maxImageCount = self.maxImageCount;
        viewController.allowsMulSelection = self.allowsMulSelection;
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        ALAssetsGroup *assetsGroup = self.assetsGroups[indexPath.row - 1];
        
        SXMulpitleImageChooser *viewController = [[SXMulpitleImageChooser alloc] init];
        viewController.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        viewController.assetsGroup = assetsGroup;
        viewController.minImageCount = self.minImageCount;
        viewController.maxImageCount = self.maxImageCount;
        viewController.allowsMulSelection = self.allowsMulSelection;
        viewController.delegate = self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - myself methods
-(void)getAssetsGroups
{
    void (^assetsGroupsSuccess)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        if(assetsGroup)
        {
            [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
            if(assetsGroup.numberOfAssets > 0) {
                [self.assetsGroups addObject:assetsGroup];
                [self.tableView reloadData];
            }
        }
    };
    
    void (^assetsGroupsFailure)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    NSUInteger groupTypes = ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces;
    
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:assetsGroupsSuccess failureBlock:assetsGroupsFailure];
}

-(void)initLayout
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(cancel)];
    
    [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate   = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)cancel
{
    [self.delegate mulpitleImagePickerDidCancel:self];
}

#pragma mark - SXMulpitleImageChooserDelegate
- (void)mulpitleImageChooserPicker:(id)picker didFinishPickingAssets:(NSArray *)assets
{
    if([self.delegate respondsToSelector:@selector(mulpitleImagePicker:didFinishPickingAssets:)])
    {
        [self.delegate mulpitleImagePicker:self didFinishPickingAssets:assets];
    }
}

-(void)mulpitleImageChooserPicker:(id)picker didFinishPickingAsset:(ALAsset *)asset
{
    if([self.delegate respondsToSelector:@selector(mulpitleImagePicker:didFinishPickingAsset:)])
    {
        [self.delegate mulpitleImagePicker:self didFinishPickingAsset:asset];
    }
}

- (void)mulpitleImageChooserDidCancel:(id)picker
{
    if([self.delegate respondsToSelector:@selector(mulpitleImagePickerDidCancel:)])
    {
        [self.delegate mulpitleImagePickerDidCancel:self];
    }
}

@end
