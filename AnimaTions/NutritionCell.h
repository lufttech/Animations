//
//  NutritionCell.h
//  AnimaTions
//
//  Created by Artem Shvets on 13.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NutritionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *component;
@property (weak, nonatomic) IBOutlet UILabel *valueText;
@property (weak, nonatomic) IBOutlet UIView *coloredUnderlay;

@end
