//  City.m
//  XTuan
#import "City.h"
#import "NSObject+expanded.h"
@implementation BaseModel
@end
@interface CitySection : BaseModel
//所有城市
@property(nonatomic, strong)NSMutableArray *cities;
@end
@implementation CitySection
-(void)setCities:(NSMutableArray *)cities{
    // 当cities为空或者里面装的是模型数据，就直接赋值
    id obj = [cities lastObject];
    if (![obj isKindOfClass:[NSDictionary class]]){
        _cities = cities;
        return;
    }
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in cities) {
        if ([dict isKindOfClass:[City class]]) {
            _cities = cities;
            return;
        }
        City *city = [[City alloc] init];
        [city setValuesForKeysWithDictionary:dict];
        [arrayM addObject:city];
    }
    _cities = arrayM;
}
@end
@interface District : BaseModel//街道
@property(nonatomic, strong)NSArray *neighborhoods;
@end
@implementation District
@end
@implementation City
-(void)setDistricts:(NSArray *)districts{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in districts) {
        District *districts = [[District alloc] init];
        [districts setValuesForKeysWithDictionary:dict];
        [arrayM addObject:districts];
    }
    _districts = arrayM;
}
@end
