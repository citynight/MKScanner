//   ___                _
//  / __|___  ___  __ _| |___
// | (_ / _ \/ _ \/ _` |   -_)
//  \___\___/\___/\__, |_\___|
//                |___/
//
//  Created by 微指 on 16/6/8.
//  Copyright © 2016年 Mekor. All rights reserved.
//

#import "ScaneImageViewController.h"
#import "UIView+Extensions.h"
#import "MKScaner.h"
#import "XZBaseMacro.h"
#import "Helper.h"
@import AVFoundation;




@interface ScaneImageViewController ()<UIAlertViewDelegate,UITextFieldDelegate>
/**
 *  提示Label
 */
@property (nonatomic, strong, nonnull) UILabel *tipLabel;
/**
 *  背景
 */
@property (nonatomic, strong, nonnull) UIView *readerView;
/**
 *  扫描框
 */
@property (nonatomic, strong, nonnull) UIView *showQRCodeView;
/**
 *  扫描时移动的线
 */
@property (nonatomic, strong, nonnull) UIImageView *moveLineView;
/**
 *  定时器
 */
@property (nonatomic, strong, nonnull) NSTimer *timer;
/**
 *  输入数字码
 */
@property (nonatomic, strong, nonnull) UIButton *inputButton;
/**
 *  闪光灯
 */
@property (nonatomic, strong, nonnull) UIButton *flashlightButton;
/**
 *   数字码输入框
 */
@property (nonatomic, strong, nonnull) UITextField *numberCodeTextField;
/**
 *  切换扫码
 */
@property (nonatomic, strong, nonnull) UIButton *gotoScanQRCodeButton;
/**
 *  确定
 */
@property (nonatomic, strong, nonnull) UIButton *numberCodeOKButton;
@property (nonatomic, assign) BOOL hasClickOkButton;

@property (nonatomic, strong) MKScaner *scanner;
@end

@implementation ScaneImageViewController


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    self.title = @"ScaneImageViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self checkState];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (!self.hasClickOkButton) {
        [self startScan];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self stopScan];
}

#pragma mark - Private
- (void)checkState {
 
    
    BOOL cameraState = [Helper checkCameraAuthorizationStatus];
    BOOL photoState= [Helper checkPhotoLibraryAuthorizationStatus];
    
    if (cameraState && photoState) {
        // 创建二维码视图
        [self setupScanQRCodeView];
        // 创建数字码视图
        [self setupNumberCodeView];
        
        // 显示状态
        [self updateNumberCodeViewStateHidden:YES];
    }
}

#pragma mark 创建扫描视图
- (void)setupScanQRCodeView {
    // 扫描背景
    self.readerView = ({
        UIView *readerView = [[UIView alloc]init];
        readerView.frame = self.view.bounds;
        [self.view
         addSubview:readerView];
        readerView;
    });
    
    self.scanner = [MKScaner scanerWithView:self.readerView scanFrame:self.readerView.bounds completion:^(NSString *stringValue) {
        NSArray *subArray = [stringValue componentsSeparatedByString:@"="];
        NSLog(@"%@", [subArray lastObject]);
        [self requestWZCodeIsValid:[subArray lastObject]]; // 判断二维码是否有效
    }];
    
    
    // 提示语
    self.tipLabel = ({
        static const CGFloat top = 100;
        static const CGFloat height = 20;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, height)];
        label.text = @"将二维码放入框内,即可自动扫描";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [self.readerView
         addSubview:label];
        label;
    });
    
    // 扫描框
    self.showQRCodeView = ({
        static const CGFloat padding = 50;
        static const CGFloat margin = 10;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(padding, self.tipLabel.bottom + margin, SCREEN_WIDTH - 2 * padding, SCREEN_WIDTH - 2 * padding)];
        view.layer.borderWidth = 0.5f;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.readerView
         addSubview:view];
        view;
    });
    
    // 移动的线
    self.moveLineView = ({
        UIImage *moveImage = [UIImage imageNamed:@"saomiao"];
        UIImageView *moveLineView = [[UIImageView alloc] initWithImage:moveImage];
        moveLineView.frame = CGRectMake(self.showQRCodeView.left, self.showQRCodeView.top, self.showQRCodeView.width, moveImage.size.height);
        [self.readerView
         addSubview:moveLineView];
        moveLineView;
    });
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(moveLine)
                                                userInfo:nil
                                                 repeats:YES];
    // 开始扫描
    [self startScan];
    
    // 输入数字码
    self.inputButton = ({
        static const CGFloat width = 150;
        static const CGFloat height = 30;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - width)*0.5, self.showQRCodeView.bottom + 25, width, height)];
        [btn setTitle:@"输入数字码" forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
        
        UIImage *bgImage = [UIImage imageNamed:@"圆角矩形-2"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.5 topCapHeight:bgImage.size.height * 0.5];
        [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(inputNumberCode) forControlEvents:UIControlEventTouchUpInside];
        [self.readerView addSubview:btn];
        btn;
    });
    
    
    // bottomView
    UIView *bottomView = ({
        static const CGFloat height = 80;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height)];
        view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:view];
        view;
    });
    
    self.flashlightButton = ({
        static const CGFloat wh = 43;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -wh)*0.5, (bottomView.height -wh)*0.5, wh, wh)];
        [btn setImage:[UIImage imageNamed:@"shoudian"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"shoudiana"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(flashlightStateChange:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn];
        btn;
    });
    
}
- (void)setupNumberCodeView {
    self.numberCodeTextField = ({
        UITextField *view = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.showQRCodeView.width, 35)];
        view.placeholder = @"请输入数字码";
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        [self.showQRCodeView addSubview:view];
        view;
    });
    CGRect frame = [self.numberCodeTextField convertRect:self.numberCodeTextField.frame toView:self.view];
    CGFloat bottom = frame.size.height +frame.origin.y;
    self.gotoScanQRCodeButton = ({
        static const CGFloat width = 100;
        static const CGFloat height = 30;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(23, bottom + 30, width, height)];
        [btn setTitle:@"切换扫码" forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
        
        UIImage *bgImage = [UIImage imageNamed:@"圆角矩形-2"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.5 topCapHeight:bgImage.size.height * 0.5];
        [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gotoQRCodeState) forControlEvents:UIControlEventTouchUpInside];
        [self.readerView addSubview:btn];
        btn;
    });
    
    self.numberCodeOKButton = ({
        static const CGFloat width = 100;
        static const CGFloat height = 30;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - width - 23, bottom + 30, width, height)];
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        
        UIImage *bgImage = [UIImage imageNamed:@"圆角矩形-2"];
        bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width*0.5 topCapHeight:bgImage.size.height * 0.5];
        [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(numberCodeOKClick) forControlEvents:UIControlEventTouchUpInside];
        [self.readerView addSubview:btn];
        btn;
    });
    
    
}


