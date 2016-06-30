//
//  RDSDummyDataHelpers.m
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 PocketStoic. All rights reserved.
//

#import "RDSDummyDataHelpers.h"

void RDSFillupWithDummyItems(NSManagedObject* object, NSString* key, NSInteger count) {
    NSRelationshipDescription * description = [[object entity] relationshipsByName][key];
    NSEntityDescription * entity = nil;
    if (description) {
        entity = description.destinationEntity;
    }

    for (NSInteger i = 0; i < count; ++i) {
        [[RDSManager defaultManager].dataStore objectsOfType:entity.managedObjectClassName];
    }
}

NSString* RDSRandomString() {
    static NSArray *loremIpsum = nil;
    if (!loremIpsum) {
        loremIpsum =
        [@"Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua Ut enim ad minim veniam quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur Excepteur sint occaecat cupidatat non proident sunt in culpa qui officia deserunt mollit anim id est laborum" componentsSeparatedByString:@" "];
    }
    return [loremIpsum objectAtIndex:(float)rand()/(float)RAND_MAX * (loremIpsum.count - 1)];
}

void RDSFillupAttributesWithDummyData(NSManagedObject* object) {
    for(NSString* key in object.entity.attributesByName) {
        NSAttributeDescription* attribute = object.entity.attributesByName[key];
        switch (attribute.attributeType) {
            case NSStringAttributeType: {
                [object setValue:RDSRandomString() forKey:key];
                break;
            }
            default:
                break;
        }
    }
}
