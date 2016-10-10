//
//  Person.m
//  JSwithOC
//
//  Created by qingling_yang on 16/10/9.
//  Copyright © 2016年 yql. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize firstName, lastName, urls;

- (NSString *)fullName {

    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
