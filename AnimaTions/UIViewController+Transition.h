//
//  UIViewController+Transition.h
//  AnimaTions
//
//  Created by Artem Shvets on 11.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Transition)
- (UIView *)viewForTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext;
@end
