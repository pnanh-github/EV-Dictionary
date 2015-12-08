//
//  ViewController.m
//  EVDictionary
//
//  Created by ADMIN on 11/5/15.
//  Copyright © 2015 Nhat Tung Media. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultTableViewCell.h"
#import "AppDelegate.h"
#import "RecentWordTableViewCell.h"

@interface ViewController ()
{
    NSArray *searchResult;
    NSMutableArray *recentData;
}
@property (weak, nonatomic) IBOutlet UISearchBar *_searchBar;
@property (weak, nonatomic) IBOutlet UITableView *_searchResultTable;
@property (weak, nonatomic) IBOutlet UITableView *_recentTable;
@property (weak, nonatomic) IBOutlet UILabel *lbemptyRecent;

- (IBAction)ClearRecent:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"RecentWords"]!=nil){
        recentData = [NSMutableArray arrayWithArray: [userDefault objectForKey:@"RecentWords"]];
    }
    if(recentData ==nil){
        recentData = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self._recentTable reloadData];
    self._searchResultTable.hidden=true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@",[searchText lowercaseString] ];
        searchResult =  [((AppDelegate*) [[UIApplication sharedApplication] delegate]).wordList filteredArrayUsingPredicate:predicate];
        [self._searchResultTable reloadData];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    self._searchResultTable.hidden = true;
    [searchBar resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==self._searchResultTable){
        self._searchResultTable.hidden = (searchResult.count<=0);
        return searchResult.count > 5 ? 5 : searchResult.count;
    }else{
        self.lbemptyRecent.hidden = recentData.count>0;
        return recentData.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView== self._searchResultTable){
        SearchResultTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        searchCell.lbWord.text = [[[[searchResult objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"] objectAtIndex:0] capitalizedString];
        return searchCell;
    }else{
        RecentWordTableViewCell *recentCell = [tableView dequeueReusableCellWithIdentifier:@"RecentWord"];
        recentCell.lbWord.text = [[[[recentData objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"] objectAtIndex:0] capitalizedString];
        return recentCell;
    }
    //return  nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *word=nil;
    if([segue.identifier isEqualToString:@"GetMeaning"]){
        word = [searchResult objectAtIndex:[self._searchResultTable indexPathForSelectedRow].row];
        if(recentData.count==0){
            [recentData addObject:word];
        }else if(![recentData containsObject:word]){
            [recentData insertObject:word atIndex:0];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            [userDefault setObject:recentData forKey:@"RecentWords"];
            [userDefault synchronize];
        
        });
        
        //NSLog(@"%@",word);
    }else{
        word = [recentData objectAtIndex:[self._recentTable indexPathForSelectedRow].row];
    }
    
    [userDefault setObject:word forKey:@"GetMeaning"];
}




- (IBAction)ClearRecent:(id)sender {
    [recentData removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:recentData forKey:@"RecentWords"];
        [userDefault synchronize];
        
    });
    [self._recentTable reloadData];
}
@end
