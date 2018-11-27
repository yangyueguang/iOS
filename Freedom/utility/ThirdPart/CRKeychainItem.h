//
//  CRKeychainItem.h
//  iTour
//
//  Created by 蔡凌 on 2017/7/11.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Keychain操作类，对应一个keychain item
 如果是未添加过的keychain 那么当调用 setDataToKeychain 和 setStringToKeychain等方法时才会写入到keychain里面
 */
@interface CRKeychainItem : NSObject
@property (readonly) NSString *_Nonnull identifier;
@property (readonly) NSString *_Nullable account;
@property (readonly) NSString *_Nullable group;
@property (readonly) BOOL isAdded;

- (instancetype _Nullable )initWithIdentifier:(nonnull NSString *)identifier
                           Account:(nullable NSString *)account
                          AppGroup:(nullable NSString *)group;

- (BOOL)setDataToKeychain:(nonnull NSData *)data;
- (nullable NSData *)getData;

- (BOOL)setStringToKeychain:(nonnull NSString *)string;
- (nullable NSString *)getString;

+ (nullable NSArray<CRKeychainItem *> *)searchKeychainWithIdentifier:(nonnull NSString *)identifier Group:(nullable NSString *)group;
+ (BOOL)removeKeychainItem:(nonnull CRKeychainItem *)keychainItem;

@end
