//
//  ListViewController.m
//  myOJT
//
//  Created by FrontEnd on 07/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import "ListViewController.h"
#import "DBInterface.h"
#import "CustomTableViewCell.h"
#import "Photo.h"
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
@property BOOL isLoading;

@property NSMutableArray *myArr;
@property UIView *footerView;
@property dispatch_queue_t queue;
@end

@implementation ListViewController {
    DBInterface *myDB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isLoading = YES;
    
    self.vc = [[UIViewController alloc] init];
    self.navCtrl = [[UINavigationController alloc] initWithRootViewController:self.vc];
    self.tableCtrl = [[UITableViewController alloc] init];
    [self initFooterView];
    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    self.navigationItem.hidesBackButton = NO;
    
    myDB = [[DBInterface alloc] initWithDataBaseFileName:@"my_ojt" withVC: [[[[UIApplication sharedApplication] delegate] window] rootViewController]];
    
    self.totalCount = (int) [myDB totalCount];
    self.totalPage = self.totalCount / PAGE_PER_COUNT + (self.totalCount % PAGE_PER_COUNT == 0 ? 0 : 1);
    self.curruntPage = 1;
    
    NSLog(@"totalCount = %d", self.totalCount);
    NSLog(@"totalPage = %d", self.totalPage);
    NSLog(@"curruntPage = %d", self.curruntPage);
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    self.myArr = [myDB searchWithPage:self.curruntPage];
    
    [self.myArr addObject:[Photo initWithTitle:@"1" withUrl:@"https://content.mycutegraphics.com/graphics/fall/girl-jumping-in-leaves.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"2" withUrl:@"https://content.mycutegraphics.com/graphics/fall/autumn-pumpkin.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"3" withUrl:@"https://content.mycutegraphics.com/graphics/fall/gold-oak-autumn-leaf.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"4" withUrl:@"https://content.mycutegraphics.com/graphics/nature/acorn.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"5" withUrl:@"https://content.mycutegraphics.com/graphics/fall/golden-autumn-tree.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"6" withUrl:@"https://content.mycutegraphics.com/graphics/fall/two-acorns.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"7" withUrl:@"https://content.mycutegraphics.com/graphics/fall/pretty-maroon-autumn-tree.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"8" withUrl:@"https://content.mycutegraphics.com/graphics/nature/acorn.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"9" withUrl:@"https://content.mycutegraphics.com/graphics/fall/purple-autumn-leaf.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"1" withUrl:@"https://content.mycutegraphics.com/graphics/fall/girl-jumping-in-leaves.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"2" withUrl:@"https://content.mycutegraphics.com/graphics/fall/autumn-pumpkin.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"3" withUrl:@"https://content.mycutegraphics.com/graphics/fall/gold-oak-autumn-leaf.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"4" withUrl:@"https://content.mycutegraphics.com/graphics/nature/acorn.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"5" withUrl:@"https://content.mycutegraphics.com/graphics/fall/golden-autumn-tree.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"6" withUrl:@"https://content.mycutegraphics.com/graphics/fall/two-acorns.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"7" withUrl:@"https://content.mycutegraphics.com/graphics/fall/pretty-maroon-autumn-tree.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"8" withUrl:@"https://content.mycutegraphics.com/graphics/nature/acorn.png"]];
    [self.myArr addObject:[Photo initWithTitle:@"9" withUrl:@"https://content.mycutegraphics.com/graphics/fall/purple-autumn-leaf.png"]];
    
    NSLog(@"arr count : %ld", (long) [self.myArr count]);
    [self.table reloadData];
    self.isLoading = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void) initFooterView {
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UIActivityIndicatorView *acInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    acInd.tag = 10;
    acInd.frame = CGRectMake(self.footerView.frame.size.width/2, self.footerView.frame.size.height/2, 0, 0);
    acInd.hidesWhenStopped = YES;
    [self.footerView addSubview:acInd];
    acInd = nil;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL endOfTable = (scrollView.contentOffset.y >= (([self.myArr count] * 80) - scrollView.frame.size.height));
    if (self.myArr && endOfTable && !scrollView.dragging && !scrollView.decelerating && !self.isLoading) {
        self.table.tableFooterView = self.footerView;
        [(UIActivityIndicatorView *) [self.footerView viewWithTag:10] startAnimating];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.myArr != nil) return [self.myArr count];
    else return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row + 1 == [self.myArr count]) {
        NSLog(@"last item display");
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"삭제" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"삭제");
    }];
    delAction.backgroundColor = [UIColor redColor];
    return @[delAction];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"myCell";
    
    CustomTableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = (CustomTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        Photo *p = [self.myArr objectAtIndex:indexPath.row];
        dispatch_async(self.queue, ^{
            NSData *img = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:p.url]];
            if (img == nil) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [cell.ivPhoto setImage:nil];
                });
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [cell.ivPhoto setImage:[UIImage imageWithData:img]];
                });
            }
        });
        [cell.tvTitle setText: p.title];
    }
    return cell;
}

@end
