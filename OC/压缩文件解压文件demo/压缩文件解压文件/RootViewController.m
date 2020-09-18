//
//  RootViewController.m
//  压缩文件解压文件
//
//  Created by riseikan on 14-4-10.
//  Copyright (c) 2014年 riseikan. All rights reserved.
//

#import "RootViewController.h"
#import "ZipArchive.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self imageViewInit];
    [self buttonInit];
    
}
- (void)imageViewInit{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, 160)];
    _imageView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_imageView];
    [_imageView release];
    
}
- (void)buttonInit{
    UIButton *firstButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, 320, 50)];
    firstButton.backgroundColor = [UIColor grayColor];
    [firstButton setTitle:@"压缩" forState:UIControlStateNormal];
    [firstButton addTarget:self action:@selector(firstButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstButton];
    [firstButton release];
    UIButton *secondButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, 320, 50)];
    secondButton.backgroundColor = [UIColor grayColor];
    [secondButton setTitle:@"解压缩" forState:UIControlStateNormal];
    [secondButton addTarget:self action:@selector(secondButtonActuon:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondButton];
    [secondButton release];
    UIButton *thirdButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 400, 320, 50)];
    thirdButton.backgroundColor = [UIColor grayColor];
    [thirdButton setTitle:@"删除解压图片" forState:UIControlStateNormal];
    [thirdButton addTarget:self action:@selector(thirdButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:thirdButton];
    [thirdButton release];
    UIButton *fourthButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 500, 320, 50)];
    fourthButton.backgroundColor = [UIColor grayColor];
    [fourthButton setTitle:@"删除压缩文件" forState:UIControlStateNormal];
    [fourthButton addTarget:self action:@selector(fourthButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fourthButton];
    [fourthButton release];
}
- (void)firstButtonAction:(id)sender{
    // 1. 获取Documents目录，新的zip文件要写入到这个目录里。
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docspath = [paths objectAtIndex:0];
    
    // 2. 获取Caches目录，要进行压缩的文件在这个目录里。
    //    paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    NSString *cachePath = [paths objectAtIndex:0];
    
    //    NSLog(@"imagePaths=====%@",cachePath);
    // 3. 获取zip文件的全路径名。
    NSString *zipFile = [docspath stringByAppendingPathComponent:@"newzipfile.zip"];
    NSLog(@"path======%@",zipFile);
    // 4. 创建一个ZipArchive实例，并创建一个内存中的zip文件。需要注意的是，只有当你调用了CloseZipFile2方法之后，zip文件才会从内存中写入到磁盘中去。
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFile];
    
    // 5. 获取要被压缩的文件的全路径
    NSString *imagePath = [docspath stringByAppendingPathComponent:@"tudou.png"];
    NSLog(@"imagePath====%@",imagePath);
    //    NSString *textPath = [imagePaths stringByAppendingPathComponent:@"text.txt"];
    
    // 6. 把要压缩的文件加入到zip对象中去，加入的文件数量没有限制，也可以加入文件夹到zip对象中去。
    [za addFileToZip:imagePath newname:@"newTudou.png"];
    //    [za addFileToZip:textPath newname:@"NewTextName.txt"];
    
    // 7. 把zip从内存中写入到磁盘中去。
    BOOL success = [za CloseZipFile2];
    NSLog(@"Zipped file with result %d",success);
    
}
- (void)secondButtonActuon:(id)sender{
    // 1. 获取Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"paths====%@",paths);
    NSString *docspath = [paths objectAtIndex:0];

    
    NSString *origFile = [[NSBundle mainBundle] pathForResource:@"image.zip" ofType:nil];
    NSFileManager* manager = [[NSFileManager alloc]init];
    [manager copyItemAtPath:origFile toPath:[docspath stringByAppendingString:@"/image.zip"] error: nil];
    NSString *zipPath = [docspath stringByAppendingString:@"/image.zip"];
    ZipArchive *za = [[ZipArchive alloc] init];
    // 1. 在内存中解压缩文件
    if ([za UnzipOpenFile: zipPath]) {
        // 2. 将解压缩的内容写到缓存目录中
        BOOL ret = [za UnzipFileTo: docspath overWrite: YES];
        if (NO == ret){} [za UnzipCloseFile];
        
        // 3. 使用解压缩后的文件
        NSString *imageFilePath = [docspath stringByAppendingPathComponent:@"image.jpg"];
        NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath options:0 error:nil];
        UIImage *img = [UIImage imageWithData:imageData];
        // 4. 更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            _imageView.image = img;
        });
    }
}
- (void)thirdButtonAction:(id)sender{
    // 1. 获取Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:@"newTudou.png"];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
    [_imageView setImage:nil];
    
}
- (void)fourthButtonAction:(id)sender{
    // 1. 获取Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:@"newzipfile.zip"];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        //
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
