#import "NSObject+Mirror.h"
#import <objc/runtime.h>
//#import <objc/message.h>
@implementation NSObject (Mirror)
//获取对象的所有属性及属性类型
+ (NSDictionary*)propertiesDictionary{
    if (self == NULL){return nil;}
    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        NSString *realType = [NSString stringWithUTF8String:getPropertyType(property)];
        NSLog(@"属性名：%@ 属性类型：%@", propName, realType);
        [results setObject:realType forKey:propName];
    }
    free(properties);
    return [NSDictionary dictionaryWithDictionary:results];
}
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);//获取属性描述字符串
    const char *type;
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

//获取对象的所有方法
+ (NSArray*)getMothList{
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
        const char* encoding = method_getTypeEncoding(temp_f);
//        SEL nas = NSSelectorFromString([NSString stringWithUTF8String:name_s]);
        [meths addObject:[NSString stringWithUTF8String:name_s]];
        NSLog(@"方法名：%@ 参数个数：%d 编码：%s",NSStringFromSelector(name_f),arguments, encoding);
    }
    free(mothList_f);
    return [NSArray arrayWithArray:meths];
}
#pragma mark - Class Methods
+ (NSArray *)objectArrayWithJsonArray:(NSArray *)jsonArray {
    NSMutableArray *objects = [NSMutableArray array];
    for (NSDictionary *dict in jsonArray) {
        id instance = [[self alloc] initWithDict:dict];
        [objects addObject:instance];
    }
    return objects;
}

