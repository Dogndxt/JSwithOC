//
//  MyObject.m
//  JSwithOC
//
//  Created by qingling_yang on 16/10/9.
//  Copyright © 2016年 yql. All rights reserved.
//

#import "MyObject.h"

@implementation MyObject
@synthesize x;

- (int)getX {

    return self.x;
}

+ (MyObject *)getSqure:(MyObject *)obj {

    NSLog(@"Calling getSqure");
    MyObject *newObject = [MyObject new];
    newObject.x = obj.x * obj.x;
    return newObject;
}

- (void)test {

}

@end
