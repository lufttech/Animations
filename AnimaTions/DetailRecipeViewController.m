//
//  DetailRecipeViewController.m
//  AnimaTions
//
//  Created by Artem Shvets on 06.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//
#import "TransitionAnimator.h"
#import "DetailRecipeViewController.h"
#import <CoreText/CoreText.h>
#import "UIScrollView+App.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "UIViewController+Configurator.h"
#import "RecipePageViewController.h"



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
@property (strong, nonatomic) HMSegmentedControl* segmentedControl;
@property (weak, nonatomic) RecipePageViewController* recipePageVC;
@end

@implementation DetailRecipeViewController

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
	self.scrollView.delegate = (UIViewController <UIScrollViewDelegate>*)self.presentingViewController;
	self.scrollView.delaysContentTouches = YES;
	self.scrollView.canCancelContentTouches = NO;
	//self.scrollView.panGestureRecognizer.delaysTouchesBegan = YES;
	self.recipePageVC = [self.childViewControllers firstObject];
	[self.recipePageVC setCellData:self.cellData];
	[self addSubview:self.segmentedControl toView:self.segmentContainer];
	
	[self setupData];
    // Do any additional setup after loading the view.
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
}

#pragma mark - Getters

- (HMSegmentedControl *)segmentedControl
{
	if (!_segmentedControl) {
		_segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"INGREDIENTS", @"TIPS", @"NUTRITION"]];

		_segmentedControl.type = HMSegmentedControlTypeText;
		_segmentedControl.borderType = HMSegmentedControlBorderTypeBottom;
		_segmentedControl.borderColor = [UIColor colorWithRed:246.0f/255.f green:246.0f/255.f blue:246.0f/255.f alpha:1];
		_segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
		_segmentedControl.backgroundColor = [UIColor whiteColor];
		_segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
		_segmentedControl.shouldAnimateUserSelection = YES;
		_segmentedControl.selectionIndicatorHeight = 1.5f;
		_segmentedControl.selectionIndicatorColor = [UIColor blackColor];
		
		
		NSDictionary* attributes = @{NSForegroundColorAttributeName : [UIColor darkGrayColor], NSFontAttributeName : [UIFont fontWithName:@"Marta" size:12.f]};
		_segmentedControl.titleTextAttributes = attributes;
		_segmentedControl.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
		//[_segmentedControl buildAppHMSegmentController];
		[_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
		[_segmentedControl setSelectedSegmentIndex:0];
	}
	return _segmentedControl;
}

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
		//self.titleTopConstraint.constant += kTopOffset;
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
//		if (self.scrollView.contentOffset.y < self.imageView.frame.size.height) {
//			self.imageView.hidden = YES;
//		}
		[self.scrollView setScrollsToTop:NO];
	}
	
}
- (void)completionAnimateViewsForPresentingViewController:(BOOL)isPresented
{
	
}

#pragma mark - Actions
- (void)segmentedControlChangedValue:(HMSegmentedControl*)control
{
	
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
