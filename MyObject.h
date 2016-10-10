//
//  MyObject.h
//  JSwithOC
//
//  Created by qingling_yang on 16/10/9.
//  Copyright © 2016年 yql. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class MyObject;

@protocol MyObjectExport <JSExport>

@property int x;

- (int)getX;
+ (MyObject *)getSqure:(MyObject *)obj;

@end

@interface MyObject : NSObject <MyObjectExport>

- (void)test;

@end
