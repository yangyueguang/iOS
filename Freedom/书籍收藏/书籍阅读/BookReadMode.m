//
//  BookReadMode.m
//  Freedom
//
//  Created by Super on 2018/4/27.
//  Copyright © 2018年 Super. All rights reserved.
//
#import "BookReadMode.h"
#import "BookSubViews.h"
#define kMarkChapter    @"kMarkChapter"
#define kMarkRange      @"kMarkRange"
#define kMarkContent    @"kMarkContent"
#define kMarkTime       @"kMarkTime"
@implementation E_CommonManager
+ (NSInteger)Manager_getReadTheme{
    NSString *themeID = [[NSUserDefaults standardUserDefaults] objectForKey:SAVETHEME];
    if (themeID == nil) {
        return 1;
    }else{
        return [themeID integerValue];
    }
}
+ (void)saveCurrentThemeID:(NSInteger)currentThemeID{
    [[NSUserDefaults standardUserDefaults] setValue:@(currentThemeID) forKey:SAVETHEME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSUInteger)Manager_getPageBefore{
    NSString *pageID = [[NSUserDefaults standardUserDefaults] objectForKey:SAVEPAGE];
    if (pageID == nil) {
        return 0;
    }else{
        return [pageID integerValue];
    }
}
+ (void)saveCurrentPage:(NSInteger)currentPage{
    [[NSUserDefaults standardUserDefaults] setValue:@(currentPage) forKey:SAVEPAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+ (NSUInteger)Manager_getChapterBefore{
    NSString *chapterID = [[NSUserDefaults standardUserDefaults] objectForKey:OPEN];
    if (chapterID == nil) {
        
        return 1;
        
    }else{
        
        return [chapterID integerValue];
        
    }
}
+ (void)saveCurrentChapter:(NSInteger)currentChapter{
    [[NSUserDefaults standardUserDefaults] setValue:@(currentChapter) forKey:OPEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSUInteger)fontSize{
    NSUInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:FONT_SIZE];
    if (fontSize == 0) {
        fontSize = 20;
    }
    return fontSize;
}
+ (void)saveFontSize:(NSUInteger)fontSize{
    [[NSUserDefaults standardUserDefaults] setValue:@(fontSize) forKey:FONT_SIZE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark- 书签保存
+ (void)saveCurrentMark:(NSInteger)currentChapter andChapterRange:(NSRange)chapterRange byChapterContent:(NSString *)chapterContent{
    NSDate *senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:senddate];
    E_Mark *eMark = [[E_Mark alloc] init];
    eMark.markRange   = NSStringFromRange(chapterRange);
    eMark.markChapter = [NSString stringWithFormat:@"%zi",currentChapter];
    eMark.markContent = [chapterContent substringWithRange:chapterRange];
    eMark.markTime    = locationString;
    if (![self checkIfHasBookmark:chapterRange withChapter:currentChapter]) {//没加书签
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (oldSaveArray.count == 0) {
            
            NSMutableArray *newSaveArray = [[NSMutableArray alloc] init];
            [newSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:newSaveArray] forKey:epubBookName];
            
        }else{
            
            [oldSaveArray addObject:eMark];
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:epubBookName];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{//有书签
        
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
        NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = 0 ; i < oldSaveArray.count; i ++) {
            
            E_Mark *e = (E_Mark *)[oldSaveArray objectAtIndex:i];
            
            if (((NSRangeFromString(e.markRange).location >= chapterRange.location) && (NSRangeFromString(e.markRange).location < chapterRange.location + chapterRange.length)) && ([e.markChapter isEqualToString:[NSString stringWithFormat:@"%zi",currentChapter]])) {
                
                [oldSaveArray removeObject:e];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:oldSaveArray] forKey:epubBookName];
                
            }
        }
    }
    
}
+ (BOOL)checkIfHasBookmark:(NSRange)currentRange withChapter:(NSInteger)currentChapter{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    int k = 0;
    for (int i = 0; i < oldSaveArray.count; i ++) {
        E_Mark *e = (E_Mark *)[oldSaveArray objectAtIndex:i];
        
        if ((NSRangeFromString(e.markRange).location >= currentRange.location) && (NSRangeFromString(e.markRange).location < currentRange.location + currentRange.length) && [e.markChapter isEqualToString:[NSString stringWithFormat:@"%zi",currentChapter]]) {
            k++;
        }else{
            // k++;
        }
    }
    if (k >= 1) {
        return YES;
    }else{
        return NO;
    }
}
+ (NSMutableArray *)Manager_getMark{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:epubBookName];
    NSMutableArray *oldSaveArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (oldSaveArray.count == 0) {
        return nil;
    }else{
        return oldSaveArray;
        
    }
}
@end
@implementation E_EveryChapter
@end
@implementation E_Mark
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.markChapter forKey:kMarkChapter];
    [encoder encodeObject:self.markRange   forKey:kMarkRange];
    [encoder encodeObject:self.markContent forKey:kMarkContent];
    [encoder encodeObject:self.markTime    forKey:kMarkTime];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.markChapter = [decoder decodeObjectForKey:kMarkChapter];
        self.markRange   = [decoder decodeObjectForKey:kMarkRange];
        self.markContent = [decoder decodeObjectForKey:kMarkContent];
        self.markTime    = [decoder decodeObjectForKey:kMarkTime];
    }
    return self;
}
@end
@implementation E_ReaderDataSource
+ (E_ReaderDataSource *)shareInstance{
    static E_ReaderDataSource *dataSource;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSource = [[E_ReaderDataSource alloc] init];
    });
    return dataSource;
}
- (E_EveryChapter *)openChapter:(NSInteger)clickChapter{
    _currentChapterIndex = clickChapter;
    E_EveryChapter *chapter = [[E_EveryChapter alloc] init];
    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",_currentChapterIndex];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    chapter.chapterContent = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    return chapter;
}
- (E_EveryChapter *)openChapter{
    NSUInteger index = [E_CommonManager Manager_getChapterBefore];
    _currentChapterIndex = index;
    E_EveryChapter *chapter = [[E_EveryChapter alloc] init];
    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",_currentChapterIndex];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    chapter.chapterContent = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    return chapter;
}
- (NSUInteger)openPage{
    NSUInteger index = [E_CommonManager Manager_getPageBefore];
    return index;
}
- (E_EveryChapter *)nextChapter{
    if (_currentChapterIndex >= _totalChapter) {
        [E_HUDView showMsg:@"没有更多内容了" inView:nil];
        return nil;
    }else{
        _currentChapterIndex++;
        E_EveryChapter *chapter = [E_EveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex);
        return chapter;
    }
}
- (E_EveryChapter *)preChapter{
    if (_currentChapterIndex <= 1) {
        [E_HUDView showMsg:@"已经是第一页了" inView:nil];
        return nil;
        
    }else{
        _currentChapterIndex --;
        E_EveryChapter *chapter = [E_EveryChapter new];
        chapter.chapterContent = readTextData(_currentChapterIndex);
        return chapter;
    }
}
- (void)resetTotalString{
    _totalString = [NSMutableString string];
    _everyChapterRange = [NSMutableArray array];
    for (int i = 1; i <  INT_MAX; i ++) {
        if (readTextData(i) != nil) {
            NSUInteger location = _totalString.length;
            [_totalString appendString:readTextData(i)];
            NSUInteger length = _totalString.length - location;
            NSRange chapterRange = NSMakeRange(location, length);
            [_everyChapterRange addObject:NSStringFromRange(chapterRange)];
        }else{
            break;
        }
    }
}
- (NSInteger)getChapterBeginIndex:(NSInteger)page{
    NSInteger index = 0;
    for (int i = 1; i < page; i ++) {
        if (readTextData(i) != nil) {
            index += readTextData(i).length;
        }else{
            break;
        }
    }
    return index;
}
- (NSMutableArray *)searchWithKeyWords:(NSString *)keyWord{
    //关键字为空 则返回空数组
    if (keyWord == nil || [keyWord isEqualToString:@""]) {
        return nil;
    }
    NSMutableArray *searchResult = [[NSMutableArray alloc] initWithCapacity:0];//内容
    NSMutableArray *whichChapter = [[NSMutableArray alloc] initWithCapacity:0];//内容所在章节
    NSMutableArray *locationResult = [[NSMutableArray alloc] initWithCapacity:0];//搜索内容所在range
    NSMutableArray *feedBackResult = [[NSMutableArray alloc] initWithCapacity:0];//上面3个数组集合
    NSMutableString *blankWord = [NSMutableString string];
    for (int i = 0; i < keyWord.length; i ++) {
        [blankWord appendString:@" "];
    }
    //一次搜索20条
    for (int i = 0; i < 20; i++) {
        
        if ([_totalString rangeOfString:keyWord options:1].location != NSNotFound) {
            
            NSInteger newLo = [_totalString rangeOfString:keyWord options:1].location;
            NSInteger newLen = [_totalString rangeOfString:keyWord options:1].length;
            // DLog(@"newLo == %ld,, newLen == %ld",newLo,newLen);
            int temp = 0;
            for (int j = 0; j < _everyChapterRange.count; j ++) {
                if (newLo > NSRangeFromString([_everyChapterRange objectAtIndex:j]).location) {
                    temp ++;
                }else{
                    break;
                }
                
            }
            
            [whichChapter addObject:[NSString stringWithFormat:@"%d",temp]];
            [locationResult addObject:NSStringFromRange(NSMakeRange(newLo, newLen))];
            
            NSRange searchRange = NSMakeRange(newLo, [self doRandomLength:newLo andPreOrNext:NO] == 0?newLen:[self doRandomLength:newLo andPreOrNext:NO]);
            
            NSString *completeString = [[_totalString substringWithRange:searchRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            completeString = [completeString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [searchResult addObject:completeString];
            
            
            
            [_totalString replaceCharactersInRange:NSMakeRange(newLo, newLen) withString:blankWord];
            
        }else{
            break;
        }
    }
    [feedBackResult addObject:searchResult];
    [feedBackResult addObject:whichChapter];
    [feedBackResult addObject:locationResult];
    return feedBackResult;
}
- (NSInteger)doRandomLength:(NSInteger)location andPreOrNext:(BOOL)sender{
    //获取1到x之间的整数
    if (sender == YES) {
        NSInteger temp = location;
        NSInteger value = (arc4random() % 13) + 5;
        location -=value;
        if (location<0) {
            location = temp;
        }
        return location;
    }else{
        NSInteger value = (arc4random() % 20) + 20;
        if (location + value >= _totalString.length) {
            value = 0;
        }else{
        }
        return value;
    }
    
}
static NSString *readTextData(NSUInteger index){
    NSString *chapter_num = [NSString stringWithFormat:@"Chapter%ld",index];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:chapter_num ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path1 encoding:4 error:NULL];
    return content;
}
@end
@implementation BookReadMode
@end
