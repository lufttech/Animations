//
//  RecipeCell.h
//  AnimaTions
//
//  Created by Artem Shvets on 28.12.16.
//  Copyright © 2016 Artem Shvets. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RecipeCell.h"

@protocol RecipeCellDelegate;


@interface RecipeCell : UICollectionViewCell
@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, weak) id <RecipeCellDelegate> delegate;

- (void)configWithData:(NSDictionary*)data;
- (void)animateWithOffset:(CGPoint)offset;
- (void)transitionAnimationForCurrent:(BOOL)isCurrent isPresent:(BOOL)isPresent;
- (void)transitionCompletionForCurrent:(BOOL)isCurrent isPresent:(BOOL)isPresent;
- (void)setContentViewOffsetY:(CGFloat)offsetY;
@end

@protocol RecipeCellDelegate <NSObject>

- (void)showRecipeWasClicked:(RecipeCell*)cell;

@end
