//
//  DetailRecipeViewController.m
//  AnimaTions
//
//  Created by Artem Shvets on 06.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "NutritionTableViewController.h"
#import "TransitionAnimator.h"
#import "DetailRecipeViewController.h"
#import <CoreText/CoreText.h>
#import "UIScrollView+App.h"
#import "UIViewController+Configurator.h"
#import "IngredientsTableViewController.h"
#import "TipsTableViewController.h"
#import "ASSegmentControl.h"



@interface DetailRecipeViewController ()<TransitionAnimatorProtocol, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *recTitle;
@property (weak, nonatomic) IBOutlet UIView *cookingTimeView;
@property (weak, nonatomic) IBOutlet UILabel *recSubtitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *recipeLabel;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cookingViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recipeLabelTopConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *cookingTime;
@property (weak, nonatomic) IBOutlet UIView *segmentContainer;
@property (weak, nonatomic) IBOutlet ASSegmentControl *segmentControl;

@property (nonatomic, strong) IngredientsTableViewController *ingredientsViewController;
@property (nonatomic, strong) TipsTableViewController *tipsViewController;
@property (nonatomic, strong) NutritionTableViewController *nutritionViewController;
@property (nonatomic, strong) NSArray *controllersStack;
@property (nonatomic, strong) NSArray *titles;


@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containers;
@property (weak, nonatomic) IBOutlet UIScrollView *containersScrollView;

@end


#define kLeftInset 100.0f

@implementation DetailRecipeViewController
{
	NSInteger _page;
	NSInteger _currentPage;
	CGFloat _pageLayerStartPosition;
	CGFloat _lastContentOffset;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	UINavigationBar *myNav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
	
	UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:@""];
	navigItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"like"]
																   style:UIBarButtonItemStyleDone
																  target:self
																  action:@selector(like)];
	navigItem.rightBarButtonItem.tintColor = [UIColor blackColor];
	navigItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"]
																  style:UIBarButtonItemStyleDone
																 target:self
																 action:@selector(backAction:)];
	navigItem.leftBarButtonItem.tintColor = [UIColor blackColor];
	myNav.items = [NSArray arrayWithObjects: navigItem,nil];
	[self.view addSubview:myNav];

}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_currentPage = 0;
	_page = 0;
	self.scrollView.delegate = (UIViewController <UIScrollViewDelegate>*)self.presentingViewController;
	self.scrollView.delaysContentTouches = YES;
	self.scrollView.canCancelContentTouches = NO;
	
	[self.segmentControl setSectionTitles:@[@"INGREDIENTS", @"TIPS", @"NUTRITION"]];
	[self.segmentControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Marta" size:14.0f]}];
	[self setupData];
}
-(BOOL)prefersStatusBarHidden{
	return YES;
}
- (void)setupData
{
	self.recTitle.text = self.cellData[@"title"];
	self.recSubtitle.text = self.cellData[@"subtitle"];
	self.recipeLabel.text = self.cellData[@"recipe"];
	self.cookingTime.text = self.cellData[@"cookingTime"];
	[self.imageView setImage:[UIImage imageNamed:self.cellData[@"image"]]];
	
	NSArray* children = self.childViewControllers;
	self.ingredientsViewController = children[0];
	self.ingredientsViewController.cellData = _cellData[@"ingredients"];
	self.tipsViewController = children[1];
	self.tipsViewController.cellData = _cellData[@"tips"];
	self.nutritionViewController = children[2];
	self.nutritionViewController.cellData = _cellData[@"nutrition"];
	
	_pageLayerStartPosition = self.nutritionViewController.view.layer.position.x;
}

#pragma mark - Getters



#pragma mark - Transition Animation Delegate


