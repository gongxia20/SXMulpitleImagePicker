//
//  ViewController.m
//  te
//
//  Created by dfpo on 15/6/6.
//  Copyright (c) 2015年 dfpo. All rights reserved.
//

#import "ViewController.h"
#import "UIView+gesture.h"
#import "MyCollectionViewCell.h"
#import "SXMulpitleImagePicker.h"

@interface ViewController ()<MulpitleImagePickerDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *images;
@end

@implementation ViewController

#pragma mark - event response
- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNib];
}
- (void)registerNib {
    UINib *nib = [UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"MyCollectionViewCellID"];
}
- (IBAction)loadSXMulpitleImagePicker {
    SXMulpitleImagePicker *picker = [[SXMulpitleImagePicker alloc]init];
    picker.delegate = self;
    picker.minImageCount = 0;
    picker.maxImageCount = 5;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - MulpitleImagePickerDelegate

- (void)mulpitleImagePickerDidCancel:(SXMulpitleImagePicker *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)mulpitleImagePicker:(SXMulpitleImagePicker *)picker didFinishPickingAssets:(NSArray *)assets {
    for(ALAsset *asset in assets)
    {
        UIImage * image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
        [self.images addObject:image];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCellID"
                                                                           forIndexPath:indexPath];
    
    cell.imageView.image = self.images[indexPath.item];
    
    __weak typeof(self) weakSelf = self;
    [cell setTapActionWithBlock:^{
        [weakSelf.images removeObjectAtIndex:indexPath.item];
        [weakSelf.collectionView reloadData];
    }];
    
    return cell;
};

#pragma mark - getters and setters

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}
@end
