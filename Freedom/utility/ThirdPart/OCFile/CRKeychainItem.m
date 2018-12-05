//
//  CRKeychainItem.m
//  Copyright © 2017年 薛超. All rights reserved.
//

#import "CRKeychainItem.h"
@interface CRKeychainItem()
@property (copy, nonatomic) NSDictionary *itemBaseQuery;
@property (strong, nonatomic) NSDictionary *itemDictionary;
@end
@implementation CRKeychainItem
- (instancetype)initWithIdentifier:(NSString *)identifier Account:(NSString *)account AppGroup:(NSString *)group{
    if (self = [super init]) {
        _identifier = identifier;
        _account = account;
        _group = group;
        NSMutableDictionary *tempQuery = [NSMutableDictionary dictionary];
        [tempQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        [tempQuery setObject:identifier forKey:(id)kSecAttrService];
        if (account.length > 0) {
            [tempQuery setObject:account forKey:(id)kSecAttrAccount];
        }
        #if TARGET_IPHONE_SIMULATOR
        // iPhone 模拟器不支持keychain group
        #else
        if (group.length > 0) {
            [tempQuery setObject:group forKey:(id)kSecAttrAccessGroup];
        }
        #endif
        _itemBaseQuery = [tempQuery copy];
        [tempQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
        [tempQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
        NSDictionary *item = [NSDictionary dictionaryWithDictionary:[self queryItem:tempQuery]];
        if (item && [item isKindOfClass:[NSDictionary class]]) {
            _isAdded = YES;
            _itemDictionary = item;
        }
    }
    
    return self;
}
- (id)queryItem:(NSDictionary *)query{
    CFTypeRef ref = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)query, &ref);
    DLog(@"query keychain item status : %d",status);
    if ( status == noErr ) {
        return (__bridge id)ref;
    }
    return nil;
}

- (BOOL)setDataToKeychain:(NSData *)data{
    CFTypeRef ref = nil;
    OSStatus queryStatus = SecItemCopyMatching((CFDictionaryRef)self.itemBaseQuery, &ref);
    DLog(@"query keychain item status : %d",queryStatus);
    if (queryStatus == noErr) {
        NSMutableDictionary *update = [NSMutableDictionary dictionaryWithDictionary:self.itemDictionary];
        [update setObject:data forKey:(id)kSecValueData];
        return SecItemUpdate((CFDictionaryRef)self.itemBaseQuery, (CFDictionaryRef)update) == noErr;
    }else {
        _isAdded = YES;
        NSMutableDictionary *addDic = [NSMutableDictionary dictionaryWithDictionary:self.itemBaseQuery];
        [addDic setObject:data forKey:(id)kSecValueData];
        
        OSStatus isadded = SecItemAdd((CFDictionaryRef)addDic, NULL);
        if(isadded== noErr)return YES;
        return NO;
    }
    return NO;
}

- (NSData *)getData{
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:self.itemBaseQuery];
    [query setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [query setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    return [self queryItem:query];
}

- (BOOL)setStringToKeychain:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self setDataToKeychain:data];
}

- (NSString *)getString{
    NSData *data = [self getData];
    NSString *retString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return retString;
}
+ (NSArray<CRKeychainItem *> *)searchKeychainWithIdentifier:(NSString *)identifier Group:(NSString *)group{
    NSMutableDictionary *tempQuery = [NSMutableDictionary dictionary];
    [tempQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [tempQuery setObject:identifier forKey:(id)kSecAttrService];
    [tempQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    [tempQuery setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
#if TARGET_IPHONE_SIMULATOR
    // iPhone 模拟器不支持keychain group
#else
    if (group.length > 0) {
        [tempQuery setObject:group forKey:(id)kSecAttrAccessGroup];
    }
#endif
    CFTypeRef ref;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)tempQuery, &ref);
    NSLog(@"searchKeychainWithIdentifier:%d",status);
    if (status == noErr) {
        NSMutableArray *items = [NSMutableArray array];
        NSArray *keychainList = (__bridge NSArray *)(ref);
        for (NSDictionary *keychain in keychainList) {
            NSString *account = [keychain objectForKey:(id)kSecAttrAccount];
            CRKeychainItem *keychainItem = [[CRKeychainItem alloc] init];
            keychainItem.identifier = identifier;
            keychainItem.account = account;
            keychainItem.group = group;
            keychainItem.isAdded = YES;
            NSMutableDictionary *itemBaseQuery = [NSMutableDictionary dictionaryWithDictionary:tempQuery];
            [itemBaseQuery removeObjectForKey:(id)kSecReturnAttributes];
            [itemBaseQuery removeObjectForKey:(id)kSecMatchLimit];
            [itemBaseQuery setObject:account forKey:(id)kSecAttrAccount];
            keychainItem.itemBaseQuery = itemBaseQuery;
            keychainItem.itemDictionary = keychain;
            [items addObject:keychainItem];
        }
        return items;
    }
    return nil;
}

+ (BOOL)removeKeychainItem:(CRKeychainItem *)keychainItem{
    OSStatus status = SecItemDelete((CFDictionaryRef)keychainItem.itemBaseQuery);
    return status == noErr;
}

@end