- (void)prepareAnimatedViewsForPresentingViewController:(BOOL)isPresented
{
	

	[self.view layoutIfNeeded];
	if (isPresented) {
		_cookingTimeView.alpha = 0.5f;
		self.imageView.alpha = 1;
		self.upConstaint.constant = - kTopOffset;
		self.recipeLabelTopConstraint.constant = 30;
		self.cookingViewConstraint.constant = 30;
		self.recipeLabel.alpha = 0.f;
		self.recipeLabel.transform = CGAffineTransformMakeScale(0.9, 0.9);
	}else{
		self.upConstaint.constant = 0;
	}
	
}
- (void)animateViewsForPresentingViewController:(BOOL)isPresented
{
	[self.view layoutIfNeeded];
	if (isPresented) {
		self.recipeLabel.alpha = 1.f;
		_cookingTimeView.alpha = 1.f;
		self.midView.transform = CGAffineTransformMakeScale(1.5f , 1.5f);
		self.recipeLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
	}else{
		[self.scrollView setScrollsToTop:NO];
	}
	
}
- (void)completionAnimateViewsForPresentingViewController:(BOOL)isPresented
{
	
}

#pragma mark - Scroll View Delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	*targetContentOffset = scrollView.contentOffset;
	float pageWidth = (float)self.scrollView.bounds.size.width - kLeftInset;
	
	long roundedCellToSwipe = lroundf(scrollView.contentOffset.x / pageWidth);
	
	
	if (roundedCellToSwipe <= self.childViewControllers.count - 1) {
		CGFloat different = (float)roundedCellToSwipe - (scrollView.contentOffset.x / pageWidth);
		
		NSInteger skipedIndex = roundedCellToSwipe - _currentPage;
		
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
		} else if (roundedCellToSwipe >= self.childViewControllers.count - 1) {
			roundedCellToSwipe = (float)self.childViewControllers.count - 1;
		}
		
		NSInteger prevPage = _currentPage;
		_currentPage = roundedCellToSwipe;
		if(_currentPage != prevPage) [self.segmentControl setSelectedSegmentIndex:_currentPage animated:YES notify:NO];
		
		[scrollView scrollRectToVisible:CGRectMake(roundedCellToSwipe* scrollView.frame.size.width - kLeftInset, 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
		[self.containers enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL * _Nonnull stop) {
			[UIView animateWithDuration:0.15 animations:^{
				if (idx != _currentPage) view.alpha = 0;
				else view.alpha = 1;
			}];
			
		}];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	float width = (float)scrollView.bounds.size.width - kLeftInset;
	CGFloat different = scrollView.contentOffset.x / width;
	BOOL isFromLeftToRight;
	if (_lastContentOffset > scrollView.contentOffset.x)
		isFromLeftToRight = NO;
	else if (_lastContentOffset < scrollView.contentOffset.x)
		isFromLeftToRight = YES;
	
	_lastContentOffset = scrollView.contentOffset.x;
	
	
	if (!isFromLeftToRight) {
		NSInteger prevPage = _currentPage - 1;
		
		UIView* view = [self viewAtIndex:_currentPage];
		UIView* prevView = [self viewAtIndex:prevPage];
		
		[view setAlpha:different - prevPage];
		
		[prevView setAlpha:1 - view.alpha];
		NSLog(@"\nViewAlpha: %f \nPreViewAlpha: %f\n",view.alpha, prevView.alpha);
	}else{
		NSInteger nextPage = _currentPage + 1;
		
		UIView* view = [self viewAtIndex:_currentPage];
		UIView* nextView = [self viewAtIndex:nextPage];
		
		[nextView setAlpha:different - _currentPage];
		[view setAlpha:1 - nextView.alpha];
		
	}
	
}

- (UIView*)viewAtIndex:(NSInteger)index
{
	if (index >= 0 && index < self.childViewControllers.count) {
		return self.containers[index];
	}
	return nil;
}

#pragma mark - Actions
- (IBAction)segmentControlChangedValue:(ASSegmentControl*)sender {
	_currentPage = sender.selectedSegmentIndex;
	
	[self.containersScrollView scrollRectToVisible:CGRectMake(_currentPage * self.containersScrollView.frame.size.width - kLeftInset, 0, self.containersScrollView.frame.size.width, self.containersScrollView.frame.size.height) animated:YES];
	[self.containers enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL * _Nonnull stop) {
		[UIView animateWithDuration:0.3 animations:^{
			if (idx != _currentPage) view.alpha = 0;
			else view.alpha = 1;
		}];
		
	}];
}
- (IBAction)backAction:(id)sender {
	[self.scrollView stop];
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)like
{
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
