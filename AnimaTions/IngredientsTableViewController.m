//
//  IngredientsTableViewController.m
//  AnimaTions
//
//  Created by Artem Shvets on 12.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "IngredientsTableViewController.h"
#import "IngredientCell.h"

@interface IngredientsTableViewController ()

@end

@implementation IngredientsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 35.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	IngredientCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IngredientCell class]) forIndexPath:indexPath];
	cell.ingredientName.text = _cellData[indexPath.row];
	return cell;
}
\

@end
