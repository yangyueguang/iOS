//
//  CRKeychainItem.h
//  Copyright © 2017年 薛超. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CRKeychainItem : NSObject
@property () NSString *_Nonnull identifier;
@property () NSString *_Nullable account;
@property () NSString *_Nullable group;
@property () BOOL isAdded;

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
