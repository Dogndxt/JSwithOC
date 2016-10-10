//
//  ViewController.m
//  JSwithOC
//
//  Created by qingling_yang on 16/10/9.
//  Copyright © 2016年 yql. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MyObject.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    NSLog(@"%@", [self.webView stringByEvaluatingJavaScriptFromString:@""]);
    self.webContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.webContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue){
        
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
    self.webContext[@"native"] = self;
    self.webContext[@"logg"] = ^(NSString *str)
    {
        NSLog(@"%@", str);
    };
    
    self.webContext[@"alert"] = ^(NSString *str){
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"msg from js" message:str delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert show];
    };
    __block typeof (self) weakSelf = self;
    self.webContext[@"addSubView"] = ^(NSString *viewname){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 500, 300, 100)];
        view.backgroundColor = [UIColor yellowColor];
        UISwitch *sw = [[UISwitch alloc] init];
        [view addSubview:sw];
        [weakSelf.view addSubview:view];
    };
    
    self.webContext[@"mutiParams"] = ^(NSString *a, NSString *b, NSString *c) {
        
        NSLog(@"%@ %@ %@", a, b, c);
    };
}

- (void)pushViewController:(NSString *)view title:(NSString *)title {

    NSLog(@"pushViewController");
}

- (void)handleFactorialCaluteWithNumber:(NSNumber *)number {

    NSLog(@"%@", number);
    NSNumber *result = [self calculateFactorialOfNumber:number];
    NSLog(@"%@", result);
    [self.webContext[@"showResult"] callWithArguments:@[result]];
}

- (NSNumber *)calculateFactorialOfNumber:(NSNumber *)number {

    NSInteger i = [number integerValue];
    if (i < 0) {
        return [NSNumber numberWithInteger:0];
    }
    if (i == 0) {
        return [NSNumber numberWithInteger:1];
    }
    NSInteger r = (i * [(NSNumber *)[self calculateFactorialOfNumber:[NSNumber numberWithInteger:(i - 1)]] integerValue]);
    return [NSNumber numberWithInteger:r];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // ******************************    网页的 JS   *********************** //
    NSString *webPath = [[NSBundle mainBundle] pathForResource:@"JSCallOC" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:webPath]];
    [self.webView loadRequest:request];
    self.webView.delegate = self;

    
    
    // ******************************    本地的 JS   *********************** //
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *jsCodeT = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"jsCodeT = %@", jsCodeT);
    JSContext *jscontent = [[JSContext alloc] init];
    JSValue *jscontentT = [jscontent evaluateScript:jsCodeT];
    JSValue *function2 = jscontent[@"factorial"];
    JSValue *result = [function2 callWithArguments:@[@2]];
    NSLog(@"jscontentT = %d ,result = %d", [jscontentT toInt32], [result toInt32]);
    
