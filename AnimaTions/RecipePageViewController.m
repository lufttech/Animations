//
//  RecipePageViewController.m
//  AnimaTions
//
//  Created by Artem Shvets on 12.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "RecipePageViewController.h"
#import "IngredientsTableViewController.h"
#import "TipsTableViewController.h"
#import "NutritionTableViewController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "UIViewController+Configurator.h"

@interface RecipePageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, strong) IngredientsTableViewController *ingredientsViewController;
@property (nonatomic, strong) TipsTableViewController *tipsViewController;
@property (nonatomic, strong) NutritionTableViewController *nutritionViewController;
@property (nonatomic, strong) NSArray *controllersStack;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation RecipePageViewController
{
	NSInteger _page;
	NSInteger _currentPage;
}

- (NSArray *)controllersStack {
	if (_controllersStack == nil) {
		_controllersStack = @[self.ingredientsViewController,
							  self.tipsViewController,
							  self.nutritionViewController];
	}
	return _controllersStack;
}

- (NSArray *)titles {
	if (_titles == nil) {
		_titles = @[@"INGREDIENTS", @"TIPS", @"NUTRITION"];
	}
	return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.dataSource = self;
	self.delegate = self;
	[self setViewControllers:@[self.ingredientsViewController] direction:UIPageViewControllerNavigationDirectionForward
					animated:NO completion:^(BOOL finished) {}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	_currentPage = 0;
	_page = 0;
//	_activity = [[NSArray alloc] init];
//	
//	Resident* activeResident = [APIClientManager activeResident];
//	if (activeResident) {
//		self.navigationItem.title = [NSString stringWithFormat:@"%@'s Timeline",activeResident.fullName];
//	}else{
//		self.navigationItem.title = @"Timeline";
//	}
//	self.activityViewController.items = @[];
//	self.moodViewController.items = @[];
//	self.tempViewController.items = @[];
//	
//	CGRect pageControlFrame = self.pageControl.frame;
//	CGRect navBarFrame = self.navigationController.navigationBar.frame;
//	
//	pageControlFrame.size.height = 10;
//	pageControlFrame.origin.y = CGRectGetHeight(navBarFrame) - CGRectGetHeight(pageControlFrame) - 2;
//	pageControlFrame.origin.x = (CGRectGetWidth(navBarFrame) - CGRectGetWidth(pageControlFrame)) / 2;
//	_pageControl.frame = pageControlFrame;
//	[self getLatestTimeLines];
	
}

- (void)setCellData:(NSDictionary *)cellData
{
	_cellData = cellData;
	[self.ingredientsViewController setCellData:cellData];
	[self.tipsViewController setCellData:cellData];
	[self.nutritionViewController setCellData:cellData];
}

#pragma mark - Page Controller Delegate

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	NSInteger index = [self.controllersStack indexOfObject:viewController];
	if (index != 0) {
		return self.controllersStack[index - 1];
	}
	
	return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	NSInteger index = [self.controllersStack indexOfObject:viewController];
	if (index + 1 < self.controllersStack.count) {
		return self.controllersStack[index + 1];
	}
	return nil;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
	NSArray *controllers = pageViewController.viewControllers;
	UIViewController *curController = controllers.lastObject;
	
	NSInteger index = [self.controllersStack indexOfObject:curController];
	//_pageControl.currentPage = index;
	//[_segmentedControl setSelectedSegmentIndex:index];
 //   self.navigationItem.title = self.titles[index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Getters

- (IngredientsTableViewController *)ingredientsViewController
{
	if (!_ingredientsViewController) {
		_ingredientsViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([IngredientsTableViewController class])];
	}
	return _ingredientsViewController;
}
- (TipsTableViewController *)tipsViewController
{
	if (!_tipsViewController) {
		_tipsViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TipsTableViewController class])];
	}
	return _tipsViewController;
}
- (NutritionTableViewController *)nutritionViewController
{
	if (!_nutritionViewController) {
		_nutritionViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([NutritionTableViewController class])];
	}
	return _nutritionViewController;
}


#pragma mark - Actions

- (void)selectPageAtIndex:(NSInteger)index
{
	UIViewController* selectedViewController;
	
	switch (index) {
		case 0:
		{
		selectedViewController = self.ingredientsViewController;
		}
			break;
		case 1:
		{
		selectedViewController = self.tipsViewController;
		}
			break;
		case 2:
		{
		selectedViewController = self.nutritionViewController;
		}
			break;
			
  default:
			break;
	}
	[self setViewControllers:@[selectedViewController] direction:UIPageViewControllerNavigationDirectionForward
					animated:NO completion:^(BOOL finished) {}];
}
//- (void)segmentedControlChangedValue:(HMSegmentedControl*)segmentController
//{
//	
//	UIViewController* selectedViewController;
//	
//	switch (segmentController.selectedSegmentIndex) {
//		case 0:
//		{
//		selectedViewController = self.ingredientsViewController;
//		}
//			break;
//		case 1:
//		{
//		selectedViewController = self.tipsViewController;
//		}
//			break;
//		case 2:
//		{
//		selectedViewController = self.nutritionViewController;
//		}
//			break;
//			
//  default:
//			break;
//	}
//	[self setViewControllers:@[selectedViewController] direction:UIPageViewControllerNavigationDirectionForward
//					animated:NO completion:^(BOOL finished) {}];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