+ (NSArray *)jsonArrayWithObjectArray:(NSArray *)objectArray {
    NSMutableArray *jsonObjects = [NSMutableArray array];
    for (NSObject *model in objectArray) {
        NSDictionary *jsonDict = [model toDictionary];
        [jsonObjects addObject:jsonDict];
    }
    return jsonObjects;
}
#pragma mark - Initialize
- (id)initWithDict:(NSDictionary *)aDict{
    self = [self init];
    if (self) {
        [self setAttributesWithDictionary:aDict];
    }
    return self;
}
- (id)initWithJson:(NSString *)json {
    self = [self init];
    if (self) {
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
        if (error) { return nil; }
        self = [self initWithDict:dict];
    }
    return self;
}
- (void)setAttributesWithDictionary:(NSDictionary *)aDict{
    //获得完整的映射字典
    NSMutableDictionary *mapDictionary = [[self attributeMapDictionary] mutableCopy];
    if (mapDictionary == nil) {
        mapDictionary = [NSMutableDictionary dictionaryWithCapacity:aDict.count];
    }
    for (NSString *key in aDict) {
        if ([mapDictionary.allValues containsObject:key]) { continue; }
        [mapDictionary setObject:key forKey:key];
    }
    //遍历映射字典
    NSEnumerator *keyEnumerator = [mapDictionary keyEnumerator];
    id attributeName = nil;
    while ((attributeName = [keyEnumerator nextObject])) {
        SEL setter = [self setterForPropertyName:attributeName];
        if ([self respondsToSelector:setter]) {
            NSString *aDictKey = [mapDictionary objectForKey:attributeName];
            id aDictValue = [self parsePropertyValueWithValueDictionary:aDict mappedKey:aDictKey];
            objc_property_t property = class_getProperty([self class], [attributeName cStringUsingEncoding:NSUTF8StringEncoding]);
            if (property == NULL) {
                continue;
            }
            NSString *type = [self propertyTypeForProperty:property];
            if ([aDictValue isKindOfClass:[NSDictionary class]]) {
                if ([type isEqualToString:@"NSDictionary"] || [type isEqualToString:@"NSMutableDictionary"]) {
                    [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
                } else {
                    Class newClass = objc_getClass([type cStringUsingEncoding:NSUTF8StringEncoding]);
                    if ([newClass isSubclassOfClass:[NSObject class]]){
                        id instance = [[newClass alloc] initWithDict:aDictValue];
                        [self performSelectorOnMainThread:setter withObject:instance waitUntilDone:[NSThread isMainThread]];
                    }
                }
            } else if ([aDictValue isKindOfClass:[NSArray class]]) {//如果传入的字典中有数组
                NSMutableArray *valueArray = [NSMutableArray array];
                NSDictionary *objectClasses = [self objectClassesInArray];
                if (objectClasses == nil) {
                    continue;
                }
                NSString *classString = [objectClasses objectForKey:aDictKey];
                if (classString) {
                    for (id content in aDictValue) {
                        NSString *fullClass = NSStringFromClass([self class]);
                        NSString *cname = [fullClass componentsSeparatedByString:@"."].lastObject;
                        classString = [fullClass stringByReplacingOccurrencesOfString:cname withString:classString];
                        Class classInArray = NSClassFromString(classString);
                        if ([classInArray isSubclassOfClass:[NSObject class]]) {
                            id instance = [[classInArray alloc] initWithDict:content];
                            [valueArray addObject:instance];
                        } else if ([content isKindOfClass:classInArray]) {
                            [valueArray addObject:content];
                        }
                    }
                } else {
                    valueArray = aDictValue;
                }
                [self performSelectorOnMainThread:setter withObject:valueArray waitUntilDone:[NSThread isMainThread]];
            } else if ([aDictValue isKindOfClass:[NSNumber class]]) {
                if ([type isEqualToString:@"NSNumber"]) {
                    [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
                } else {
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
                    // [invocation setArgument:&basicData atIndex:2];
                    [invocation invoke];
                }
            } else if ([aDictValue isKindOfClass:[NSNull class]]) {
                if ([type isEqualToString:@"NSString"]) {
                    [self performSelectorOnMainThread:setter withObject:@"" waitUntilDone:[NSThread isMainThread]];
                } else if ([type isEqualToString:@"NSArray"]) {
                    [self performSelectorOnMainThread:setter withObject:[NSArray array] waitUntilDone:[NSThread isMainThread]];
                } else if ([type isEqualToString:@"NSNumber"]) {
                    [self performSelectorOnMainThread:setter withObject:@0 waitUntilDone:[NSThread isMainThread]];
                } else if ([type isEqualToString:@"NSDictionary"]) {
                    [self performSelectorOnMainThread:setter withObject:[NSDictionary dictionary] waitUntilDone:[NSThread isMainThread]];
                } else {
                    [self performSelectorOnMainThread:setter withObject:[NSNull null] waitUntilDone:[NSThread isMainThread]];
                }
            } else {
                [self performSelectorOnMainThread:setter withObject:aDictValue waitUntilDone:[NSThread isMainThread]];
            }
        }
    }
}
- (NSDictionary *)toDictionary {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    NSDictionary *keyValueMap = [self attributeMapDictionary];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        NSLog(@"key = %@, value = %@, value class = %@, changed Key = %@", key, value, NSStringFromClass([value class]), [keyValueMap objectForKey:key]);
        if ([keyValueMap.allKeys containsObject:key]) {
            key = [keyValueMap objectForKey:key];
        }
        if (key && value) {
            if ([value isKindOfClass:[NSString class]]) {
                [dict setValue:value forKey:key];
            }else if([value isKindOfClass:[NSArray class]]){
                NSString *classString = [[self objectClassesInArray]valueForKey:key];
                if(classString){
                    NSMutableArray *values = [NSMutableArray array];
                    for(NSObject *obj in (NSArray*)value){
                        NSDictionary *objDict = [obj toDictionary];
                        [values addObject:objDict];
                    }
                    [dict setObject:values forKey:key];
                }else{
                    [dict setValue:value forKey:key];
                }
            }else if([value isKindOfClass:[NSDictionary class]]){
                [dict setValue:value forKey:key];
            }else if([value isKindOfClass:[NSNumber class]]){
                [dict setValue:value forKey:key];
            }else if([value isKindOfClass:[NSObject class]]){
                [dict setObject:[value toDictionary] forKey:key];
            } else {
                [dict setObject:value forKey:key];
            }
        } else if (key && value == nil) {
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    free(properties);
    return dict;
}
///FIXME: 需要子类重写
- (NSDictionary *)attributeMapDictionary{
    return nil;
}
- (NSDictionary *)objectClassesInArray {
    return nil;
}
#pragma mark - Private Methods
- (SEL)setterForPropertyName:(NSString *)propertyName {
    NSString *firstAlpha = [[propertyName substringToIndex:1] uppercaseString];
    NSString *otherAlpha = [propertyName substringFromIndex:1];
    NSString *setterMethodName = [NSString stringWithFormat:@"set%@%@:", firstAlpha, otherAlpha];
    return NSSelectorFromString(setterMethodName);
}
- (id)parsePropertyValueWithValueDictionary:(NSDictionary *)aDict mappedKey:(NSString *)aDictKey {
    id aDictValue = nil;
    if ([aDictKey rangeOfString:@"."].length != 0) {
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
        aDictValue = [aDict objectForKey:aDictKey];
    }
    return aDictValue;
}
- (NSString *)propertyTypeForProperty:(objc_property_t)property {
    const char *attrs = property_getAttributes(property);
    if (attrs == NULL) { return nil; }
    NSString *type = [NSString stringWithCString:attrs encoding:NSUTF8StringEncoding];
    type = [type componentsSeparatedByString:@","].firstObject;  //ie.T@"NSString" or Ti
    if ([type rangeOfString:@"@"].length != 0) {
        type = [type substringFromIndex:3]; //ie. NSString"
        type = [type substringToIndex:[type rangeOfString:@"\""].location]; //ie. NSString
    } else {
        type = [type substringFromIndex:1];
    }
    return type;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        unsigned int count = 0;
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
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        SEL getter = NSSelectorFromString(key);
        if ([self respondsToSelector:getter]) {
            NSMethodSignature* methodSig = [self methodSignatureForSelector:getter];
            const char *returnType = [methodSig methodReturnType];
            if (strcmp(returnType, @encode(id)) == 0) {
                id returnValue = [self performSelector:getter];
                [aCoder encodeObject:returnValue forKey:key];
            } else {
                NSString *type = [self propertyTypeForProperty:properties[i]];
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
@end
