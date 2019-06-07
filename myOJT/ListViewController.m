//
//  ListViewController.m
//  myOJT
//
//  Created by FrontEnd on 07/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import "ListViewController.h"
#import "DBInterface.h"
#import "MyTableViewCell.h"
#import <sqlite3.h>
#define PAGE_PER_COUNT ((int) 15)
@interface ListViewController () <UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIViewController *vc;
@property (strong, nonatomic) UINavigationController *navCtrl;
@property (strong, nonatomic) UITableViewController *tableCtrl;
@property (strong, nonatomic) IBOutlet UITableView *table;


@property int totalCount;
@property int totalPage;
@property int curruntPage;

@property NSArray *myArr;

@end

@implementation ListViewController {
    DBInterface *myDB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vc = [[UIViewController alloc] init];
    self.navCtrl = [[UINavigationController alloc] initWithRootViewController:self.vc];
    self.tableCtrl = [[UITableViewController alloc] init];
    
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Back"] style:UIBarButtonItemStylePlain target:self.navCtrl action:@selector(popViewControllerAnimated:)];
    
    [self.navigationItem setBackBarButtonItem:btnBack];
    self.navigationItem.hidesBackButton = NO;
    
    myDB = [[DBInterface alloc] initWithDataBaseFileName:@"my_ojt" withVC: [[[[UIApplication sharedApplication] delegate] window] rootViewController]];
    
    self.totalCount = (int) [myDB totalCount];
    self.totalPage = self.totalCount / PAGE_PER_COUNT + (self.totalCount % PAGE_PER_COUNT == 0 ? 0 : 1);
    self.curruntPage = 1;
    
    NSLog(@"totalCount = %d", self.totalCount);
    NSLog(@"totalPage = %d", self.totalPage);
    NSLog(@"curruntPage = %d", self.curruntPage);
    
    self.myArr = [myDB searchWithPage:self.curruntPage];
    NSLog(@"arr count : %ld", (long) [self.myArr count]);
    
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.rowHeight = 50;
    [self.table registerNib:[UINib nibWithNibName:@"MyTableViewCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.myArr != nil) {
        return [self.myArr count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = (MyTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:self options:nil];
    }
    NSLog(@"cellForRowAtIndexPath");
    [cell.ivPhoto setImage:nil];
    [cell.tvTitle setText:[[self.myArr objectAtIndex:indexPath.row] objectForKey:@"title"]];
    return nil;
}

@end
