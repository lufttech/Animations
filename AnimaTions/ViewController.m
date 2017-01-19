//
//  ViewController.m
//  AnimaTions
//
//  Created by Artem Shvets on 28.12.16.
//  Copyright © 2016 Artem Shvets. All rights reserved.
//

#import "ViewController.h"
#import "RecipeCell.h"
#import "DetailRecipeViewController.h"
#import "LoremIpsum+FakeRecipe.h"
#import <LoremIpsum/LoremIpsum.h>
#import "TransitionAnimator.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecipeCellDelegate, UIViewControllerTransitioningDelegate, TransitionAnimatorProtocol>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray* dataSource;

@end

@implementation ViewController
{
	NSIndexPath* _currentIndexPath;

}

- (void)viewDidLoad {
	[super viewDidLoad];
	_currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, self.view.frame.size.height*0.1f, 0)];
	 //setContentSize:CGSizeMake(self.collectionView.contentSize.width, self.collectionView.contentSize.height + self.view.frame.size.height*0.1f)];
	[self loadData];
}


#pragma mark - Action

- (void)loadData
{
	_dataSource = [LoremIpsum fakeRecipes:10];
}

#pragma mark - Collection View Delegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	RecipeCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RecipeCell class]) forIndexPath:indexPath];
	cell.indexPath = indexPath;
	cell.delegate = self;
	[cell configWithData:_dataSource[indexPath.row]];
	return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*0.90);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
				   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return 0;
}

- (void)animateCellsWithOffset:(CGPoint)offset
{
	NSArray* visible = self.collectionView.visibleCells;
	
	[visible enumerateObjectsUsingBlock:^(RecipeCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
		[cell animateWithOffset:offset];
	}];
}

#pragma mark - Scroll View Delgate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
					 withVelocity:(CGPoint)velocity
			  targetContentOffset:(inout CGPoint *)targetContentOffset {
	
	if ([scrollView isKindOfClass:[UICollectionView class]]) {
		*targetContentOffset = scrollView.contentOffset;
		float pageHeight = (float)self.collectionView.bounds.size.height*0.90;
		
		long roundedCellToSwipe = lroundf(scrollView.contentOffset.y / pageHeight);
		
		
		if (roundedCellToSwipe <= self.dataSource.count - 1) {
			CGFloat different = (float)roundedCellToSwipe - (scrollView.contentOffset.y / pageHeight);
			
			NSInteger skipedIndex = roundedCellToSwipe - _currentIndexPath.row;
			
			if(different > 0) skipedIndex --;
			if(different <= 0) skipedIndex ++;
			
			NSLog(@"RoundedCellToSwipe: %f\n",different);
			
			if ((different > 0.15f) && (different < 0.45f)) {
				roundedCellToSwipe -= labs(skipedIndex);
			}else if((different < -0.15f) && (different > -0.45f)){
				roundedCellToSwipe += labs(skipedIndex);
			}
			
			if (roundedCellToSwipe < 0) {
				roundedCellToSwipe = 0.f;
			} else if (roundedCellToSwipe >= self.dataSource.count - 1) {
				roundedCellToSwipe = (float)self.dataSource.count - 1;
			}
			
			_currentIndexPath = [NSIndexPath indexPathForRow:roundedCellToSwipe inSection:0];
			
			[self.collectionView scrollToItemAtIndexPath:_currentIndexPath
										atScrollPosition:UICollectionViewScrollPositionTop
												animated:YES];
		}
	}
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ([scrollView isKindOfClass:[UICollectionView class]]) {
		[self animateCellsWithOffset:scrollView.contentOffset];
	}else{
		RecipeCell* currentCell = (RecipeCell*)[self.collectionView cellForItemAtIndexPath:_currentIndexPath];
		[currentCell setContentViewOffsetY:scrollView.contentOffset.y + kTopOffset];
	}
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ([scrollView isKindOfClass:[UICollectionView class]]) {
	}
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{	NSLog(@"END OF SCROLLING");
	if ([scrollView isKindOfClass:[UICollectionView class]]) {
		//[self animateCellsWithOffset:scrollView.contentOffset isEndPage:YES];
	}
}

-(BOOL)prefersStatusBarHidden{
	return YES;
}
#pragma mark - Recipe Cell Delegate

- (void)showRecipeWasClicked:(RecipeCell *)cell{
	NSDictionary* cellData = _dataSource[cell.indexPath.row];
	DetailRecipeViewController* detailRecipe = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([DetailRecipeViewController class])];
	detailRecipe.transitioningDelegate = self;
	detailRecipe.modalPresentationStyle = UIModalPresentationCustom;
	detailRecipe.cellData = cellData;
	
	[self presentViewController:detailRecipe animated:YES completion:Nil];
}

#pragma mark - Transition Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController*)presented
																  presentingController:(UIViewController *)presenting
																	  sourceController:(UIViewController *)source
{
	TransitionAnimator* animator = [TransitionAnimator new];
	animator.presenting = YES;
	return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController*)dismissed
{
	TransitionAnimator* animator = [TransitionAnimator new];
	return animator;
}

- (void)prepareAnimatedViewsForPresentingViewController:(BOOL)isPresented
{
	//	if (isPresented) {
	//
	//	}else{
	//		NSArray* visible = self.collectionView.visibleCells;
	//		[visible enumerateObjectsUsingBlock:^(RecipeCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
	//			[cell transitionAnimation:idx];
	//		}];
	//	}
}
- (void)animateViewsForPresentingViewController:(BOOL)isPresented
{
	RecipeCell* currentCell = (RecipeCell*)[self.collectionView cellForItemAtIndexPath:_currentIndexPath];
	NSArray* visible = self.collectionView.visibleCells;
	[visible enumerateObjectsUsingBlock:^(RecipeCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
		[cell transitionAnimationForCurrent:[cell isEqual:currentCell] isPresent:isPresented];
	}];
}
- (void)completionAnimateViewsForPresentingViewController:(BOOL)isPresented
{
	RecipeCell* currentCell = (RecipeCell*)[self.collectionView cellForItemAtIndexPath:_currentIndexPath];
	NSArray* visible = self.collectionView.visibleCells;
	[visible enumerateObjectsUsingBlock:^(RecipeCell *cell, NSUInteger idx, BOOL * _Nonnull stop) {
		[cell transitionCompletionForCurrent:[cell isEqual:currentCell] isPresent:isPresented];
	}];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
