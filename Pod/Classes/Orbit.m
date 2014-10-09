//
// Created by Eduardo Scoz on 8/26/14.
// Copyright (c) 2014 ESCOZ inc. All rights reserved.
//

#import <objc/runtime.h>
#import "Orbit.h"

Orbit *__DEFAULT_ORBIT;

@interface Orbit ()
@property(nonatomic, strong) NSMutableDictionary *scopeCache;
@property(nonatomic, strong) NSMutableDictionary *singletonCache;
@property(nonatomic, strong) NSMutableDictionary *classNameDirectory;
@end

@implementation Orbit
{

}

- (id)init
{
    self = [super init];
    if (self) {
        __DEFAULT_ORBIT = self;
        self.singletonCache = @{}.mutableCopy;
        self.scopeCache = @{}.mutableCopy;
        self.classNameDirectory = @{}.mutableCopy;
    }

    return self;
}

- (void)register:(Class)pClass
{
    [self register:pClass name:NSStringFromClass(pClass)];
}

- (void)register:(Class)pClass name:(NSString *)name
{
    [self register:pClass name:name scope:OrbitScopeInstance instance:nil];
}

- (void)register:(Class)pClass instance:(id)instance
{
    [self register:pClass name:NSStringFromClass(pClass) scope:OrbitScopeApp instance:instance];
}

- (void)register:(Class)pClass name:(NSString *)name instance:(id)instance
{
    [self register:pClass name:name scope:OrbitScopeApp instance:instance];
}

- (void)register:(Class)pClass scope:(enum OrbitScope)scope instance:(id)instance
{
    [self register:pClass name:NSStringFromClass(pClass) scope:scope instance:instance];
}

- (void)register:(Class)pClass scope:(enum OrbitScope)scope
{
    [self register:pClass name:NSStringFromClass(pClass) scope:scope instance:nil];
}

- (void)register:(Class)pClass name:(NSString *)name scope:(enum OrbitScope)scope
{
    [self register:pClass name:NSStringFromClass(pClass) scope:scope instance:nil];
}

- (void)register:(Class)pClass name:(NSString *)name scope:(enum OrbitScope)scope instance:(id)instance
{
    self.scopeCache[name] = @(scope);
    self.classNameDirectory[name] = pClass;

    if (instance!=nil && scope == OrbitScopeApp)
        self.singletonCache[name] = instance;
}

- (NSObject *)resolve:(Class)pClass
{
    OrbitScope scope = (OrbitScope) ((NSNumber *) self.scopeCache[NSStringFromClass(pClass)]).intValue;
    if (scope == OrbitScopeInstance)
        return [self instantiateObjectForClass:pClass];
    else if (scope == OrbitScopeApp)
        return [self getSingletonForClass:pClass];

    return nil;
}

- (NSObject *)resolveName:(NSString *)name
{
    Class className = self.classNameDirectory[name];
    if (className==nil)
        return nil;

    OrbitScope scope = (OrbitScope) ((NSNumber *) self.scopeCache[name]).intValue;
    if (scope == OrbitScopeInstance) {
        return [self instantiateObjectForClass:className];
    }
    else if (scope == OrbitScopeApp)
        return [self getSingletonForClass:className];

    return nil;
}

+ (NSObject *)resolve:(Class)class
{
    if (__DEFAULT_ORBIT==nil)
        return nil;
    return [__DEFAULT_ORBIT resolve:class];
}

+ (NSObject *)resolveName:(NSString *)string
{
    if (__DEFAULT_ORBIT==nil)
        return nil;
    return [__DEFAULT_ORBIT resolveName:string];
}

+ (void)resolveProperties:(NSObject *)object
{
    if (__DEFAULT_ORBIT==nil)
        return;
    [__DEFAULT_ORBIT resolveProperties:object];
}


#pragma mark - Dependency resolution

- (NSObject *)getSingletonForClass:(Class)pClass
{
    if (self.scopeCache[NSStringFromClass(pClass)]==nil)
        return nil;

    NSObject *obj = self.singletonCache[NSStringFromClass(pClass)];
    if (obj == nil)
        obj = [self instantiateObjectForClass:pClass];
    if (obj != nil)
        self.singletonCache[NSStringFromClass(pClass)] = obj;

    return obj;

}

- (NSObject *)instantiateObjectForClass:(Class)pClass
{
    NSObject *object = [[pClass alloc] init];

    [self resolveProperties:object];

    return object;
}

- (void)resolveProperties:(NSObject *)object
{

    Class currentClass = [object class];
    while (currentClass!=nil)
    {

        unsigned int numberOfProperties;
        objc_property_t *propertyArray = class_copyPropertyList(currentClass, &numberOfProperties);

        for (NSUInteger i = 0; i < numberOfProperties; i++) {
            objc_property_t property = propertyArray[i];
            NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
            NSString *typeAttribute = [Orbit getTypeStringForProperty:propertyName onObject:object.class];

            if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1 && [object respondsToSelector:NSSelectorFromString(propertyName)] && [object valueForKey:propertyName]==nil) {
                NSString *typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)];
                Class typeClass = NSClassFromString(typeClassName);
                if (typeClass != nil) {
                    NSObject *propertyValue = [self resolve:typeClass];
                    if (propertyValue !=nil)
                        [object setValue:propertyValue forKey:propertyName];
                }
            }
        }
        currentClass = class_getSuperclass(currentClass);
    }
}

+ (NSString *)getTypeStringForProperty:(NSString *)name onObject:(Class)object
{
    objc_property_t property = class_getProperty( object, [name UTF8String] );
    if ( property == NULL )
        return ( NULL );

    const char *attributes = property_getAttributes( property );
    if ( attributes == NULL )
        return ( NULL );

    static char buffer[256];
    const char * e = strchr(attributes, ',' );
    if ( e == NULL )
        return ( NULL );

    int len = (int)(e - attributes);
    memcpy( buffer, attributes, len );
    buffer[len] = '\0';

    return [NSString stringWithUTF8String:buffer];
}


@end