// Accessing Javascript Code in Objective - C
 // 1. Evaluating Javascript Code
    NSString *jsCode = @"1 + 2";
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:jsCode];
    context.exceptionHandler = ^(JSContext *con, JSValue *exeception) {
    
        NSLog(@"exeception %@", exeception);
        con.exception = exeception;
    };
    context[@"log"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"obj = %@", obj);
        }
    };
    JSValue *obj11 = [context evaluateScript:@"var jsObj = { number:7, name:'Ider'}; jsObj"];
    NSLog(@"%@, %@", obj11[@"name"], obj11[@"number"]);
    NSDictionary *dic = [obj11 toDictionary];
    NSLog(@"%@, %@", dic[@"name"], dic[@"number"]);
    
    // 字典与 js 的交互
    NSDictionary *dic1 = @{@"name":@"Ider", @"#":@(21)};
    context[@"dic"] = dic1;
    [context evaluateScript:@"log(dic.name, dic['#'])"];
    
    Person *person = [[Person alloc] init];
    context[@"p"] = person;
    person.firstName = @"Ider";
    person.lastName = @"Zheng";
    person.urls = @{@"site": @"http://www.iderzheng.com"};
    
    [context evaluateScript:@"log(p.fullName());"];
    [context evaluateScript:@"log(p.firstName)"];
    [context evaluateScript:@"log(p.urls.site)"];
    
    [context evaluateScript:@"log('site:', p.urls.site, 'blog:', p.urls.blog)"];
    
    [context evaluateScript:@"p.urls = {blog:'http://blog.iderzheng.com'}"];
    
    [context evaluateScript:@"log('-----AFTER CHANGE URLS------')"];
    [context evaluateScript:@"log('site:', p.urls.site, 'blog:', p.urls.blog)"];
    NSLog(@"%@", person.urls);
    
    
 // 2. Access Javascript Variables. Variables and functions are accessed from JSContext
    // To access varible from Javascript: context[@"x"]
    // To access function from javascript: context[@"myfun"]
    JSContext *context2 = [[JSContext alloc] init];
    NSString *jsCode2 = @" function showResult(resultNumber) { var x; x = 10; }";
    [context2 evaluateScript:jsCode2];
    JSValue *x = context2[@"x"];
    JSValue *function = context2[@"showResult"];
    NSLog(@"%@", function);
    NSLog(@"x = %d", [x toInt32]);
    
    // Access Javascript functions and execute them in Objective-C
    JSContext *context3 = [[JSContext alloc] init];
    NSString *jsCode3 = @"function sum(a, b) { return a+b; }";
    [context3 evaluateScript:jsCode3];
    
    JSValue *func = context3[@"sum"];
    NSArray *args = @[[NSNumber numberWithInt:10], [NSNumber numberWithInt:20]];
    JSValue *ret = [func callWithArguments:args];
    NSLog(@"10 + 20 = %d", [ret toInt32]);
    
    NSString *jsCode4 = @"function getRandom() {return parseInt(Math.floor((Math.random()*100) + 1))}";
    JSContext *context4 = [[JSContext alloc] init];
    [context4 evaluateScript:jsCode4];
    JSValue *func2 = context4[@"getRandom"];
    for (int i = 0; i < 5; i ++) {
        JSValue *ret2 = [func2 callWithArguments:nil];
        NSLog(@"Random Value = %d", [ret2 toInt32]);
    }
    
    
//二. Call Objective-C code from JavaScript
    // 1.Code blocks
    JSContext *context5 = [[JSContext alloc] init];
    context5[@"sum"] = ^(int arg1, int arg2) {
    
        return arg1 + arg2;
    };
    NSString *jsCode5 = @"sum(4, 5);";
    JSValue *sumVal = [context5 evaluateScript:jsCode5];
    NSLog(@"sum(4, 5) = %d", [sumVal toInt32]);
    
    JSContext *context6 = [[JSContext alloc] init];
    context6[@"getRandom"] = ^() {
    
        return rand() % 100;
    };
    NSString *jsCode6 = @"getRandom();";
    for (int i = 0; i < 5; i ++) {
        JSValue *sumVal2 = [context6 evaluateScript:jsCode6];
        NSLog(@"Random Number = %d", [sumVal2 toInt32]);
    }
    
    // 2.Using JSExport Protocol
    JSContext *context7 = [[JSContext alloc] init];
    NSString *jsCode7 = @"function sqrtOf(obj) {return MyObject.getSqure(obj); }";
    context7[@"MyObject"] = [MyObject class];
    [context7 evaluateScript:jsCode7];
    MyObject *obj = [MyObject new];
    obj.x = 10;

    JSValue *func3 = context7[@"sqrtOf"];
    JSValue *val3 = [func3 callWithArguments:@[obj]];
    MyObject *sqrtObj = [val3 toObject];
    
    NSLog(@"Value = %d, %d, %d", obj.x, sqrtObj.x, [val3 toInt32]); // Value = 10, 100, 0
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
