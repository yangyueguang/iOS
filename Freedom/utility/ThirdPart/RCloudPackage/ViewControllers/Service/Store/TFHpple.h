//
//  TFHpple.h
//  Hpple
#import <Foundation/Foundation.h>
#import "TFHppleElement.h"
@interface TFHpple : NSObject
- (id) initWithData:(NSData *)theData encoding:(NSString *)encoding isXML:(BOOL)isDataXML;
- (id) initWithData:(NSData *)theData isXML:(BOOL)isDataXML;
- (id) initWithXMLData:(NSData *)theData encoding:(NSString *)encoding;
- (id) initWithXMLData:(NSData *)theData;
- (id) initWithHTMLData:(NSData *)theData encoding:(NSString *)encoding;
- (id) initWithHTMLData:(NSData *)theData;
+ (TFHpple *) hppleWithData:(NSData *)theData encoding:(NSString *)encoding isXML:(BOOL)isDataXML;
+ (TFHpple *) hppleWithData:(NSData *)theData isXML:(BOOL)isDataXML;
+ (TFHpple *) hppleWithXMLData:(NSData *)theData encoding:(NSString *)encoding;
+ (TFHpple *) hppleWithXMLData:(NSData *)theData;
+ (TFHpple *) hppleWithHTMLData:(NSData *)theData encoding:(NSString *)encoding;
+ (TFHpple *) hppleWithHTMLData:(NSData *)theData;
- (NSArray *) searchWithXPathQuery:(NSString *)xPathOrCSS;
- (TFHppleElement *) peekAtSearchWithXPathQuery:(NSString *)xPathOrCSS;
@property (nonatomic, readonly) NSData * data;
@property (nonatomic, readonly) NSString * encoding;
@end
