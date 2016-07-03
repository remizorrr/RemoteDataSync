//
//  RDSDictionaryRequestConfigurator.m
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/2/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import "RDSDictionaryRequestConfigurator.h"

@interface RDSDictionaryRequestConfigurator ()
{
    NSMutableDictionary* configurationsByType;
}
@end

@implementation RDSDictionaryRequestConfigurator

- (instancetype)init
{
    self = [super init];
    if (self) {
        configurationsByType = [NSMutableDictionary dictionary];
    }
    return self;
}

- (RDSRequestConfiguration*) configurationForObject:(id)object keyPath:(NSString*)keyPath scheme:(NSString*)scheme {
    Class class = [object class];
    while (class != [NSObject class]) {
        NSString* typeKey = keyPath.length?[NSString stringWithFormat:@"%@-%@",NSStringFromClass(class),keyPath]:NSStringFromClass(class);
        NSDictionary* configurationsForObject = configurationsByType[typeKey];
        RDSRequestConfiguration* configuration = configurationsForObject[scheme];
        if (configuration) {
            return configuration;
        }
        class = [class superclass];
    }
    return nil;
}

- (void) addConfiguration:(RDSRequestConfiguration*)configuration forType:(Class)type keyPath:(NSString*)keyPath sheme:(NSString*)scheme {
    NSString* typeKey = keyPath.length?[NSString stringWithFormat:@"%@-%@",NSStringFromClass(type),keyPath]:NSStringFromClass(type);
    NSMutableDictionary* configurationsForObject = configurationsByType[typeKey];
    if(!configurationsForObject) {
        configurationsByType[typeKey] = [NSMutableDictionary dictionary];
        configurationsForObject = configurationsByType[typeKey];
    }
    configurationsForObject[scheme] = configuration;
}

@end
