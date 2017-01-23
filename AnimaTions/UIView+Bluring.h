//
//  UIView+Bluring.h
//  AnimaTions
//
//  Created by Artem Shvets on 19.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Bluring)

//@property (nonatomic, strong) UIImage* normalImage;
@property (nonatomic, strong) UIImage* gausedImage;
@property (nonatomic, strong) UIImage* motionImage;
@property (nonatomic, strong) UIImage* currentImageContext;

@property (nonatomic, strong) id originContents;;

- (void)blurWithRadius:(CGFloat)radius;
- (void)motionBlurWithSize:(CGFloat)radius;

- (void)showGausianContextIfExist;
- (void)showMotionContextIfExist;
//- (void)showNormalContextIfExist;
- (void)clearContext;
@end
