//
//  ChooseIconVC.m
//  screenAppHiden
//
//  Created by 触手TV on 2017/12/29.
//  Copyright © 2017年 触手TV. All rights reserved.
//

#import "ChooseIconVC.h"
#import "ViewController.h"
#import "ChooseIconTool.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "YYKit.h"



#define ScreenHeight ([[UIScreen mainScreen]bounds].size.height)
#define Device_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


@interface ChooseIconVC ()

@end

@implementation ChooseIconVC {
    CGRect iconFrame;
    UIButton *chooseButton;
    int  scale;
    HTTPServer *httpServer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatBackImage];
    [self creatDissmissBtn];
    [self creatAppLocalBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatBackImage {
    
    UIImageView  * backImageView = [[UIImageView alloc]initWithImage:[ChooseIconTool getInstance].iconImageOri];
    [backImageView setFrame:self.view.frame];
    [self.view addSubview:backImageView];
    
}

-(void) creatDissmissBtn {
    chooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [chooseButton setFrame:CGRectMake(20, self.view.bounds.size.height - 60, 60, 60)];
    [chooseButton setTitle:@"back" forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(dissmissVC) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:chooseButton];
    [self.view bringSubviewToFront:chooseButton];
    [chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseButton setBackgroundColor:[UIColor redColor]];
}
- (void) dissmissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) creatAppLocalBtn {

    //iphone X = 27+45; 72
    //other iphone = 27   /   28    /  38;
    //PW: (screen.width - 60*4)/5
    //pH: (screen.height - 91 - 27)/5  / 6: (screen.height - 91 - 28)/5  /    6p : (screen.height - 91 - 38)/6   iphoneX : (screen.height - 91 - 72)/6
    
    int appnum = 6;//竖排的app数目
    float heightTotop = 28; //第一排的app到手机透顶的距离
    float heihtToBottom = 111;
    if (ScreenHeight == 568) {
        //iphone 5
        appnum = 5;
        heightTotop = 27;
        heihtToBottom = 101.2;
        scale = 2;
        NSLog(@"iphone 5");

    } else if (ScreenHeight == 667){
        //iphone 6
        appnum = 6;
        heightTotop = 28;
        heihtToBottom = 111;
        scale = 2;

        NSLog(@"iphone 6");

    } else if (ScreenHeight == 736) {
        //iphone 6p
        appnum = 6;
        heightTotop = 38;
        heihtToBottom = 98;
        scale = 3;

        NSLog(@"iphone 6p");

    } else if (Device_Is_iPhoneX) {
        //iphone X
        appnum = 6;
        heightTotop = 72;
        heihtToBottom = 127.7;
        scale = 3;

        NSLog(@"iphone X");

    }
    float wid = (self.view.bounds.size.width -60*4)/5;
    float heig = (ScreenHeight - heihtToBottom - heightTotop)/appnum;
    NSLog(@"wid : %f   Hei : %f",wid, heig);
    for (int i = 0; i < appnum; i++) {
        for (int j = 0 ; j < 4; j++) {
            UIButton *chooseIcon = [UIButton buttonWithType:UIButtonTypeSystem];
            [chooseIcon setFrame:CGRectMake(wid+(wid + 60)*j, heightTotop + heig * i, 60, 60)];
            chooseIcon.tag = (4 * i) + j + 200;
            [self.view addSubview:chooseIcon];
            [chooseIcon setBackgroundColor:[UIColor redColor]];
            chooseIcon.alpha = 0.5;
            [chooseIcon addTarget:self action:@selector(chooseIconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)chooseIconBtnClick:(UIButton *)sender{
    [self clipImage:sender.frame];
    [self saveImageTolocal:[ChooseIconTool getInstance].iconImageClip];
    
//    NSString * localImagePath = nil;
//    if ([ChooseIconTool getInstance].iconImageClip) {
//      localImagePath = [self saveImageTolocal:[ChooseIconTool getInstance].iconImageClip];
////      localImagePath = [self saveImageTolocalByBase64:[ChooseIconTool getInstance].iconImageClip];
////        NSLog(@"图片64位 : %@",localImagePath);
//        if (localImagePath && localImagePath.length > 0) {
//            [self shareLocalClick:localImagePath];
//            NSLog(@"长度:%lu",(unsigned long)localImagePath.length);
//        }
//    } else {
//        NSLog(@"没图片");
//    }
}

-(void) clipImage:(CGRect)frame {
    CGRect lastFrame = CGRectMake(frame.origin.x * scale, frame.origin.y * scale, frame.size.width * scale, frame.size.height * scale);
//    UIBezierPath * bezierP = [UIBezierPath bezierPathWithRect:lastFrame];
//  [ChooseIconTool getInstance].iconImageClip = [self clipWithPath:bezierP InRect:lastFrame];
    [ChooseIconTool getInstance].iconImageClip = [self clipImageWithRect:lastFrame];
    
    [chooseButton setBackgroundImage:[ChooseIconTool getInstance].iconImageClip forState:UIControlStateNormal];
}



// 根据path在rect范围内切割图片
//https://www.jianshu.com/p/6130b51a0b71
-(UIImage*)clipWithPath:(UIBezierPath*)path InRect:(CGRect)rect{
    UIImage * image = [ChooseIconTool getInstance].iconImageOri;

    //开始绘制图片
    UIGraphicsBeginImageContext(image.size);
    //UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);

    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    ////绘制Clip区域
    CGRect myRect = rect;

    UIBezierPath * clipPath = path;
    CGContextAddPath(contextRef, clipPath.CGPath);
    CGContextClosePath(contextRef);
    CGContextClip(contextRef);
    //坐标系转换
    //因为CGContextDrawImage会使用Quartz内的以左下角为(0,0)的坐标系
    //沿着y轴移动
    CGContextTranslateCTM(contextRef, 0, image.size.height);

    //缩放
    CGContextScaleCTM(contextRef, image.scale, -image.scale);
    CGRect drawRect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextDrawImage(contextRef, drawRect, [image CGImage]);
    //结束绘画
    UIImage *destImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    destImg = [self clipImageWithRect:myRect];


    //return destImg;
    return destImg;
}


/* 根据rect裁剪图片 */
-(UIImage *)clipImageWithRect:(CGRect)rect{
    UIImage * image  = [ChooseIconTool getInstance].iconImageOri;
    CGRect myRect = rect;
    CGImageRef  imageRef = CGImageCreateWithImageInRect(image.CGImage, myRect);
    UIGraphicsBeginImageContext(myRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myRect, imageRef);
    UIImage * clipImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    
    //转成png格式 会保留透明
    NSData * data = UIImagePNGRepresentation(clipImage);
    UIImage * dImage = [UIImage imageWithData:data];

    return dImage;
}

- (void)shareLocalClick:(NSString *)localImagePath
{
    //ddlog打印初始化
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    httpServer = [[HTTPServer alloc] init];
    
    [httpServer setType:@"_http._tcp."];
    
    [httpServer setPort:12345];
    
    // Serve files from our embedded Web folder
    //文件夹一定要以folder方式导入到项目中文件名一定要一一致
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HTML"];
    NSLog(@"Setting document root: %@", webPath);

    [httpServer setDocumentRoot:webPath];
    
    [self startServer];
    NSString * localImagePathURLStr = [NSString stringWithFormat:@"http://127.0.0.1:12345/context.html?image=%@",localImagePath];
    NSLog(@"网址打印 : %@",localImagePathURLStr);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:localImagePathURLStr]];
}


- (void)startServer
{
    NSError *error;
    if([httpServer start:&error])
    {
        NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
    }
    else
    {
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}

- (void )saveImageTolocal:(UIImage *)image {
    [self loadImageFinished:image];
}


//保存到相册
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSLog(@"保存相册 image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
                [self shareLocalClick:@"Con.png"];

}



//- (void )saveImageTolocal:(UIImage *)image {
////    // 本地沙盒目录
////    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
////    NSLog(@"目录数组 : %@",path);
////    // 得到本地沙盒中名为"MyImage"的路径，"MyImage"是保存的图片名
////    NSString *imageFilePath = [path stringByAppendingPathComponent:@"MyLocalImage.png"];
//////    NSString *imageFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HTML"];
////
////    // 将取得的图片写入本地的沙盒中，其中0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
////    BOOL success = [UIImagePNGRepresentation(image) writeToFile:imageFilePath  atomically:YES];
////    if (success){
////        NSLog(@"写入本地成功");
////        NSString * lastFilePath = [NSString stringWithFormat:@"%@",imageFilePath];
////
////        return lastFilePath;
////    } else {
////        NSLog(@"写入本地失败");
////        return nil;
////    }
//}
//- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL{
//    解释下参数的意义
//    1 string：html语言文本
//    [NSString stringWithContentsOfFile:imageFilePath encoding:NSUTF8StringEncoding error:nil]//实例化
//    (imagFilePath :/Users/shiguifeng/Library/Application Support/iPhone Simulator/5.1/Applications/9FCCC772-D91C-4E6C-A980-5CC4D1B8FB65/Library/Caches/index/default.html)
//    2 baseURL html 资源路径 （在ios应用程序中 要转化成相对于 html文件的路径）
//    在这里 我用终端命令 defaults write com.apple.finder AppleShowAllFiles -bool true 显示了mac的隐藏文件从而通过Finder找到了zip包的位置和解压所得的文件
//    下面是我要感谢楼主的地方 通过楼主提供的方法 （在沙盒中的 资源文件用如下的代码）
//    NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//",pathstr]];
//    我顺利的将资源路径转化成相对于html的路径
//    做到这里 一般的问题就该解决了 可以通过上面的加载方法 成功加载html
    
//    但是我的问题就出现在这里 “图片资源仍然加载不了”
//    我开始以为错误 以为是楼主遗漏的代码 中有重要的东西我没加入 比如self.paperId UseFileManager 等。 并且去多个技术网站搜索 但是都失败了 这个时候我 试着读了下html语言 想看看是不是加载的图片名字跟我zip包的图片名字不同导致
//    发现其中的图片加载语句都是这种形式<img src="d_img/h.gif"  alt="img"/>
//    我查看了下自己的baseURL
//    baseURL = file:///Users//shiguifeng//Library//Application%20Support//iPhone%20Simulator//5.1//Applications//9FCCC772-D91C-4E6C-A980-5CC4D1B8FB65//Library//Caches//index//d_img//
//    我又去沙盒中查看了 发现解压后的文件如下
//    除了 default.html  还有一个文件夹 d_img
//    问题找到了当系统通过我上面的baseUrl进入d_img文件后 确再也找不到d_img文件了
//    然后我果断删除 d_img// baseURL变成了如下
//    baseURL = file:///Users//shiguifeng//Library//Application%20Support//iPhone%20Simulator//5.1//Applications//9FCCC772-D91C-4E6C-A980-5CC4D1B8FB65//Library//Caches//index//
//    再次运行 果断图片加载图片成功
//}

//- (NSString *)saveImageTolocalByBase64:(UIImage *)image{
//    /*
//     把图片转换为Base64的字符串
//
//     在iphone上有两种读取图片数据的简单方法: UIImageJPEGRepresentation和UIImagePNGRepresentation.
//
//     UIImageJPEGRepresentation函数需要两个参数:图片的引用和压缩系数.而UIImagePNGRepresentation只需要图片引用作为参数.通过在实际使用过程中,
//     比较发现: UIImagePNGRepresentation(UIImage* image) 要比UIImageJPEGRepresentation(UIImage* image, 1.0) 返回的图片数据量大很多.
//     譬如,同样是读取摄像头拍摄的同样景色的照片, UIImagePNGRepresentation()返回的数据量大小为199K ,
//     而 UIImageJPEGRepresentation(UIImage* image, 1.0)返回的数据量大小只为140KB,比前者少了50多KB.
//     如果对图片的清晰度要求不高,还可以通过设置 UIImageJPEGRepresentation函数的第二个参数,大幅度降低图片数据量.譬如,刚才拍摄的图片,
//     通过调用UIImageJPEGRepresentation(UIImage* image, 1.0)读取数据时,返回的数据大小为140KB,但更改压缩系数后,
//     通过调用UIImageJPEGRepresentation(UIImage* image, 0.5)读取数据时,返回的数据大小只有11KB多,大大压缩了图片的数据量 ,
//     而且从视角角度看,图片的质量并没有明显的降低.因此,在读取图片数据内容时,建议优先使用UIImageJPEGRepresentation,
//     并可根据自己的实际使用场景,设置压缩系数,进一步降低图片数据量大小.
//     */
//
//    NSData *_data = UIImagePNGRepresentation(image);
//    //将图片的data转化为字符串
//    NSString *strimage64 = [_data base64EncodedString];
//    return  strimage64;
//}


//- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
//{
//    long double rotate = 0.0;
//    CGRect rect;
//    float translateX = 0;
//    float translateY = 0;
//    float scaleX = 1.0;
//    float scaleY = 1.0;
//
//    switch (orientation) {
//        case UIImageOrientationLeft:
//            rotate = M_PI_2;
//            rect = CGRectMake(0, 0, image.size.height, image.size.width);
//            translateX = 0;
//            translateY = -rect.size.width;
//            scaleY = rect.size.width/rect.size.height;
//            scaleX = rect.size.height/rect.size.width;
//            break;
//        case UIImageOrientationRight:
//            rotate = 3 * M_PI_2;
//            rect = CGRectMake(0, 0, image.size.height, image.size.width);
//            translateX = -rect.size.height;
//            translateY = 0;
//            scaleY = rect.size.width/rect.size.height;
//            scaleX = rect.size.height/rect.size.width;
//            break;
//        case UIImageOrientationDown:
//            rotate = M_PI;
//            rect = CGRectMake(0, 0, image.size.width, image.size.height);
//            translateX = -rect.size.width;
//            translateY = -rect.size.height;
//            break;
//        default:
//            rotate = 0.0;
//            rect = CGRectMake(0, 0, image.size.width, image.size.height);
//            translateX = 0;
//            translateY = 0;
//            break;
//    }
//
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //做CTM变换
//    CGContextTranslateCTM(context, 0.0, rect.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextRotateCTM(context, rotate);
//    CGContextTranslateCTM(context, translateX, translateY);
//
//    CGContextScaleCTM(context, scaleX, scaleY);
//    //绘制图片
//    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
//
//    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
//
//    return newPic;
//}
//


@end
