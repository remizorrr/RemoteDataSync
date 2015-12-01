//
//  RDSTypeConverter
//  RemoteDataSync
//
//  Created by Anton Remizov on 6/3/15.
//  Copyright (c) 2015 appcoming. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface RDSTypeConverter : NSObject

/*!
 @function convert:toType:
 @abstract Converts provided value to provided type.
 @param value
 Value can be of type: NSData, NSDate, NSNumber, NSString, NSDictionary.
 @param type
 Type may be NSString, NSNumber, NSDate, NSData, NSArray.
 */
+ (id) convert:(id)value toType:(NSString*)type;

/*!
 @function convert:toEntity:key:
 @abstract Converts provided value to an appropriate type of the entity property.
 @param value
 Value can be of type: NSData, NSDate, NSNumber, NSString, NSDictionary.
 @param entity
 entity description
 @param key
 key of the target property. the end type may be NSString, NSNumber, NSDate, NSData.
 */
+ (id) convert:(id)value toEntity:(NSEntityDescription*)entity key:(NSString*)key;

/*!
 @function setDateFormatter:
 @abstract Set default date formatter for string to NSDate conversion.
 @param inFormatter
 provided date formatter
*/
+ (void)setDateFormatter:(NSDateFormatter *)inFormatter;
@end
