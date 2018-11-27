//
//  HTMLParser.h
//  Super
/*
1. Open Your project in XCode and drag and drop all .h & .m Files into an appropriate folder
2. In the project settings add "/usr/include/libxml2" to the "header search paths" field
3. Ctrl Click the Frameworks group choose Add -> Existing Frameworks and from the list choose libxml2.dylib
Example Usage
=============
```objc
NSError *error = nil;
NSString *html =
@"<ul>"
"<li><input type='image' name='input1' value='string1value' /></li>"
"<li><input type='image' name='input2' value='string2value' /></li>"
"</ul>"
"<span class='spantext'><b>Hello World 1</b></span>"
"<span class='spantext'><b>Hello World 2</b></span>";
HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
if (error)return;
HTMLNode *bodyNode = [parser body];
NSArray *inputNodes = [bodyNode findChildTags:@"input"];
for (HTMLNode *inputNode in inputNodes) {
    if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) {
        NSLog(@"%@", [inputNode getAttributeNamed:@"value"]);
    }
}
NSArray *spanNodes = [bodyNode findChildTags:@"span"];
for (HTMLNode *spanNode in spanNodes) {
    if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"spantext"]) {
        NSLog(@"%@", [spanNode rawContents]); //Answer to second question
    }
}
*/
/*
-(void)htmlParserDemo{
    NSError *error = nil;
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[ ]{ \n\r\t}(#%-*+=_)"];
    NSString *url = [NSURL URLWithString:@"http://place.qyer.com/"];
    HTMLParser *parser = [[HTMLParser alloc] initWithContentsOfURL:url error:&error];
    if (error) { NSLog(@"Error: %@", error);return;}
    HTMLNode *bodyNode = [parser body];
    NSArray *listword  = [[[bodyNode findChildOfClass:@"pla_indallworld"]findChildOfClass:@"pla_indcountrylists"]findChildrenOfClass:@"pla_indcountrylist clearfix"];
    for (HTMLNode *word in listword) {
        HTMLNode *wwname = [[[word findChildOfClass:@"title clearfix"]findChildTag:@"em"]findChildTag:@"a"];
        NSString *url = [@"http:" stringByAppendingString:[wwname getAttributeNamed:@"href"]];
        NSString *name = [[[wwname contents]componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
        NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSString *noDigitName =[name stringByTrimmingCharactersInSet:nonDigits];
        DLog(@"\n%@  %@  %@",url,name,noDigitName);
    }
}
 */
/*=========javaScript.js
var leftContent = document.getElementById('content_left');
var results = leftContent.getElementsByTagName('h3');
var string = "";
for (var i = 0; i < results.length; i++) {
    var node = results[i];
    var nodeA = node.getElementsByTagName('a')[0];
    string += nodeA.innerHTML + "这是分割标识" +nodeA.href;
};
document.body.innerHTML = "";//清空原来的内容
document.body.innerHTML = string;//添加新内容
 ============================
 NSString *letfContent = [webView stringByEvaluatingJavaScriptFromString:javaScript];
 print(leftContent)
*/
#import <Foundation/Foundation.h>
#import <libxml/HTMLparser.h>
#import <libxml/HTMLtree.h>
typedef enum{
    HTMLHrefNode,
    HTMLTextNode,
    HTMLUnkownNode,
    HTMLCodeNode,
    HTMLSpanNode,
    HTMLPNode,
    HTMLLiNode,
    HTMLUlNode,
    HTMLImageNode,
    HTMLOlNode,
    HTMLStrongNode,
    HTMLPreNode,
    HTMLBlockQuoteNode,
} HTMLNodeType;
@interface HTMLNode : NSObject {
@public
    xmlNode * _node;
}
//Init with a lib xml node (shouldn't need to be called manually)
//Use [parser doc] to get the root Node
-(id)initWithXMLNode:(xmlNode*)xmlNode;
//Returns a single child of class
-(HTMLNode*)findChildOfClass:(NSString*)className;
//Returns all children of class
-(NSArray*)findChildrenOfClass:(NSString*)className;
//Finds a single child with a matching attribute
//set allowPartial to match partial matches
//e.g. <img src="http://www.google.com> [findChildWithAttribute:@"src" matchingName:"google.com" allowPartial:TRUE]
-(HTMLNode*)findChildWithAttribute:(NSString*)attribute matchingName:(NSString*)className allowPartial:(BOOL)partial;
//Finds all children with a matching attribute
-(NSArray*)findChildrenWithAttribute:(NSString*)attribute matchingName:(NSString*)className allowPartial:(BOOL)partial;
//Gets the attribute value matching tha name
-(NSString*)getAttributeNamed:(NSString*)name;
//Find childer with the specified tag name
-(NSArray*)findChildTags:(NSString*)tagName;
//Looks for a tag name e.g. "h3"
-(HTMLNode*)findChildTag:(NSString*)tagName;
//Returns the first child element
-(HTMLNode*)firstChild;
//Returns the plaintext contents of node
-(NSString*)contents;
//Returns the plaintext contents of this node + all children
-(NSString*)allContents;
//Returns the html contents of the node
-(NSString*)rawContents;
//Returns next sibling in tree
-(HTMLNode*)nextSibling;
//Returns previous sibling in tree
-(HTMLNode*)previousSibling;
//Returns the class name
-(NSString*)className;
//Returns the tag name
-(NSString*)tagName;
//Returns the parent
-(HTMLNode*)parent;
//Returns the first level of children
-(NSArray*)children;
//Returns the node type if know
-(HTMLNodeType)nodetype;
//C functions for minor performance increase in tight loops
NSString * getAttributeNamed(xmlNode * node, const char * nameStr);
void setAttributeNamed(xmlNode * node, const char * nameStr, const char * value);
@end
@interface HTMLParser : NSObject{
	@public
	htmlDocPtr _doc;
}
-(id)initWithContentsOfURL:(NSURL*)url error:(NSError**)error;
-(id)initWithData:(NSData*)data error:(NSError**)error;
-(id)initWithString:(NSString*)string error:(NSError**)error;
//Returns the doc tag
-(HTMLNode*)doc;
//Returns the body tag
-(HTMLNode*)body;
//Returns the html tag
-(HTMLNode*)html;
//Returns the head tag
- (HTMLNode*)head;
@end
