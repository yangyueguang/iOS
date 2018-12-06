
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface NSObject (expanded)<NSCoding>
//获取对象的所有属性，不包括属性值
- (NSArray *)getAllProperties;
//获取对象的所有属性及属性类型
- (NSDictionary*)propertiesDictionary;
//获取类的属性的数据类型
- (const char*)findPropertyTypeWithName:(NSString*)name;
//获取对象的所有方法
- (NSArray*)getMothList;
+ (NSArray *)allProperties ;
///将NSArray或者NSDictionary转化为NSString
-(NSString *)JSONString;
-(double)computeAzimuthCLL:(CLLocationCoordinate2D)la1 :(CLLocationCoordinate2D)la2;
// 哪个子类调用，就返回哪个子类的对象数组，根据传入的包含对象字典的数组来为每个对象赋值
+ (NSArray *)objectArrayWithJsonArray:(NSArray *)jsonArray;
//哪个子类调用，就返回哪个子类的对象数组。根据传入的json字符串（数组型）为每个对象赋值。
+ (NSArray *)objectArrayWithJsonString:(NSString *)jsonString;
//  哪个类调用，就返回哪个类的对象数组对应的json数组。
+ (NSArray *)jsonArrayWithObjectArray:(NSArray *)objectArray;
// 哪个类调用，就返回哪个类对象数组对应的json字符串。
+ (NSString *)jsonStringWithObjectArray:(NSArray *)objectArray;
//初始化方法，将传入字典的key对应的value赋值给Model对象中相应地属性。
- (id)initWithExpandedDict:(NSDictionary *)aDict;
// 初始化方法，传入json字符串，根据json字符串中的键值关系为对象相应属性赋值
- (id)initWithJsonString:(NSString *)json;
/**
 *子类需要重写的方法，用以创建映射字典。
 *在该方法中将属性名称作为key值，与初始化时传入字典的key同名的字符串作为value。
 *若不重写，则返回nil,此时默认映射字典的key=value=初始化时传入字典的key同名的字符串。
 *@return 返回一个映射字典,或者nil(如果子类不重写)
 */
- (NSDictionary *)attributeMapDictionary;
/**
 *  子类需要重写的方法，用与字典中包含数组，并且数组中包含自定义对象时。
 *  如果不重写该方法，则创建的对象中数组类型的属性为空。
 *  自定义对象写自定义对象的类名
 *  @return 映射字典
 */
- (NSDictionary *)objectClassesInArray;
/*  默认情况下当遇到NSNull对象时会将其转换为@""空字符串
 *  如果某些属性不需要这样的转换，可以将属性名字写在该方法返回的数组中
 *  @return 不需要进行空值转换的属性名的数组
 */
- (NSArray *)attributesWithoutConvertNull;
//为实例变量赋以新的属性映射字典。 aDict a Dictionary 新的属性映射字典
- (void)setAttributesDictionary:(NSDictionary *)aDict;
// 将自定义的对象转换成字典对象，属性名为键，属性值为值。
- (NSDictionary *)dictionaryRepresentation;
// 将自定义对象转换成json字符串
- (NSString *)jsonStringRepresentation;
//获取对象的所有属性，不包括属性值
- (NSArray *)getAllProperties;
//获取对象的所有属性及属性类型
- (NSDictionary*)propertiesDictionary;
//获取类的属性的数据类型
- (const char*)findPropertyTypeWithName:(NSString*)name;
//获取对象的所有方法
- (NSArray*)getMothList;
@end
