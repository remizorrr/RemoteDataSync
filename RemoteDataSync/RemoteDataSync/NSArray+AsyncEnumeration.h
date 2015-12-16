//
//  NSArray+AsyncItteration.h
//  photokeeper
//
//  Created by Anton Remizov on 12/16/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AsyncEnumeration)

- (void)enumerateObjectsAsyncWithSyncChunkSize:(NSInteger)syncChunkSize usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

@end
