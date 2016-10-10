//
//  Person.h
//  JSwithOC
//
//  Created by qingling_yang on 16/10/9.
//  Copyright © 2016年 yql. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol PersonProtocol <JSExport>

@property(nonatomic, retain) NSDictionary *urls;

- (NSString *)fullName;

@end

@interface Person : NSObject <PersonProtocol>

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end
