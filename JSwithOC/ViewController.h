//
//  ViewController.h
//  JSwithOC
//
//  Created by qingling_yang on 16/10/9.
//  Copyright © 2016年 yql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSExport <JSExport>

JSExportAs(calculateForJS, - (void)handleFactorialCaluteWithNumber:(NSNumber *)number);

- (void)pushViewController:(NSString *)view title:(NSString *)title;

@end

@interface ViewController : UIViewController <UIWebViewDelegate, TestJSExport>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) JSContext *webContext;

@end

