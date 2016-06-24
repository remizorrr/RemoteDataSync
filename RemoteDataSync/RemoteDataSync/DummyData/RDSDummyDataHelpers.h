//
//  RDSDummyDataHelpers.h
//  Tella
//
//  Created by Anton Remizov on 6/22/16.
//  Copyright © 2016 PocketStoic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteDataSync.h"

void RDSFillupWithDummyItems(NSManagedObject* object, NSString* key, NSInteger count);

void RDSFillupAttributesWithDummyData(NSManagedObject* object);
