//
//  NutritionTableViewController.m
//  AnimaTions
//
//  Created by Artem Shvets on 12.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "NutritionTableViewController.h"
#import "NutritionCell.h"


@interface NutritionTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *apm;

@end

@implementation NutritionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 35.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setCellData:(NSArray *)cellData
{
	_cellData = cellData;
	[self.tableView reloadData];
}
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return _cellData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NutritionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NutritionCell class]) forIndexPath:indexPath];
	NSDictionary* nutrition = _cellData[indexPath.row];
	cell.component.text = nutrition[@"component"];
	cell.valueText.text = [NSString stringWithFormat:@"%@ %@",nutrition[@"mass"],nutrition[@"metrick"]];
	if (indexPath.row%2 == 0) {
		cell.coloredUnderlay.backgroundColor = [UIColor colorWithRed:246.0f/255.f green:246.0f/255.f blue:246.0f/255.f alpha:1];
	}else{
		cell.coloredUnderlay.backgroundColor = [UIColor whiteColor];
	}
	
	return cell;
}

@end
