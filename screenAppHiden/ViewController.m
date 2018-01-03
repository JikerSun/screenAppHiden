//
//  ViewController.m
//  screenAppHiden
//
//  Created by 触手TV on 2017/12/29.
//  Copyright © 2017年 触手TV. All rights reserved.
//

#import "ViewController.h"
#import "ChooseIconVC.h"
#import "ChooseIconTool.h"

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatChooseBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) creatChooseBtn {
    
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [chooseButton setFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:chooseButton];
    chooseButton.tag = 1004;
    chooseButton.center = self.view.center;//让button位于屏幕中央
    [chooseButton setTitle:@"选照片" forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchDown];
}

- (void) selectImage{
    //调用系统相册的类
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    
    //设置选取的照片是否可编辑
    pickerController.allowsEditing = NO;
    //设置相册呈现的样式
    pickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片分组列表样式
    //照片的选取样式还有以下两种
//    UIImagePickerControllerSourceTypePhotoLibrary;//,直接全部呈现系统相册
    //UIImagePickerControllerSourceTypeCamera //调取摄像头
    
    pickerController.delegate = self;
    //使用模态呈现相册
    [self presentViewController:pickerController animated:YES completion:^{
    }];
    
}


//选择照片完成之后的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //info是所选择照片的信息
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    //    [button setImage:[resultImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];//如果按钮创建时用的是系统风格UIButtonTypeSystem，需要在设置图片一栏设置渲染模式为"使用原图"
    
    NSLog(@"info  : %@",info);
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [ChooseIconTool getInstance].iconImageOri = resultImage;
    
    //使用模态返回到软件界面
    [self dismissViewControllerAnimated:YES completion:nil];
    [self presentToChooseVC];
}

- (void) presentToChooseVC {
    ChooseIconVC * chooseVc = [[ChooseIconVC alloc]init];
    [self presentViewController:chooseVc animated:YES completion:nil];
    
}



//点击取消按钮所执行的方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    //这是捕获点击右上角cancel按钮所触发的事件，如果我们需要在点击cancel按钮的时候做一些其他逻辑操作。就需要实现该代理方法，如果不做任何逻辑操作，就可以不实现
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
