//
//  TransitionAnimator.h
//  AnimaTions
//
//  Created by Artem Shvets on 10.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kTopOffset 100.0f
#define kTransitionAnimationDuration 0.75f
#define kDissmissTransitionAnimationDuration 0.3f

@protocol TransitionAnimatorProtocol <NSObject>

@required
- (void)prepareAnimatedViewsForPresentingViewController:(BOOL)isPresented;
- (void)animateViewsForPresentingViewController:(BOOL)isPresented;
- (void)completionAnimateViewsForPresentingViewController:(BOOL)isPresented;

@end

@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@end
