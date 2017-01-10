//
//  NSObject+Types.m
//  Vacarious
//
//  Created by Anton Remizov on 8/27/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import "NSObject+Types.h"
#import <objc/runtime.h>

@implementation NSObject (Types)

- (NSString*) typeOfPropertyWithName:(NSString*)propertyName {
    return [self propertyDictionary][propertyName];
}

- (NSDictionary *)propertyDictionary
{
    u_int tmpCount;
    
    objc_property_t *tmpProperties = class_copyPropertyList([self class], &tmpCount);
    NSMutableDictionary *tmpPropertyDictionary = [NSMutableDictionary dictionaryWithCapacity:tmpCount];
    for (int i = 0; i < tmpCount ; i++)
    {
        objc_property_t property = tmpProperties[i];
        const char *tmpPropertyName = property_getName(tmpProperties[i]);
        
        const char * type = property_getAttributes(property);
        
        NSString * typeString = [self typeForProperty:property];
        
        
        [tmpPropertyDictionary setObject:typeString forKey:[NSString stringWithCString:tmpPropertyName encoding:NSUTF8StringEncoding]];
    }
    free(tmpProperties);
    
    return [NSDictionary dictionaryWithDictionary:tmpPropertyDictionary];
}

- (NSString*) typeForProperty:(objc_property_t)property {
    const char * name = property_getName(property);
    const char * type = property_getAttributes(property);
    
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    
    if (strcmp(rawPropertyType, @encode(float)) == 0) {
        return @"float";
    } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
        return @"NSInteger";
    } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
        //it's some sort of object
    } else if (strcmp(rawPropertyType, @encode(NSInteger)) == 0) {
        return @"NSInteger";
    } else {
        // According to Apples Documentation you can determine the corresponding encoding values
    }
    
    if ([typeAttribute hasPrefix:@"T@"]) {
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns @"NSDate" into NSDate
        return typeClassName;
        
        //        Class typeClass = NSClassFromString(typeClassName);
        //        if (typeClass != nil) {
        //            // Here is the corresponding class even for nil values
        //        }
    }
    return nil;
}
@end
