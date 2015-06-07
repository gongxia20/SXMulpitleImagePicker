
## Features

- Allows multiple selection of photos



## Requirements

- Version `>= iOS 7.0` 


## Example

    SXMulpitleImagePicker *picker = [[SXMulpitleImagePicker alloc]init];
    picker.delegate = self;
    picker.minImageCount = 0;
    picker.maxImageCount = 5;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:nav animated:YES completion:nil];



## Usage

### Basic

1. Implement `SXMulpitleImagePicker` methods
2. Create `SXMulpitleImagePicker` object
3. Set `self` to the `delegate` property
4. Show the picker by using `presentViewController:animated:completion:`



### Delegate Methods

#### Getting the selected assets

Implement `- mulpitleImagePicker: didFinishPickingAssets:` to get the assets selected by the user.  
This method will be called when the user finishes picking assets.

    - (void)mulpitleImagePicker:(SXMulpitleImagePicker *)picker didFinishPickingAssets:(NSArray *)assets {
    for(ALAsset *asset in assets)
    {
        UIImage * image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
	        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#### Getting notified when the user cancels

Implement `- mulpitleImagePickerDidCancel:` to get notified when the user hits "Cancel" button.

    - (void)mulpitleImagePickerDidCancel:(SXMulpitleImagePicker *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


### Customization

#### Selection mode

When `allowsMulSelection` is `YES`, the user can select multiple photos.  
The default value is `NO`.

    picker.allowsMulSelection = YES;

You can limit the number of selection by using `minImageCount` and `maxImageCount` property.  
The default value is `0`, which means the number of selection is unlimited.

    picker.minImageCount = 3;
    picker.maxImageCount = 6;

中文操作：


第一步，在所需控制器引入头文件#import "SXMulpitleImagePicker.h"，并遵守协议MulpitleImagePickerDelegate


第二步，在某个事件触发，比如按钮点击加入
    SXMulpitleImagePicker *picker = [[SXMulpitleImagePicker alloc]init];
    picker.delegate = self;
    picker.minImageCount = 0;
    picker.maxImageCount = 5;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentViewController:nav animated:YES completion:nil];
    
    
第三步，实现代理方法
    
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
