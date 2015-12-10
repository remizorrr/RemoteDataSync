//
//  RDSObjectFactoryCache.h
//  PhotoKeeper
//
//  Created by Anton Remizov on 12/7/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDSObjectFactoryCache : NSObject

- (id) cachedObjectOfType:(Class)type withValue:(id<NSCopying>)value forKey:(NSString*)key;
- (void) cacheObject:(id)object forKey:(NSString*)key;
- (void) clearCache;
- (void) clearCacheForType:(Class)type;

@end
