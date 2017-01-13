//
//  UIViewController+Configurator.m
//  Situate
//
//  Created by Artem Shvets on 02.11.16.
//  Copyright © 2016 Llamadigital. All rights reserved.
//

#import "UIViewController+Configurator.h"

@implementation UIViewController (Configurator)

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView forSize:(CGSize)size
{
	[self.view layoutIfNeeded];
	subView.frame = parentView.bounds;
	[parentView addSubview:subView];
	subView.translatesAutoresizingMaskIntoConstraints = NO;
	parentView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSLayoutConstraint *constraintVertical = [NSLayoutConstraint constraintWithItem:subView
																		  attribute:NSLayoutAttributeCenterX
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:subView.superview
																		  attribute:NSLayoutAttributeCenterX
																		 multiplier:1.0f
																		   constant:0.0f];
	
	NSLayoutConstraint *constraintHorizontal = [NSLayoutConstraint constraintWithItem:subView
																			attribute:NSLayoutAttributeCenterY
																			relatedBy:NSLayoutRelationEqual
																			   toItem:subView.superview
																			attribute:NSLayoutAttributeCenterY
																		   multiplier:1.0f
																			 constant:0.0f];
	
	[subView addConstraint:[NSLayoutConstraint constraintWithItem:subView
													  attribute:NSLayoutAttributeWidth
													  relatedBy:NSLayoutRelationEqual
														 toItem:nil
													  attribute:NSLayoutAttributeNotAnAttribute
													 multiplier:1
													   constant:size.width]];
	
	[subView addConstraint:[NSLayoutConstraint constraintWithItem:subView
													  attribute:NSLayoutAttributeHeight
													  relatedBy:NSLayoutRelationEqual
														 toItem:nil
													  attribute:NSLayoutAttributeNotAnAttribute
													 multiplier:1
													   constant:size.height]];
	
	[parentView addConstraints:@[constraintVertical,constraintHorizontal]];
	[parentView layoutIfNeeded];
}

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
	[self.view layoutIfNeeded];
	subView.frame = parentView.bounds;
	[parentView addSubview:subView];
	subView.translatesAutoresizingMaskIntoConstraints = NO;
	parentView.translatesAutoresizingMaskIntoConstraints = NO;
	
	NSDictionary * views = @{@"subView" : subView,};
	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
																   options:0
																   metrics:0
																	 views:views];
	[parentView addConstraints:constraints];
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
														  options:0
														  metrics:0
															views:views];
	[parentView addConstraints:constraints];
	[parentView layoutIfNeeded];
}

@end
