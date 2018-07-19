//
//  NetCache.m
//  HuiXin
//
//  Created by 文俊 on 15/11/5.
//  Copyright © 2015年 文俊. All rights reserved.
//

#import "NSDictionary+BaseModel.h"
#import "NSString+BaseModel.h"
#import "NetCache.h"

@implementation NetCache


#pragma mark - memoryCache
+ (NSMutableDictionary*)memoryCache
{
    static NSMutableDictionary* cache;
    if (!cache) {
        cache = [NSMutableDictionary dictionary];
    }
    return cache;
}

+ (NetCache *)getMemoryCache:(NSString*)path parameter:(NSString*)parameter
{
    NetCache *model = [self memoryCache][[self getKey:path parameter:parameter]];
    return model;
}

+ (BOOL)setMemoryCache:(NetCache*)netCache
{
    NetCache *model = [self getMemoryCache:netCache.path parameter:netCache.parameter];
    if ([model.content isEqualToString:netCache.content] && [model.updateDate isEqualToDate:netCache.updateDate]) {
        return NO;
    }
    [self memoryCache][[self getKey:netCache.path parameter:netCache.parameter]] = netCache;
    return YES;
}

+ (NSString*)getKey:(NSString*)path parameter:(NSString*)parameter
{
    return [NSString stringWithFormat:@"%@,%@",path,parameter];
}

#pragma mark - NetCache
+ (LKDBHelper *)getUsingLKDBHelper {
	static LKDBHelper *helper;
	static dispatch_once_t onceToken;
	dispatch_once (&onceToken, ^{
		NSArray *paths =
			NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *dbName = @"XK_Cache";
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",dbName]];
        helper = [[LKDBHelper alloc] initWithDBPath:path];
//#if TARGET_IPHONE_SIMULATOR
//#elif TARGET_OS_IPHONE
//        [helper setKey:[[dbName stringByAppendingString:kDBPWD] md5String]];
//#endif
	});
	return helper;
}

+ (NSArray *)getPrimaryKeyUnionArray {
	return @[ @"path", @"parameter" ];
}

+ (void)queryWithPath:(NSString *)path
			parameter:(NSDictionary *)parameter
			   result:(void (^) (NetCache *))block {
	NSString *pathMD5 = [path bm_cacheMD5];
	NSString *parameterMD5 = [[parameter bm_jsonString] bm_cacheMD5];
    
    NetCache *cache = [self getMemoryCache:pathMD5 parameter:parameterMD5];
    if (cache) {
        block(cache);
        return;
    }
    
	NSString *where = [NSString stringWithFormat:@"path = '%@' and parameter = '%@'", pathMD5, parameterMD5];
	NSLog (@"queryWithPath%@", parameter);
	[[self getUsingLKDBHelper] search:[self class] where:where orderBy:nil offset:0 count:1 callback:^(NSMutableArray *array) {
        dispatch_async (GetMainQueue, ^{
            NetCache *cache;
            if (array.count > 0) {
                cache = [array objectAtIndex:0];
                [self setMemoryCache:cache];
            }
            block (cache);
        });
    }];
}

- (instancetype)initWithPath:(NSString *)path
				   parameter:(NSDictionary *)parameter
					 content:(id)content {
	self = [super init];
	if (self) {
		self.path = [path bm_cacheMD5];
		self.content = [[self class] contentHandler:content];
		self.parameter = [[parameter bm_jsonString] bm_cacheMD5];
        self.updateDate = [NSDate date];
	}
	return self;
}

+ (void)cacheWithPath:(NSString *)path parameter:(NSDictionary *)parameter content:(id)content {
	NetCache *cache = [[NetCache alloc] initWithPath:path parameter:parameter content:content];
    if ([self setMemoryCache:cache]) {
        [[self getUsingLKDBHelper] insertToDB:cache callback:^(BOOL result){
            
        }];
    }
}

+ (NSString *)contentHandler:(id)content {
	if ([content isKindOfClass:[NSString class]]) {
		return content;
	} else if ([content isKindOfClass:[NSDictionary class]]) {
		return [content bm_jsonString];
	}
	return @"";
}

@end
