//
//  TipsCell.h
//  AnimaTions
//
//  Created by Artem Shvets on 13.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tipDescription;
@property (weak, nonatomic) IBOutlet UIImageView *tipImage;

@end
