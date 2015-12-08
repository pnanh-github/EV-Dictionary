//
//  LeftMenuViewController.m
//  EVDictionary
//
//  Created by ADMIN on 11/5/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "MenuItemTableViewCell.h"
#import "AppDelegate.h"
@interface LeftMenuViewController ()

{
    NSMutableArray *menuItems;
    NSInteger selectedIndex;
}

@end

@implementation LeftMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    menuItems = [NSMutableArray new];
    [menuItems addObjectsFromArray:@[@"Tu dien Viet - Anh",@"Gioi Thieu",@"Lien He"]];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menu-item"];
    
    cell.titleLabel.text = [menuItems objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectedImage.hidden = (self->selectedIndex != indexPath.row);
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath.row;
    switch ((int)selectedIndex) {
        case 0:
             [((AppDelegate*) [UIApplication sharedApplication].delegate) OpenMain];
            break;
        case 1:{
            [((AppDelegate*) [UIApplication sharedApplication].delegate) OpenAbout];
            }
            break;
        case 2:
            break;
            
        default:
            break;
    }
    [tableView reloadData];
}

@end
