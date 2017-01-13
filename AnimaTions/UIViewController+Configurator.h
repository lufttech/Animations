//
//  UIViewController+Configurator.h
//  Situate
//
//  Created by Artem Shvets on 02.11.16.
//  Copyright © 2016 Llamadigital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Configurator)

//- (void)setBaseColours:(Application *)appStyle;
- (void)addSubview:(UIView *)subView toView:(UIView*)parentView;
- (void)addSubview:(UIView *)subView toView:(UIView*)parentView forSize:(CGSize)size;

@end
