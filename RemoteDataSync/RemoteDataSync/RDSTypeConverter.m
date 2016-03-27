//
//  RDSTypeConverter
//  RemoteDataSync
//
//  Created by Anton Remizov on 6/3/15.
//  Copyright (c) 2015 appcoming. All rights reserved.
//


#import "RDSTypeConverter.h"

static NSDateFormatter *_dateFormatter = nil;

@implementation RDSTypeConverter

+ (id) convert:(id)value toType:(NSString*)type
{
    if ([value isKindOfClass:NSClassFromString(type)] || !type.length)
        return value;
    
    // End is NSString
    if ([value isKindOfClass:[NSData class]] && [type isEqualToString:@"NSString"])
        return [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
    if ([value isKindOfClass:[NSNumber class]] && [type isEqualToString:@"NSString"])
		return [(NSNumber*)value stringValue];
    if ([value isKindOfClass:[NSDate class]] && [type isEqualToString:@"NSString"])
        return [(NSDate*)value description];
	if ([value isKindOfClass:[NSDate class]] && [type isEqualToString:@"NSString"])
        return [NSString stringWithFormat:@"%f",[(NSDate*)value timeIntervalSince1970]];
    if (value == [NSNull null] && [type isEqualToString:@"NSString"]) {
        return @"";
    }
	
    // End is NSNumber
    if ([type isEqualToString:@"NSNumber"]) {
        if ([value isKindOfClass:[NSString class]] && ([value isEqualToString:@"true"] || [value isEqualToString:@"YES"]))
            return @(1);
        else if ([value isKindOfClass:[NSString class]] && ([value isEqualToString:@"false"] || [value isEqualToString:@"NO"]))
            return @(0);
        else if ([value isKindOfClass:[NSString class]])
            return @([(NSString*)value floatValue]);
        else {
            return @0;
        }
    }
    
    // End is NSData
    if ([value isKindOfClass:[NSString class]] && [type isEqualToString:@"NSData"])
        return [(NSString*)value dataUsingEncoding:NSUTF8StringEncoding];

    // End is NSArray
    if ([value isKindOfClass:[NSDictionary class]] && [type isEqualToString:@"NSArray"])
        return @[value];

    // End is NSDate
    if ([value isKindOfClass:[NSNumber class]] && [type isEqualToString:@"NSDate"])
        return [NSDate dateWithTimeIntervalSince1970:[value integerValue]];

	if ([value isKindOfClass:[NSString class]] && [type isEqualToString:@"NSDate"])
	{
        NSDate* date = [_dateFormatter dateFromString:value];
        return date;
	}

    return nil;
    
}

+ (id) convert:(id)value toEntity:(NSEntityDescription*)entity key:(NSString*)key
{
    NSAttributeDescription* propertyDescription = entity.propertiesByName[key];
    return [RDSTypeConverter convert:value toType:propertyDescription.attributeValueClassName];
}

+ (void)setDateFormatter:(NSDateFormatter *)inFormatter
{
	_dateFormatter = inFormatter;
}

@end
