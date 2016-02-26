### RemoteDataSync

#### RDSDataStore
Abstracted storage provider.
The only implemented storage provider is `RDSCoreDataStore`, that is a default option.

#### RDSNetworkConnector
Network connection provider.
The only and default option is `RDSAFNetworkConnector`.

#### RDSRequestConfigurator
Request configuration provider. It provide network call configurations based on type.

Configuration can be added, using

```objc
- (void) addConfiguration:(RDSRequestConfiguration*)configuration 
				  forType:(Class)type 
				  keyPath:(NSString*)keyPath 
				  sheme:(NSString*)scheme;
```
Array properties and relationships can have it's own configurations.

#### RDSMappingProvider
Data mapping provider provide a mapping setup based on type.
Mapping can be added using call 

```objc
- (void) addMapping:(RDSMapping*)mapping forType:(Class)type;
```

#### RDSObjectFactory

Can fill any object with json data.
mapping will be provided by `RDSMappingProvider`.
if json have sub data items, the subseqent objects will be created and filled up.

Factory caches objects, if the Mapping have primary key setup.

> Notes:  
> For now the cache works for all object with primary key. In some cases it may lead to RAM overuse, and should be limited to only highly accesed object types.

#### RDS Usage

##### Mapping Setup

```objc
    [[RDSManager defaultManager].mappingProvider 
    addMapping:[RDSMapping mappingWithDictionary:@{ @"id":@"serverID",
	                                                 @"asset_token":@"assetToken",
	                                                 @"captured_ts":@"capturedAt",
	                                                 @"created_ts":@"createdAt",
	                                                 @"modified_ts":@"modifiedAt",
	                                                 @"default_asset_type":@"defaultAssetType",
	                                                 @"uploader_id":@"uploaderID",
	                                                 @"media_type":@"mediaType",
	                                                 @"sort_index":@"sortIndex",
	                                                 @"media_sources":@"mediaSources"
	                                                 } primaryKey:@"serverID"] forType:Media.class];

```

##### Configuration Setup

```objc
    RDSRequestConfiguration* configuration = [RDSRequestConfiguration new];
    configuration.method = @"GET";
    configuration.pathBlock = ^NSString* (User* object) {
        NSString* serverID = object.serverID;
        return [NSString stringWithFormat:@"/user/%@/media",serverID];
    };
    configuration.baseKeyPath = @"media_list";
    [[RDSManager defaultManager].configurator addConfiguration:configuration forType:User.class keyPath:@"medias" sheme:RDSRequestSchemeFetch];
```

##### Fetch Object

for fetching `NSManagedObjects` use category on `NSManagedObject`:

```objc
	// Fetchin User
    [user fetchWithSuccess:nil failure:nil];
	// Fetchin User medias
    [user fetch:@"medias" withParameters:nil success:nil failure:nil];
```

##### Implementation in the code

* Use CoreData objects as a data layer.
* Reload table view on `-viewDidLoad` and on data fetch success.
