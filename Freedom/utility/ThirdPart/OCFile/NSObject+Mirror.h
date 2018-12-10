
#import <Foundation/Foundation.h>
@interface NSObject (Mirror)
/// 获取对象的所有属性及属性类型
+ (NSDictionary*)propertiesDictionary;
/// 获取对象的所有方法
+ (NSArray*)getMothList;
// 根据字典生成对象
- (id)initWithDict:(NSDictionary *)aDict;
// 根据json生成对象
- (id)initWithJson:(NSString *)json;
// 根据字典数组生成对象数组
+ (NSArray *)objectArrayWithJsonArray:(NSArray *)jsonArray;
// 根据对象数组生成字典数组。
+ (NSArray *)jsonArrayWithObjectArray:(NSArray *)objectArray;
/// 为对象的属性赋值
- (void)setAttributesWithDictionary:(NSDictionary *)aDict;
// 将自定义的对象转换成字典对象。
- (NSDictionary *)toDictionary;
/// 子类重写，[Id:id] 字段替换用ID替换id
- (NSDictionary *)attributeMapDictionary;
/// 子类重写，[list:Student] 说明list数组中是Student对象
- (NSDictionary *)objectClassesInArray;
@end
