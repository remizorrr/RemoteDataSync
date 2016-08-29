//
//  NSObject+Types.h
//  Vacarious
//
//  Created by Anton Remizov on 8/27/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Types)

- (NSString*) typeOfPropertyWithName:(NSString*)propertyName;
- (NSDictionary *)propertyDictionary;

@end
