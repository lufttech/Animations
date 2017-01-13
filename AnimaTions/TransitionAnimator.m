//
//  TransitionAnimator.m
//  AnimaTions
//
//  Created by Artem Shvets on 10.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "TransitionAnimator.h"
#import "UIViewController+Transition.h"

@implementation TransitionAnimator
{
	//CGRect _endFrame;
}


- (instancetype)init
{
	self = [super init];
	if (self) {
	}
	return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return kTransitionAnimationDuration;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	transitionContext.containerView.backgroundColor = [UIColor clearColor];
	
	UIViewController <TransitionAnimatorProtocol>*fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	UIViewController <TransitionAnimatorProtocol>*toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	
	if (_presenting) {
		[self presentingTransition:transitionContext from:fromViewController to:toViewController];
	}else{
		[self dissmissingTransition:transitionContext from:fromViewController to:toViewController];
	}
}

- (void)presentingTransition:(id<UIViewControllerContextTransitioning>)transitionContext
						from:(UIViewController <TransitionAnimatorProtocol>*)fromVC
						  to:(UIViewController <TransitionAnimatorProtocol>*)toVC
{
	
	fromVC.view.userInteractionEnabled = NO;
	
	toVC.view.alpha = 0;
	[transitionContext.containerView addSubview:toVC.view];
	
	if ([fromVC respondsToSelector:@selector(prepareAnimatedViewsForPresentingViewController:)]) {
		[fromVC prepareAnimatedViewsForPresentingViewController:NO];
	}
	if ([toVC respondsToSelector:@selector(prepareAnimatedViewsForPresentingViewController:)]) {
		[toVC prepareAnimatedViewsForPresentingViewController:YES];
	}
	
	[UIView animateWithDuration:kTransitionAnimationDuration animations:^{
		toVC.view.alpha = 1;
		if ([fromVC respondsToSelector:@selector(animateViewsForPresentingViewController:)]) {
			[fromVC animateViewsForPresentingViewController:NO];
		}
		if ([toVC respondsToSelector:@selector(animateViewsForPresentingViewController:)]) {
			[toVC animateViewsForPresentingViewController:YES];
		}
	} completion:^(BOOL finished) {
		if ([fromVC respondsToSelector:@selector(completionAnimateViewsForPresentingViewController:)]) {
			[fromVC completionAnimateViewsForPresentingViewController:NO];
		}
		if ([toVC respondsToSelector:@selector(completionAnimateViewsForPresentingViewController:)]) {
			[toVC completionAnimateViewsForPresentingViewController:YES];
		}
		[transitionContext completeTransition:YES];
	}];
}
- (void)dissmissingTransition:(id<UIViewControllerContextTransitioning>)transitionContext
						 from:(UIViewController <TransitionAnimatorProtocol>*)fromVC
						   to:(UIViewController <TransitionAnimatorProtocol>*)toVC
{
	
	
	toVC.view.userInteractionEnabled = YES;
	
	if ([fromVC respondsToSelector:@selector(prepareAnimatedViewsForPresentingViewController:)]) {
		[fromVC prepareAnimatedViewsForPresentingViewController:NO];
	}
	if ([toVC respondsToSelector:@selector(prepareAnimatedViewsForPresentingViewController:)]) {
		[toVC prepareAnimatedViewsForPresentingViewController:YES];
	}
	
	[UIView animateWithDuration:kDissmissTransitionAnimationDuration animations:^{
		fromVC.view.alpha = 0;
		if ([fromVC respondsToSelector:@selector(animateViewsForPresentingViewController:)]) {
			[fromVC animateViewsForPresentingViewController:NO];
		}
		if ([toVC respondsToSelector:@selector(animateViewsForPresentingViewController:)]) {
			[toVC animateViewsForPresentingViewController:YES];
		}
	} completion:^(BOOL finished) {
		if ([fromVC respondsToSelector:@selector(completionAnimateViewsForPresentingViewController:)]) {
			[fromVC completionAnimateViewsForPresentingViewController:NO];
		}
		if ([toVC respondsToSelector:@selector(completionAnimateViewsForPresentingViewController:)]) {
			[toVC completionAnimateViewsForPresentingViewController:YES];
		}
		[transitionContext completeTransition:YES];
	}];
}

@end
