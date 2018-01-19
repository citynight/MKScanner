//
//  UIView+Extensions.h
//  WeiZhiUser
//
//  Created by 微指 on 16/5/24.
//  Copyright © 2016年 WeiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (Extensions)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

//############################################


//@property(readonly) CGPoint bottomLeft;
//@property(readonly) CGPoint bottomRight;
//@property(readonly) CGPoint topRight;

/// Y坐标
@property CGFloat top;
/// X坐标
@property CGFloat left;
/// 底部 Y坐标+高度
@property CGFloat bottom;
/// 右侧 X坐标+宽度
@property CGFloat right;

- (void)moveBy:(CGPoint)delta;
- (void)scaleBy:(CGFloat)scaleFactor;
- (void)fitInSize:(CGSize)aSize;

/** 删除subViews */
- (void)removeAllSubviews;
@end
