#import "NSObject+expanded.h"
#import <objc/runtime.h>
#import <objc/message.h>
#include <string.h>
@implementation NSObject (expanded)
///将NSArray或者NSDictionary转化为NSString
-(NSString *)JSONString{
    NSError* error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:self
                                              options:kNilOptions
                                                error:&error];
    if (error != nil){
        NSLog(@"JSON Parsing Error: %@", error);
        return nil ;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

// 计算方位角,正北向为0度，以顺时针方向递增
-(double)computeAzimuthCLL:(CLLocationCoordinate2D)la1 :(CLLocationCoordinate2D)la2{
    double lat1 = la1.latitude, lon1 = la1.longitude, lat2 = la2.latitude, lon2 = la2.longitude;
    double result = 0.0;
    int ilat1 = (int) (0.50 + lat1 * 360000.0);
    int ilat2 = (int) (0.50 + lat2 * 360000.0);
    int ilon1 = (int) (0.50 + lon1 * 360000.0);
    int ilon2 = (int) (0.50 + lon2 * 360000.0);
    lat1 = lat1*M_PI/180;
    lon1 = lon1*M_PI/180;
    lat2 = lat2*M_PI/180;
    lon2 = lon2*M_PI/180;
    if ((ilat1 == ilat2) && (ilon1 == ilon2)) {
        return result;
    } else if (ilon1 == ilon2) {
        if (ilat1 > ilat2)result = 180.0;
    } else {
        double c = acos(sin(lat2) * sin(lat1) + cos(lat2) * cos(lat1) * cos((lon2 - lon1)));
        double A = asin(cos(lat2) * sin((lon2 - lon1))/ sin(c));
        result = A*180/M_PI;
        if ((ilat2 > ilat1) && (ilon2 > ilon1)) {
        } else if ((ilat2 < ilat1) && (ilon2 < ilon1)) {
            result = 180.0 - result;
        } else if ((ilat2 < ilat1) && (ilon2 > ilon1)) {
            result = 180.0 - result;
        } else if ((ilat2 > ilat1) && (ilon2 < ilon1)) {
            result += 360.0;
        }
    }
    return result;
}
#pragma mark - Class Methods
+ (NSArray *)objectArrayWithJsonArray:(NSArray *)jsonArray {
    NSMutableArray *objects = [NSMutableArray array];
    for (NSDictionary *dict in jsonArray) {
        id instance = [[self alloc] initWithExpandedDict:dict];
        [objects addObject:instance];
    }
    return objects;
}
+ (NSArray *)objectArrayWithJsonString:(NSString *)jsonString {
    NSError *error = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    return [self objectArrayWithJsonArray:jsonArray];
}
+ (NSArray *)jsonArrayWithObjectArray:(NSArray *)objectArray {
    NSMutableArray *jsonObjects = [NSMutableArray array];
    for (NSObject *model in objectArray) {
        NSDictionary *jsonDict = [model dictionaryRepresentation];
        [jsonObjects addObject:jsonDict];
    }
    return jsonObjects;
}
+ (NSString *)jsonStringWithObjectArray:(NSArray *)objectArray {
    NSArray *jsonObjects = [self jsonArrayWithObjectArray:objectArray];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObjects options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"Error occured when create json string with object array: %@, error: %@", objectArray, error.localizedDescription);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
#pragma mark - Initialize
- (id)initWithExpandedDict:(NSDictionary *)aDict{
    self = [self init];
    if (self) {
        //建立映射关系
        [self setAttributesDictionary:aDict];
    }
    return self;
}
- (id)initWithJsonString:(NSString *)json {
    self = [self init];
    if (self) {
        //解析json字符串
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            NSLog(@"Error occured when init object with json string: %@, error: %@", json, error.localizedDescription);
            return nil;
        }
        self = [self initWithExpandedDict:dict];
    }
    return self;
}
#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        unsigned int count = 0;
        //get a list of all properties of this class
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            SEL setter = [self setterForPropertyName:key];
            if ([self respondsToSelector:setter]) {
                NSMethodSignature* signature = [self methodSignatureForSelector:setter];
                const char *returnType = [signature getArgumentTypeAtIndex:2];
                if (strcmp(returnType, @encode(id)) == 0) {
                    [self performSelectorOnMainThread:setter withObject:[aDecoder decodeObjectForKey:key] waitUntilDone:[NSThread isMainThread]];
                } else {
                    NSString *type = [self propertyTypeForProperty:properties[i]];
                    //调用method，传递基本类型的方法：使用NSInvocation。
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    invocation.selector = setter;
                    invocation.target = self;
                    if ([type isEqualToString:@"d"]) {
                        double basicData = [aDecoder decodeDoubleForKey:key];
                        [invocation setArgument:&basicData atIndex:2];
                    } else if ([type isEqualToString:@"i"]) {
                        int basicData = [aDecoder decodeIntForKey:key];
                        [invocation setArgument:&basicData atIndex:2];
                    } else if ([type isEqualToString:@"q"]) {
                        long long basicData = [aDecoder decodeIntegerForKey:key];
                        [invocation setArgument:&basicData atIndex:2];
                    } else if ([type isEqualToString:@"f"]) {
                        float basicData = [aDecoder decodeFloatForKey:key];
                        [invocation setArgument:&basicData atIndex:2];
                    } else if ([type isEqualToString:@"c"] || [type isEqual:@"B"]) {
                        BOOL basicData = [aDecoder decodeBoolForKey:key];
                        [invocation setArgument:&basicData atIndex:2];
                    } else if ([type isEqualToString:@"l"]) {
                        long basicData = [aDecoder decodeIntegerForKey:key];
                        [invocation setArgument:&basicData atIndex:2];
                    }
                    [invocation invoke];
                }
            }
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    //get a list of all properties of this class
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        SEL getter = [self getterForPropertyName:key];
        if ([self respondsToSelector:getter]) {
            NSMethodSignature* methodSig = [self methodSignatureForSelector:getter];
            const char *returnType = [methodSig methodReturnType];
            if (strcmp(returnType, @encode(id)) == 0) {
                id returnValue = [self performSelector:getter];
                [aCoder encodeObject:returnValue forKey:key];
            } else {
                NSString *type = [self propertyTypeForProperty:properties[i]];
                //调用method，传递基本类型的方法：使用NSInvocation。
                NSMethodSignature *signature = [self methodSignatureForSelector:getter];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                invocation.selector = getter;
                invocation.target = self;
                [invocation invoke];
                if ([type isEqualToString:@"d"]) {
                    double basicData = 0;
                    [invocation getReturnValue:&basicData];
                    [aCoder encodeDouble:basicData forKey:key];
                } else if ([type isEqualToString:@"i"]) {
                    int basicData = 0;
                    [invocation getReturnValue:&basicData];
                    [aCoder encodeInt:basicData forKey:key];
                } else if ([type isEqualToString:@"q"]) {
                    long basicData = 0;
                    [invocation getReturnValue:&basicData];
                    [aCoder encodeInteger:basicData forKey:key];
                } else if ([type isEqualToString:@"f"]) {
                    float basicData = 0;
                    [invocation getReturnValue:&basicData];
                    [aCoder encodeFloat:basicData forKey:key];
                } else if ([type isEqualToString:@"c"] || [type isEqual:@"B"]) {
                    BOOL basicData = NO;
                    [invocation getReturnValue:&basicData];
                    [aCoder encodeBool:basicData forKey:key];
                } else if ([type isEqualToString:@"l"]) {
                    long basicData = 0;
                    [invocation getReturnValue:&basicData];
                    [aCoder encodeInteger:basicData forKey:key];
                }
            }
        }
    }
}
#pragma mark - Mapping
- (NSDictionary *)attributeMapDictionary{
    //子类需要重写的方法
    //NSAssert(NO, "You should override this method in Your Custom Class");
    return nil;
}
- (NSDictionary *)objectClassesInArray {
    return nil;
}
- (NSArray *)attributesWithoutConvertNull {
    return nil;
}
- (void)setAttributesDictionary:(NSDictionary *)aDict{
    //获得完整的映射字典
    NSDictionary *mapDictionary = [self keyValuesForMapDictionary:aDict];
    //遍历映射字典
    NSEnumerator *keyEnumerator = [mapDictionary keyEnumerator];
    id attributeName = nil;
    while ((attributeName = [keyEnumerator nextObject])) {
        //获得属性的setter
        SEL setter = [self setterForPropertyName:attributeName];
        if ([self respondsToSelector:setter]) {
            //获得映射字典的值，也就是传入字典的键
            NSString *aDictKey = [mapDictionary objectForKey:attributeName];
            id aDictValue = [self parsePropertyValueWithValueDictionary:aDict mappedKey:aDictKey];
            //获取该属性的类型名，便于接下来分别处理。
            objc_property_t property = class_getProperty([self class], [attributeName cStringUsingEncoding:NSUTF8StringEncoding]);
            if (property == NULL) {
                continue;
            }
            NSString *type = [self propertyTypeForProperty:property];
            if ([aDictValue isKindOfClass:[NSDictionary class]]) {
                //如果传入的字典中还包括自定义对象，则找出它的类为它赋值。
                if ([type isEqualToString:@"NSDictionary"] == NO && [type isEqualToString:@"NSMutableDictionary"] == NO) {
                    //如果该类型不是字典类型，说明是自定义对象。
                    Class newClass = objc_getClass([type cStringUsingEncoding:NSUTF8StringEncoding]);
                    //如果是该类的子类，说明能响应initWithDict:方法并且能建立映射字典。
                    if ([newClass isSubclassOfClass:[NSObject class]]){
                        id instance = [[newClass alloc] initWithExpandedDict:aDictValue];
                        [self performSelectorOnMainThread:setter withObject:instance waitUntilDone:[NSThread isMainThread]];
                    }
                } else {
                    //要赋值的属性也是字典类型，则直接赋值。
                    [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
                }
            } else if ([aDictValue isKindOfClass:[NSArray class]]) {
                //如果传入的字典中有数组
                NSMutableArray *valueArray = [NSMutableArray array];
                NSDictionary *objectClasses = [self objectClassesInArray];
                if (objectClasses == nil) {
                    continue;
                }
                NSString *classString = [objectClasses objectForKey:aDictKey];
                if (classString) {
                    for (id content in aDictValue) {
                        Class classInArray = NSClassFromString(classString);
                        //如果是该类的子类，说明能响应initWithDict:方法并且能建立映射字典。
                        if ([classInArray isSubclassOfClass:[NSObject class]]) {
                            id instance = [[classInArray alloc] initWithExpandedDict:content];
                            [valueArray addObject:instance];
                        } else {
                            //如果不是数组中包含的不是自定义对象（例如，NSString或NSNumber等），并且符合子类给出的映射字典中的映射规则，那么直接添加到最终数组中
                            //这种做法可以解决一个数组中包含不同类型对象的情况（虽然基本上用不到）
                            if ([content isKindOfClass:classInArray]) {
                                [valueArray addObject:content];
                            }
                        }
                    }
                } else {
                    valueArray = nil;
                }
                //为数组属性赋值。
                [self performSelectorOnMainThread:setter withObject:valueArray waitUntilDone:[NSThread isMainThread]];
            } else if ([aDictValue isKindOfClass:[NSNumber class]]) {
                //数字类型需要分类讨论
                if ([type isEqualToString:@"NSNumber"]) {
                    //如果属性也是NSNumber类型，则直接赋值。
                    [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
                } else {
                    //如果属性不是NSNumber，说明是基本类型。
                    //调用method，传递基本类型的方法：使用NSInvocation。
                    NSMethodSignature *signature = [self methodSignatureForSelector:setter];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    invocation.selector = setter;
                    invocation.target = self;
                    if ([type isEqualToString:@"d"]) {
                        double basicData = [aDictValue doubleValue];
                        [invocation setArgument:&basicData atIndex:2];
                    } else if ([type isEqualToString:@"i"]) {
                        int basicData = [aDictValue intValue];
                        [invocation setArgument:&basicData atIndex:2];
                    } else if ([type isEqualToString:@"q"]) {
                        long long basicData = [aDictValue longValue];
                        [invocation setArgument:&basicData atIndex:2];
                    } else if ([type isEqualToString:@"f"]) {
                        float basicData = [aDictValue floatValue];
                        [invocation setArgument:&basicData atIndex:2];
                    } else if ([type isEqualToString:@"c"] || [type isEqual:@"B"]) {
                        BOOL basicData = [aDictValue boolValue];
                        [invocation setArgument:&basicData atIndex:2];
                    } else if ([type isEqualToString:@"l"]) {
                        long basicData = [aDictValue longValue];
                        [invocation setArgument:&basicData atIndex:2];
                    }
                    //第0和第1个参数分别是self和_cmd，由NSInvocation自动设置。
                    //                    [invocation setArgument:&basicData atIndex:2];
                    [invocation invoke];
                }
            } else if ([aDictValue isKindOfClass:[NSNull class]]) {
                //如果该属性是空值，那么根据子类需要选择是否将其转换为空串
                NSArray *noConvertArray = [self attributesWithoutConvertNull];
                //如果不包含在子类返回的数组中
                if (![noConvertArray containsObject:attributeName]) {
                    //根据字符串、数字、字典、数组来分别赋值
                    [self handleNullValueForSetter:setter withType:type];
                } else {
                    //如果包含在该数组中，那么直接按字典值（NSNull）为其赋值
                    [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
                }
            } else {
                //如果该值是其他普通的类型，则为属性赋值
                [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
            }
        }
    }
}
- (NSDictionary *)dictionaryRepresentation {
    unsigned int count = 0;
    //get a list of all properties of this class
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    NSDictionary *keyValueMap = [self attributeMapDictionary];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        //        NSLog(@"key = %@, value = %@, value class = %@, changed Key = %@", key, value, NSStringFromClass([value class]), [keyValueMap objectForKey:key]);
        //如果用户在映射字典中提供了映射关系，则修改最终生成字典中相应的键。
        if ([keyValueMap.allKeys containsObject:key]) {
            key = [keyValueMap objectForKey:key];
        }
        //only add it to dictionary if it is not nil
        if (key && value) {
            if ([value isKindOfClass:[NSObject class]]) {
                //如果model里有其他自定义模型，并且是继承自该类，则递归将其转换为字典。
                [dict setObject:[value dictionaryRepresentation] forKey:key];
            } else {
                //普通类型的直接变成字典的值。
                [dict setObject:value forKey:key];
            }
        } else if (key && value == nil) {
            //如果当前对象该值为空，设为nil。在字典中直接加nil会抛异常，需要加NSNull对象。
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    free(properties);
    return dict;
}
- (NSString *)jsonStringRepresentation {
    NSMutableDictionary *representation = [[self dictionaryRepresentation] mutableCopy];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:representation options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"Error occured when create json string representation, error: %@", error.localizedDescription);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
#pragma mark - Private Methods
- (NSDictionary *)keyValuesForMapDictionary:(NSDictionary *)aDict {
    //获得映射字典
    NSMutableDictionary *mapDictionary = [[self attributeMapDictionary] mutableCopy];
    //如果子类没有重写attributeMapDictionary方法，则使用默认映射字典
    if (mapDictionary == nil) {
        mapDictionary = [NSMutableDictionary dictionaryWithCapacity:aDict.count];
    }
    //对传入字典遍历，为映射字典赋值
    for (NSString *key in aDict) {
        //如果当期的映射字典中含有该键值，说明子类已经为该属性建立了映射关系了。
        if ([mapDictionary.allValues containsObject:key]) {
            continue;
        }
        //将子类没有建立映射的键映射为自身
        [mapDictionary setObject:key forKey:key];
    }
    return mapDictionary;
}
- (SEL)setterForPropertyName:(NSString *)propertyName {
    NSString *firstAlpha = [[propertyName substringToIndex:1] uppercaseString];
    NSString *otherAlpha = [propertyName substringFromIndex:1];
    NSString *setterMethodName = [NSString stringWithFormat:@"set%@%@:", firstAlpha, otherAlpha];
    return NSSelectorFromString(setterMethodName);
}
- (SEL)getterForPropertyName:(NSString *)propertyName {
    return NSSelectorFromString(propertyName);
}
- (id)parsePropertyValueWithValueDictionary:(NSDictionary *)aDict mappedKey:(NSString *)aDictKey {
    id aDictValue = nil;
    //    if ([aDictKey containsString:@"."]) {
    if ([aDictKey rangeOfString:@"."].length != 0) {
        //如果映射字典的值中有.，说明字典中含有字典。
        NSDictionary *childDictionary = [aDict copy];
        NSString *parentKey = [aDictKey substringToIndex:[aDictKey rangeOfString:@"."].location];
        NSString *childKey = [aDictKey substringFromIndex:[aDictKey rangeOfString:@"."].location + 1];
        
        while ([childKey containsString:@"."]) {
            aDictValue = childDictionary[parentKey];
            childDictionary = aDictValue;
            parentKey = [childKey substringToIndex:[childKey rangeOfString:@"."].location];
            childKey = [childKey substringFromIndex:[childKey rangeOfString:@"."].location + 1];
        }
        aDictValue = childDictionary[parentKey][childKey];
    } else {
        //获得传入字典的键对应的值，也就是要赋给属性的值
        aDictValue = [aDict objectForKey:aDictKey];
    }
    return aDictValue;
}
- (NSString *)propertyTypeForProperty:(objc_property_t)property {
    const char *attrs = property_getAttributes(property);
    //ie. T@"NSString",....... or Ti,...
    if (attrs == NULL) {
        return nil;
    }
    NSString *type = [NSString stringWithCString:attrs encoding:NSUTF8StringEncoding];
    type = [type componentsSeparatedByString:@","].firstObject;  //ie.T@"NSString" or Ti
    //如果包含@说明是对象类型(id 为@)
    //    if ([type containsString:@"@"]) {
    if ([type rangeOfString:@"@"].length != 0) {
        type = [self propertyTypeForObject:type];
    } else {
        type = [self propertyTypeForBasicDataType:type];
    }
    return type;
}
- (NSString *)propertyTypeForObject:(NSString *)type {
    type = [type substringFromIndex:3]; //ie. NSString"
    type = [type substringToIndex:[type rangeOfString:@"\""].location]; //ie. NSString
    return type;
}
- (NSString *)propertyTypeForBasicDataType:(NSString *)type {
    //不考虑结构体、共用体、枚举以及函数指针、块等（实际开发中基本不可能出现）
    //每个基本型的类型代号都为一个字符（long long为Tq）
    type = [type substringFromIndex:1];   //ie. i
    return type;
}
//处理默认情况下的NSNull对象
- (void)handleNullValueForSetter:(SEL)setter withType:(NSString *)type{
    if ([type isEqualToString:@"NSString"]) {
        [self performSelectorOnMainThread:setter withObject:@"" waitUntilDone:[NSThread isMainThread]];
    } else if ([type isEqualToString:@"NSArray"]) {
        [self performSelectorOnMainThread:setter withObject:[NSArray array] waitUntilDone:[NSThread isMainThread]];
    } else if ([type isEqualToString:@"NSNumber"]) {
        [self performSelectorOnMainThread:setter withObject:@0 waitUntilDone:[NSThread isMainThread]];
    } else if ([type isEqualToString:@"NSDictionary"]) {
        [self performSelectorOnMainThread:setter withObject:[NSDictionary dictionary] waitUntilDone:[NSThread isMainThread]];
    } else {
        //其他类型
        [self performSelectorOnMainThread:setter withObject:[NSNull null] waitUntilDone:[NSThread isMainThread]];
    }
}
//获取对象的所有属性，不包括属性值
- (NSArray *)getAllProperties{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++){
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}
//获取对象的所有属性及属性类型
- (NSDictionary*)propertiesDictionary{
    if (self == NULL){return nil;}
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        const char *realType = getPropertyType(property);
        NSLog(@"属性名：%s 属性类型：%s", propName, realType);
        [results setObject:[NSString stringWithUTF8String:realType] forKey:[NSString stringWithUTF8String:propName]];
    }
    free(properties);
    return [NSDictionary dictionaryWithDictionary:results];
}
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);//获取属性描述字符串
    char *type;
    if (attributes[1] == '@') {//对象数据类型
        char buffer[1 + strlen(attributes)];
        strcpy(buffer, attributes);
        char *state = buffer;
        char *attribute = strsep(&state, ",");
        NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
        type = (char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
    }else{//普通数据类型
        const char *t = [[[[NSString stringWithUTF8String:attributes]componentsSeparatedByString:@","][0]substringFromIndex:1]UTF8String];
        if (strcmp(t, @encode(char)) == 0) {
            type = "char";
        } else if (strcmp(t, @encode(int)) == 0) {
            type = "int";
        } else if (strcmp(t, @encode(short)) == 0) {
            type = "short";
        } else if (strcmp(t, @encode(long)) == 0) {
            type = "long";
        } else if (strcmp(t, @encode(long long)) == 0) {
            type = "long long";
        } else if (strcmp(t, @encode(unsigned char)) == 0) {
            type = "unsigned char";
        } else if (strcmp(t, @encode(unsigned int)) == 0) {
            type = "unsigned int";
        } else if (strcmp(t, @encode(unsigned short)) == 0) {
            type = "unsigned short";
        } else if (strcmp(t, @encode(unsigned long)) == 0) {
            type = "unsigned long";
        } else if (strcmp(t, @encode(unsigned long long)) == 0) {
            type = "unsigned long long";
        } else if (strcmp(t, @encode(float)) == 0) {
            type = "float";
        } else if (strcmp(t, @encode(double)) == 0) {
            type = "double";
        } else if (strcmp(t, @encode(_Bool)) == 0 || strcmp(t, @encode(bool)) == 0) {
            type = "BOOL";
        } else if (strcmp(t, @encode(void)) == 0) {
            type = "void";
        } else if (strcmp(t, @encode(char *)) == 0) {
            type = "char *";
        } else if (strcmp(t, @encode(id)) == 0) {
            type = "id";
        } else if (strcmp(t, @encode(Class)) == 0) {
            type = "Class";
        } else if (strcmp(t, @encode(SEL)) == 0) {
            type = "SEL";
        } else {
            type = "";
        }
    }
    return type;
}
//获取类的属性的数据类型
- (const char*)findPropertyTypeWithName:(NSString*)name{
    const char * propertyName = name.UTF8String;
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *property_name = property_getName(property);
        if (strcmp(property_name, propertyName) == 0) {//找到了对应的属性
            return getPropertyType(property);
        }
    }
    return nil;
}
//获取对象的所有方法
- (NSArray*)getMothList{
    unsigned int mothCout_f =0;
    NSMutableArray *meths = [NSMutableArray array];
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++){
        Method temp_f = mothList_f[i];
        //        IMP imp_f = method_getImplementation(temp_f);
        //        imp_f();
        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(name_f);
        int arguments = method_getNumberOfArguments(temp_f);
        //        const char* encoding =method_getTypeEncoding(temp_f);
        //        SEL nas = NSSelectorFromString([NSString stringWithUTF8String:name_s]);
        [meths addObject:[NSString stringWithUTF8String:name_s]];
        NSLog(@"方法名：%@ 参数个数：%d",NSStringFromSelector(name_f),arguments);
    }
    free(mothList_f);
    return [NSArray arrayWithArray:meths];
}
@end
