//
// Created by Eduardo Scoz on 8/26/14.
// Copyright (c) 2014 ESCOZ inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,OrbitScope) {
    OrbitScopeApp,
    OrbitScopeInstance
};

@interface Orbit : NSObject

+ (void)resolveProperties:(id)object;
+ (NSObject *)resolve:(Class)class;
+ (NSObject *)resolveName:(NSString *)string;


- (void)register:(Class)pClass;
- (void)register:(Class)pClass scope:(enum OrbitScope)scope;
- (void)register:(Class)pClass name:(NSString *)name;
- (void)register:(Class)pClass instance:(id)instance;
- (void)register:(Class)pClass name:(NSString *)name instance:(id)instance;
- (void)register:(Class)pClass scope:(enum OrbitScope)scope instance:(id)instance;
- (NSObject *)resolve:(Class)pClass;

@end