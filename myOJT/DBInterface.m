//
//  DBInterface.m
//  myOJT
//
//  Created by jiemin on 07/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import "DBInterface.h"
#import <sqlite3.h>
#import <UIKit/UIKit.h>

@interface DBInterface()

@property (strong, nonatomic) UIViewController *vc;
@property (copy, nonatomic) NSString *giveFilename;
@property (copy, nonatomic) NSString *dbPath;
@property (strong, nonatomic) dispatch_queue_t d_queue;
@property (retain, nonatomic) UIActivityIndicatorView *progress;

@end

@implementation DBInterface
@synthesize dbPath = _dbPath;

// 초기화
- (id) initWithDataBaseFileName:(NSString *)databaseFilename withVC:(UIViewController *) vc{
    self = [super init];
    if (self) {
        self.giveFilename = databaseFilename;
        self.vc = vc;
        self.d_queue = dispatch_queue_create("com.ojt", nil);
        
        UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [progress setCenter:self.vc.view.center];
        [progress setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
    return self;
}

// Database File Path
- (NSString *) dbPath {
    if (!_dbPath) {
        NSFileManager *filemng = [NSFileManager defaultManager];
        NSURL *docPathUrl = [[filemng URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSString *dbFileName = [self.giveFilename stringByAppendingString:@".db"];
        
        _dbPath = [[docPathUrl URLByAppendingPathComponent:dbFileName] path];
        
        NSLog(@"LOAD DATABASE...");
        
        if (![filemng fileExistsAtPath:_dbPath]) {
            NSString *dbSource = [[NSBundle mainBundle] pathForResource:@"db_ojt" ofType:@"db"];
            [filemng copyItemAtPath:dbSource toPath:_dbPath error:nil];
            NSLog(@"CREATE DATABASE");
        }
    }
    return _dbPath;
}

- (void) insertPhoto:(NSString *)title withUrl:(NSString *)url {
    __block sqlite3 *db;
    __block int rc = 0;
    NSLog(@"Start insert record");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.vc.view addSubview:self.progress];
        self.progress.hidden = FALSE;
        [self.progress startAnimating];
        
        rc = sqlite3_open_v2([self.dbPath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE, NULL);
        if ( rc != SQLITE_OK ) {
            sqlite3_close(db);
            NSLog(@"Failed to open DB Connection");
        } else {
            NSString *query = [NSString stringWithFormat:@"INSERT INTO myTable (title, url) VALUES (\"%@\", \"%@\")", title, url];
            char *errMsg;
            rc = sqlite3_exec(db, [query UTF8String], NULL, NULL, &errMsg);
            
            UIAlertAction *btnDone = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
            
            if ( rc != SQLITE_OK ) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"알림" message:@"업로드 실패!" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:btnDone];
                
                [self.progress stopAnimating];
                self.progress.hidden = YES;
                
                [self.vc presentViewController: alert animated:YES completion: nil];
                
                NSLog(@"Failed to insert record : %s", errMsg);
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"알림" message:@"업로드 성공!" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:btnDone];
                
                [self.progress stopAnimating];
                self.progress.hidden = YES;
                
                [self.vc presentViewController: alert animated:YES completion: nil];
                
                NSLog(@"Success to insert record");
            }
            sqlite3_close(db);
        }
        NSLog(@"End isert record");
    });
    
}

- (int) totalCount {
    sqlite3 *db;
    const char *dbFile = [self.dbPath UTF8String];
    int result = 0;
    
    if (sqlite3_open(dbFile, &db) == SQLITE_OK) {
        NSString *query = @"SELECT COUNT(idx) FROM myTable;";
        const char *sql = [[NSString stringWithFormat:query, nil] UTF8String];
        
        sqlite3_stmt *stmt;
        if (sqlite3_prepare(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                result = [@(sqlite3_column_int(stmt, 0)) intValue];
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    return result;
}

- (NSArray *) searchWithPage:(int) page {
    NSMutableArray *result = [NSMutableArray array];
    __block sqlite3 *db;
    const char *dbFile = [self.dbPath UTF8String];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.vc.view addSubview:self.progress];
        self.progress.hidden = FALSE;
        [self.progress startAnimating];
        
        if (sqlite3_open(dbFile, &db) == SQLITE_OK) {
            NSString *query = @"SELECT title, url FROM myTable ORDER BY idx DESC LIMIT %ld, 15;";
            const char *sql = [[NSString stringWithFormat:query, (page - 1) * 15] UTF8String];
            
            sqlite3_stmt *stmt;
            if (sqlite3_prepare(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
                while (sqlite3_step(stmt) == SQLITE_ROW) {
                    NSString *title = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 0)];
                    NSString *url = [NSString stringWithUTF8String:sqlite3_column_text(stmt, 1)];
                    
                    NSDictionary *row = @{@"title":title, @"url":url};
                    [result addObject:row];
                }
                sqlite3_finalize(stmt);
            }
            sqlite3_close(db);
        }
        
        [self.progress stopAnimating];
        self.progress.hidden = YES;
    });
    
    if ([result count] == 0) return nil;
    else return result;
}

@end
