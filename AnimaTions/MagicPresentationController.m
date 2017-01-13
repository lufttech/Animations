//
//  MagicPresentationController.m
//  AnimaTions
//
//  Created by Artem Shvets on 10.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "MagicPresentationController.h"

@implementation MagicPresentationController
- (CGRect)frameOfPresentedViewInContainerView
{
	CGRect presentedViewFrame = CGRectZero;
	CGRect containerBounds = [[self containerView] bounds];
 
	presentedViewFrame.size = CGSizeMake(floorf(containerBounds.size.width / 2.0),
										 containerBounds.size.height);
	presentedViewFrame.origin.x = containerBounds.size.width -
	presentedViewFrame.size.width;
	return presentedViewFrame;
}

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
					   presentingViewController:(UIViewController *)presentingViewController
{
	self = [super initWithPresentedViewController:presentedViewController
						 presentingViewController:presentingViewController];
	if(self) {
		// Create the dimming view and set its initial appearance.
//		self.dimmingView = [[UIView alloc] init];
//		[self.dimmingView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
//		[self.dimmingView setAlpha:0.0];
	}
	return self;
}
@end
