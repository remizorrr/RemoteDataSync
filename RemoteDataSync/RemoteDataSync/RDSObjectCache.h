//
//  RDSObjectCache.h
//  Vacarious
//
//  Created by Anton Remizov on 8/6/16.
//  Copyright © 2016 Appcoming. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RDSObjectCache <NSObject>

- (id) cachedObjectOfType:(NSString*)type withValue:(id<NSCopying>)value forKey:(NSString*)key;
- (void) cacheObject:(id)object forKey:(NSString*)key;
- (void) removeObjectOfType:(NSString*)type ForKey:(NSString*)key;
- (void) removeObject:(id)object cachedWithKey:(NSString*)key;
- (void) clearCache;
- (void) clearCacheForType:(NSString*)type;

@end
