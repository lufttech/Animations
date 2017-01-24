//
//  TipsTableViewController.m
//  AnimaTions
//
//  Created by Artem Shvets on 12.01.17.
//  Copyright © 2017 Artem Shvets. All rights reserved.
//

#import "TipsTableViewController.h"
#import "TipsCell.h"

@interface TipsTableViewController ()

@end

@implementation TipsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 100;
}
- (void)setCellData:(NSArray *)cellData
{
	_cellData = cellData;
	[self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _cellData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TipsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TipsCell class]) forIndexPath:indexPath];
	NSDictionary* tip = _cellData[indexPath.row];
	[cell.tipImage setImage:[UIImage imageNamed:tip[@"image"]]];
	[cell.tipDescription setText:tip[@"description"]];
	
    return cell;
}


@end
