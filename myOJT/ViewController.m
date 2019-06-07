//
//  ViewController.m
//  myOJT
//
//  Created by jiemin on 05/06/2019.
//  Copyright © 2019 jiemin. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"
#import "DBInterface.h"
#import <WebKit/WebKit.h>
#import <Security/Security.h>

@interface ViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (strong, nonatomic) WKWebView *wkWebView;
@end

@implementation ViewController {
    /* 지역 변수 선언 */
    // 웹뷰의 랜더 속도 및 각종 설정등을 담당하는 클래스 입니다.
    WKWebViewConfiguration *wkConfig;
    
    // 자바스크립트에서 메시지를 받거나 자바스크립트를 실행하는데 필요한 클래스 입니다.
    WKUserContentController *jsctrl;
    
    WKPreferences *wkPref;
    
    DBInterface *myDB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    wkConfig = [[WKWebViewConfiguration alloc]init];
    jsctrl = [[WKUserContentController alloc]init];
    wkPref = [[WKPreferences alloc] init];
    
    myDB = [[DBInterface alloc] initWithDataBaseFileName:@"my_ojt" withVC: [[[[UIApplication sharedApplication] delegate] window] rootViewController]];
    
    wkPref.javaScriptEnabled = YES;
    wkConfig.preferences = wkPref;
    [jsctrl addScriptMessageHandler:self name:@"ioscall"];
    [wkConfig setUserContentController:jsctrl];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:wkConfig];
    
    [self.wkWebView setUIDelegate:self];
    [self.wkWebView setNavigationDelegate:self];
    
    self.wkWebView.backgroundColor = [UIColor clearColor];
    self.wkWebView.opaque = NO;
    self.wkWebView.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest: request];
    [self.view addSubview:self.wkWebView];
    
    NSLog(@"myTable total count %d", [myDB totalCount]);
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - delegate method

- (void) userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"request..");
    if ([message.name isEqualToString:@"ioscall"]) {
        id messageBody = message.body;
        if ([messageBody isKindOfClass:[NSDictionary class]]) {
            NSString *call = messageBody[@"call"];
            if ([call isEqualToString:@"clickAdd"]) {
                NSString *title = messageBody[@"title"];
                NSString *url = messageBody[@"url"];
                
                [myDB insertPhoto:title withUrl:url];
                
            } else if ([call isEqualToString:@"moveList"]) {
                [self performSegueWithIdentifier:@"moveToListVC" sender:self];
            }
            
        }
    }
}

- (void) webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *aCtrl = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [aCtrl addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        completionHandler();
    }]];
    
    [self presentViewController:aCtrl animated: NO completion: nil];
}

#pragma mark - navigation delegate
- (void) webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"1. didCommitNavigation");
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"2. didFinishNavigation");
}

- (void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"3. didFailNavigation");
}

#pragma mark - JS to iOS method

- (void) clickBtn {
    NSLog(@"click btn!!!");
}

@end
