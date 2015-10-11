//
//  UIImage+MJ.h
//  04-图片裁剪
//
//  Created by apple on 14-4-14.
//  Copyright (c) 2014年 All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MJ)
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (instancetype)circleImageWithImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
+ (instancetype)scaleImage:(UIImage *)image toScale:(float)scaleSize;
@end
