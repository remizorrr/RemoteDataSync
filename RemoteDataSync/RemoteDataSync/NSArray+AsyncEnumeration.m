//
//  NSArray+AsyncItteration.m
//  photokeeper
//
//  Created by Anton Remizov on 12/16/15.
//  Copyright © 2015 PhotoKeeper. All rights reserved.
//

#import "NSArray+AsyncEnumeration.h"

@implementation NSArray (AsyncEnumeration)

- (void)enumerateObjectsAsyncWithSyncChunkSize:(NSInteger)syncChunkSize usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    __block NSInteger index = 0;
    NSInteger count = self.count;
    void(^itteration)() = ^(){
        for (NSInteger i = index; i < count && i < index + syncChunkSize; ++i) {
            BOOL stop = NO;
            block(self[i],i,&stop);
            if (stop) {
                return;
            }
        }
        index += syncChunkSize;
        if(index < count) {
            dispatch_async(dispatch_get_main_queue(), itteration);
        }
        
    };

}

@end
