//   ___                _
//  / __|___  ___  __ _| |___
// | (_ / _ \/ _ \/ _` |   -_)
//  \___\___/\___/\__, |_\___|
//                |___/
//
//  Created by 微指 on 16/6/8.
//  Copyright © 2016年 Mekor. All rights reserved.
//

#import "QRImageViewController.h"
#import "UIView+Extensions.h"
#import "Helper.h"
#import "XZBaseMacro.h"
#import "MKScaner.h"

@interface QRImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITextField *textField; ///< 二维码包含的文字
@property (nonatomic, strong) UIButton *chooseImageButton; ///< 选择图片
@property (nonatomic, strong) UIButton *makeQRImageButton; ///< 点击生成二维码
@property (nonatomic, strong) UIImageView *qrImageView; ///< 二维码
@end

@implementation QRImageViewController


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    self.title = @"QRImageViewController";
    self.view.backgroundColor = [UIColor grayColor];
    
    self.textField = ({
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 44)];
        textField.placeholder = @"二维码中包含内容";
        [self.view addSubview:textField];
        textField;
    });
    
    self.chooseImageButton = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.textField.bottom, SCREEN_WIDTH*0.5, 35)];
        [btn setTitle:@"选择照片" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
    
    self.makeQRImageButton = ({
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.chooseImageButton.right, self.textField.bottom, SCREEN_WIDTH*0.5, 35)];
        [btn setTitle:@"生成二维码" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(makeQRCodeImage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn;
    });
    
    self.qrImageView = ({
        CGFloat width = 100;
        UIImageView *qrView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - width)*0.5, self.makeQRImageButton.bottom, width,width)];
        [self.view addSubview:qrView];
        qrView;
    });

    
    
}


#pragma mark - Private
-(void) chooseImage {
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.allowsEditing = YES;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:photoPicker animated:YES completion:nil];
}

-(void) makeQRCodeImage {
    [MKScaner qrImageWithString:self.textField.text avatar:self.qrImageView.image scale:0.2 completion:^(UIImage *image) {
        self.qrImageView.image = image;
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //选取编辑后图片
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.qrImageView.image = image;
}

@end
