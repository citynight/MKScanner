//
//                #####################################################
//                #                                                   #
//                #                       _oo0oo_                     #
//                #                      o8888888o                    #
//                #                      88" . "88                    #
//                #                      (| -_- |)                    #
//                #                      0\  =  /0                    #
//                #                    ___/`---'\___                  #
//                #                  .' \\|     |# '.                 #
//                #                 / \\|||  :  |||# \                #
//                #                / _||||| -:- |||||- \              #
//                #               |   | \\\  -  #/ |   |              #
//                #               | \_|  ''\---/''  |_/ |             #
//                #               \  .-\__  '-'  ___/-. /             #
//                #             ___'. .'  /--.--\  `. .'___           #
//                #          ."" '<  `.___\_<|>_/___.' >' "".         #
//                #         | | :  `- \`.;`\ _ /`;.`/ - ` : | |       #
//                #         \  \ `_.   \_ __\ /__ _/   .-` /  /       #
//                #     =====`-.____`.___ \_____/___.-`___.-'=====    #
//                #                       `=---='                     #
//                #     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   #
//                #                                                   #
//                #               佛祖保佑         永无BUG              #
//                #                                                   #
//                #####################################################
//

//  Created by 微指 on 16/5/25.
//  Copyright © 2016年 Mekor. All rights reserved.
//

@import UIKit;

@interface MKScanner : NSObject

/**
*  使用视图实例化扫描器，扫描预览窗口会添加到指定视图中
*
*  @param view       指定的视图
*  @param scanFrame  扫描范围
*  @param completion 回调
*
*  @return Scaner
*/
+ (instancetype)scanerWithView:(UIView *)view scanFrame:(CGRect)scanFrame completion:(void (^)(NSString *stringValue))completion;

/**
 *  扫描图像
 *
 *  @param image      包含二维码的图像
 *  @param completion 目前只支持 64 位的 iOS 设备
 */
+ (void)scaneImage:(UIImage *)image completion:(void (^)(NSArray *values))completion;

/**
 *  使用 string / 头像 异步生成二维码图像
 *
 *  @param string     二维码图像的字符串
 *  @param avatar     头像图像，default 0.2
 *  @param completion 回调
 */
+ (void)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar completion:(void (^)(UIImage *image))completion;

/**
 *  使用 string / 头像 异步生成二维码图像，并且指定头像占二维码图像的比例
 *
 *  @param string     二维码图像的字符串
 *  @param avatar     头像图像
 *  @param scale      头像占的比例
 *  @param completion 回调
 */
+ (void)qrImageWithString:(NSString *)string avatar:(UIImage *)avatar scale:(CGFloat)scale completion:(void (^)(UIImage *image))completion;

/**
 *  开始扫描
 */
- (void)startScan;

/**
 *  停止扫描
 */
- (void)stopScan;

/**
 *  闪光灯是都打开
 *
 *  @param state 需要执行的状态
 */
- (void)torchMode:(BOOL)state;


@end