#pragma mark - Private
#pragma mark 扫描线移动
- (void)moveLine
{
    if (self.moveLineView.top < self.showQRCodeView.bottom - self.moveLineView.height)   // 线往下面移动
    {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:2
                         animations:^{
                             __strong __typeof(weakSelf) strongSelf = weakSelf;
                             if (strongSelf)
                             {
                                 [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                                 strongSelf.moveLineView.frame =
                                 CGRectMake(strongSelf.moveLineView.left,
                                            strongSelf.showQRCodeView.bottom - strongSelf.moveLineView.height,
                                            strongSelf.showQRCodeView.width, strongSelf.moveLineView.height);
                             }
                         }completion:^(BOOL finished) {
                             __strong __typeof(weakSelf) strongSelf = weakSelf;
                             if (strongSelf)
                             {
                                 strongSelf.moveLineView.top = strongSelf.showQRCodeView.top;
                             }
                         }];
    }
}
#pragma mark 开启扫描
- (void)startScan {
    [self.scanner startScan];
    [self.timer setFireDate:[NSDate distantPast]];
    self.moveLineView.hidden = NO;
}
// 停止扫描
- (void)stopScan {
    [self.scanner stopScan];
    [self.timer setFireDate:[NSDate distantFuture]];
    self.moveLineView.hidden = YES;
    self.moveLineView.frame = CGRectMake(self.moveLineView.left, self.readerView.top,self.showQRCodeView.width, self.moveLineView.height);
}
#pragma mark 闪光灯开关
- (void)flashlightStateChange:(UIButton *)btn {
    btn.selected = !(btn.selected);
    
    [self.scanner torchMode:btn.selected];
}


#pragma mark 更新状态
- (void)updateNumberCodeViewStateHidden:(BOOL)hidden {
    // 数字码状态
    self.numberCodeTextField.hidden = hidden;
    self.gotoScanQRCodeButton.hidden = hidden;
    self.numberCodeOKButton.hidden = hidden;
    self.tipLabel.hidden = !hidden;
    if(hidden){
        [self.numberCodeTextField resignFirstResponder];
    }else{
        [self.numberCodeTextField becomeFirstResponder];
    }
}
#pragma mark 切换到输入数字码状态
- (void)inputNumberCode {
    [self stopScan];
    @weakify(self)
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self)
        self.showQRCodeView.frame = CGRectMake(self.showQRCodeView.x, self.showQRCodeView.y, self.showQRCodeView.width, self.numberCodeTextField.height);
    } completion:^(BOOL finished) {
        @strongify(self)
        [self updateNumberCodeViewStateHidden:NO];
    }];
    
}
#pragma mark 切换到扫描二维码状态
- (void)gotoQRCodeState {
    self.hasClickOkButton = NO;
    [self updateNumberCodeViewStateHidden:YES];
    @weakify(self)
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self)
        self.showQRCodeView.frame = CGRectMake(self.showQRCodeView.x, self.showQRCodeView.y, self.showQRCodeView.width, self.showQRCodeView.width);
    } completion:^(BOOL finished) {
        @strongify(self)
        [self startScan];
    }];
}

#pragma mark - 点击确定按钮
- (void)numberCodeOKClick {
    self.hasClickOkButton = YES;
    [self requestWZCodeIsValid:self.numberCodeTextField.text];
}

#pragma mark - 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.numberCodeTextField resignFirstResponder];
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 88 && !self.hasClickOkButton) {
        [self startScan];
    }
}


#pragma mark - 网络请求
- (void)requestWZCodeIsValid:(NSString *)wzcode {
    NSLog(@"进行网络请求--%@",wzcode);
}

@end
