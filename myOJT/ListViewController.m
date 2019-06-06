//
//  ListViewController.m
//  myOJT
//
//  Created by FrontEnd on 07/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import "ListViewController.h"
#import <sqlite3.h>

@interface ListViewController ()

@end

@implementation ListViewController {
    sqlite3 *database;
    sqlite3_stmt *db_stmt;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self connectDB];
}

- (void) connectDB {
    NSString *dbPath = @"db_ojt.db";
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        NSLog(@"SUCCESS : sqlite3_open");
        sqlite3_close(database);
        database = nil;
    } else {
        NSLog(@"FAILURE : sqlite3_open");
        sqlite3_close(database);
        database = nil;
    }
}


@end
