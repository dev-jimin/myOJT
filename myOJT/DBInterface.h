//
//  DBInterface.h
//  myOJT
//
//  Created by jiemin on 07/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DBInterface : NSObject

// 초기화
- (id) initWithDataBaseFileName: (NSString *) databaseFilename withVC:(UIViewController *) vc;

// 게시글의 총 갯수
- (int) totalCount;

// 페이지로 게시글 불러오기
- (NSMutableArray *) searchWithPage:(int) page;

// 새 게시글 추가
- (void) insertPhoto:(NSString *) title withUrl:(NSString *) url;

@end
