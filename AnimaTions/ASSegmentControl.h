//
//  ASSegmentControl.h
//  AnimaTions
//
//  Created by Artem Shvets on 18.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASSegmentControl : UIControl
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, strong) NSArray *sectionTitles;

@property (nonatomic, strong) IBInspectable UIColor* underLineColor;
@property (nonatomic, strong) IBInspectable UIColor* selectionColor;

@property (nonatomic, strong) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *selectedTitleTextAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;


@property (nonatomic) IBInspectable CGFloat underlayThickness;

- (instancetype)initWithSectionTitles:(NSArray *)sectiontitles;
- (void)setSelectedSegmentIndex:(NSInteger)index;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated notify:(BOOL)notify;

@end
