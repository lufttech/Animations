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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
