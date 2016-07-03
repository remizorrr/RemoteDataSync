//
//  ObjectFactoryMapping.m
//  Synchora
//
//  Created by Anton Remizov on 3/26/15.
//  Copyright (c) 2015 synchora. All rights reserved.
//

#import "RDSMapping.h"
#import "RDSMapping+Protected.h"

@interface RDSMapping()
{
    NSString* _jsonUniqueKey;
}

@end
@implementation RDSMapping

- (instancetype)init
{
    self = [super init];
    if (self) {
        _jsonUniqueKey = nil;
    }
    return self;
}

+ (RDSMapping*) mappingWithDictionary:(NSDictionary*)dictionary
{
    return [self mappingWithDictionary:dictionary primaryKey:nil];
}

+ (RDSMapping*) mappingWithDictionary:(NSDictionary*)dictionary primaryKey:(NSString*)primaryKey
{
    RDSMapping* mapping = [RDSMapping new];
    mapping.primaryKey = primaryKey;
    NSMutableDictionary * items = [NSMutableDictionary dictionary];
    for (NSString* fromKeyPath in dictionary) {
        RDSMappingItem* item = [RDSMappingItem new];
        item.fromKeyPath = fromKeyPath;
        id value = dictionary[fromKeyPath];
        if ([value isKindOfClass:[NSNumber class]] && [value boolValue]==NO) {
            item.ignore = YES;
        } else if ([value isKindOfClass:[NSString class]]) {
            item.toKeyPath = value;
            item.ignoreType = YES;
        } else {
            item.toBlock = value;
            item.ignoreType = YES;
        }
        [items setObject:item forKey:fromKeyPath];
    }
    mapping.mappingItems = [items copy];
    return mapping;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.mappingItems];
}

- (NSString*) jsonUniqueKey {
    if (!_jsonUniqueKey) {
        _jsonUniqueKey = self.primaryKey;
        for (NSString* key in self.mappingItems) {
            RDSMappingItem* mapping = self.mappingItems[key];
            if ([mapping.toKeyPath isEqualToString:self.primaryKey]) {
                _jsonUniqueKey = key;
                break;
            }
        }
    }
    return _jsonUniqueKey;
}

@end
