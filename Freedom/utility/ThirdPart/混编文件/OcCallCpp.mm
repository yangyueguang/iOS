//
//  OcCallCpp.m
#import "OcCallCpp.h"
#import "OC-CppInterface.h"
void* OcInit(){
    MyOcClass *p = [[MyOcClass alloc] init];
    return (__bridge_retained void *)p;
}
void OcDosomething(void *ocInstance){
    MyOcClass *p = (__bridge MyOcClass *)ocInstance;
    return [p doSomething];
}
void OcRelease(void *ocInstance){
    MyOcClass *p = (__bridge_transfer MyOcClass *)ocInstance;
    p = nil;
}
@implementation MyOcClass
- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"MyOcClass init");
    }
    return self;
}
- (void)dealloc{
    NSLog(@"MyOcClass dealloc");
}
- (void)doSomething{
    NSLog(@"MyOcClass doSomething");
}
@end

@implementation OcCallCpp
- (instancetype)init{
    NSLog(@"OcCallCpp init");
    self = [super init];
    if (self) {
        self->mycppClass = new CMyCppClass();
    }
    return self;
}
- (void)dealloc{
    NSLog(@"oc call cpp dealloc");
    if (self->mycppClass != NULL) {
        delete self->mycppClass;
        self->mycppClass = NULL;
    }
}
- (void)doSomething{
    self->mycppClass->ExampleMethod();
}
@end
