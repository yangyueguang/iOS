//
//  GPAPolylineEncoding.m
//  GooglePolylineApp
//
//  Created by Lukas Oslislo on 11/12/15.
#import "GPAPolylineEncoding.h"
@interface GPAPolylineEncoding()
@property (assign, atomic) int position;
@end
@implementation GPAPolylineEncoding
const int BIT_1 = 0b00000001;
const int BIT_2 = 0b00000010;
const int BIT_3 = 0b00000100;
const int BIT_4 = 0b00001000;
const int BIT_5 = 0b00010000;
const int BIT_6 = 0b00100000;
const int BIT_7 = 0b01000000;
const int BIT_8 = 0b10000000;
const int bitArray[5] = {BIT_1, BIT_2, BIT_3, BIT_4, BIT_5};
+ (NSArray<NSNumber *> *)decodePolyline: (NSString *)polylineString{
    if(!polylineString)return nil;
    NSParameterAssert(polylineString);
    if (polylineString == (id)[NSNull null] || polylineString.length == 0) {return nil;}
    NSMutableArray<NSNumber *> *latLongs = [[NSMutableArray alloc]init];
    NSMutableArray *currentChunk = [[NSMutableArray alloc]init];
    for (int i = 0; i < polylineString.length; i++) {
        unichar character = [polylineString characterAtIndex:i];
        int decimal = character - 63;
        [currentChunk addObject:@(decimal)];
        BOOL isEndOfChunk = !(decimal & BIT_6);
        if (isEndOfChunk) {
            double coordinateElement = [self.class coordinateElementFromChunk: currentChunk];
            if (latLongs.count >= 2) {
                NSNumber *preceedingElement = latLongs[latLongs.count-2];
                coordinateElement += preceedingElement.doubleValue;
            }
            [latLongs addObject:@(coordinateElement)];
            [currentChunk removeAllObjects];
        }
    }
    return latLongs;
}
+ (double)coordinateElementFromChunk:(NSArray<NSNumber *> *)chunk {
    double coordinateElement = 0.0f;
    int result = 0;
    for (int j = 0; j < chunk.count; j++) {
        NSNumber *number5Bit = chunk[j];
        int value5Bit = number5Bit.intValue;
        // each is 5 bit long
        for (int i = 0; i < 5; i++) {
            BOOL isBitSet = value5Bit & bitArray[i];
            if (isBitSet) {
                int exponent = i+j*5;
                int intPos = powf(2, exponent);
                result |= intPos;
            }
        }
    }
    result = [self.class invertAndRightShift:result];
    coordinateElement = result / 1e5;
    return coordinateElement;
}
+ (int)invertAndRightShift:(int)data8bit {
    int result = 0;
    BOOL isNegativeValue = data8bit & 1;
    result = data8bit >> 1;
    if (isNegativeValue) {
        result = ~result;
    }
    return result;
}

-(NSArray<NSValue*> *)decodePolyline:(NSString *)encodedPolyline{
    NSData *data = [encodedPolyline dataUsingEncoding:NSUTF8StringEncoding];
    char* byteArray = (char*)data.bytes;
    int length = (int)data.length;
    self.position = 0;
    NSMutableArray <NSValue*>*result = [NSMutableArray array];
    double lat = 0.0;double lon = 0.0;
    double precision = 100*1000.0;
    while (self.position < length){
        @try {
            double resultingLon = [self decodeSingleCoordinate:byteArray length:length position:self.position precision:precision];
            lat += resultingLon;
            double resultingLat = [self decodeSingleCoordinate:byteArray length:length position:self.position precision:precision];
            lon += resultingLat;
        } @catch (NSException *exception) {
        } @finally {
        }
        CLLocationCoordinate2D cl = CLLocationCoordinate2DMake(lat, lon);
        [result addObject:[NSValue valueWithMKCoordinate:cl]];
    };
    return result;
}

-(double)decodeSingleCoordinate:( const char *)byteArray length:(int)length position:(int)position precision:(double)precision {
    precision = 100*1000.0;
    if (self.position >= length) {
        return 0;//错误异常
    }
    int bitMask = 0x1F;
    int coordinate = 0;
    int currentChar;
    int componentCounter = 0;
    int component = 0;
    do {
        currentChar = byteArray[self.position] - 63;
        component = (currentChar & bitMask);
        coordinate |= (component << (5*componentCounter));
        self.position++;
        componentCounter++;
    } while (((currentChar & 0x20) == 0x20) && (self.position < length) && (componentCounter < 6)) ;
    if((componentCounter == 6) && ((currentChar & 0x20) == 0x20)){
        return 0.0f; // 报错
    }
    if ((coordinate & 0x01) == 0x01) {
        coordinate = ~(coordinate >> 1);
    }else {
        coordinate = coordinate >> 1;
    }
    return (double)coordinate / precision;
}
@end
