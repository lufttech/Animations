//
//  UIViewController+Transition.m
//  AnimaTions
//
//  Created by Artem Shvets on 11.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "UIViewController+Transition.h"

@implementation UIViewController (Transition)

- (UIView *)viewForTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
	if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
		NSString *key = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] == self ? UITransitionContextFromViewKey : UITransitionContextToViewKey;
		return [transitionContext viewForKey:key];
	} else {
		return self.view;
	}
}

@end
