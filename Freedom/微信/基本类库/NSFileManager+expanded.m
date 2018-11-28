//
//  NSFileManager+expanded.m
//  MyFirstAPP
#import "NSFileManager+expanded.h"
#include <sys/xattr.h>
@implementation NSFileManager (expanded)
+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}
+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}
+ (NSURL *)documentsURL{
    return [self URLForDirectory:NSDocumentDirectory];
}
+ (NSString *)documentsPath{
    return [self pathForDirectory:NSDocumentDirectory];
}
+ (NSURL *)libraryURL{
    return [self URLForDirectory:NSLibraryDirectory];
}
+ (NSString *)libraryPath{
    return [self pathForDirectory:NSLibraryDirectory];
}
+ (NSURL *)cachesURL{
    return [self URLForDirectory:NSCachesDirectory];
}
+ (NSString *)cachesPath{
    return [self pathForDirectory:NSCachesDirectory];
}
+ (BOOL)addSkipBackupAttributeToFile:(NSString *)path{
    return [[NSURL.alloc initFileURLWithPath:path] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}
+ (double)availableDiskSpace{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.documentsPath error:nil];
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}
+ (NSString *)pathUserSettingImage:(NSString *)imageName{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Setting/Images/", [NSFileManager documentsPath],@"2829969299"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}
+ (NSString *)pathUserChatImage:(NSString*)imageName{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Chat/Images/", [NSFileManager documentsPath], @"2829969299"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}
+ (NSString *)pathUserChatBackgroundImage:(NSString *)imageName{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Chat/Background/", [NSFileManager documentsPath],@"2829969299"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}
+ (NSString *)pathUserAvatar:(NSString *)imageName{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Chat/Avatar/", [NSFileManager documentsPath],@"2829969299"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}
+ (NSString *)pathContactsAvatar:(NSString *)imageName{
    NSString *path = [NSString stringWithFormat:@"%@/Contacts/Avatar/", [NSFileManager documentsPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}
+ (NSString *)pathExpressionForGroupID:(NSString *)groupID{
    NSString *path = [NSString stringWithFormat:@"%@/Expression/%@/", [NSFileManager documentsPath], groupID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return path;
}
+ (NSString *)pathContactsData{
    NSString *path = [NSString stringWithFormat:@"%@/Contacts/", [NSFileManager documentsPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:@"Contacts.dat"];
}
+ (NSString *)pathScreenshotImage:(NSString *)imageName{
    NSString *path = [NSString stringWithFormat:@"%@/Screenshot/", [NSFileManager documentsPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}
+ (NSString *)pathDBCommon{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Setting/DB/", [NSFileManager documentsPath], @"2829969299"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }return [path stringByAppendingString:@"common.sqlite3"];
}
+ (NSString *)pathDBMessage{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Chat/DB/", [NSFileManager documentsPath], @"2829969299"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:@"message.sqlite3"];
}
+ (NSString *)cacheForFile:(NSString *)filename{
    return [[NSFileManager cachesPath] stringByAppendingString:filename];
}
@end
