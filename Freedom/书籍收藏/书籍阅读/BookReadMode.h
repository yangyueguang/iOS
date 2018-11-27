//
//  BookReadMode.h
//  Freedom
//
//  Created by Super on 2018/4/27.
//  Copyright © 2018年 Super. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef WFReader_E_ContantFile_h
#define WFReader_E_ContantFile_h
#define OPEN @"open"
#define SAVEPAGE @"savePage"
#define SAVETHEME @"saveTheme"
#define offSet_x 20
#define offSet_y 40
#define FONT_SIZE @"FONT_SIZE"
#define kBottomBarH 150
#define FilePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define epubBookName @"倚天屠龙记"
#endif
/*公共管理类*/
@interface E_CommonManager : NSObject
/*保存页码
 *
 *  @param currentChapter 现页码*/
+ (void)saveCurrentPage:(NSInteger)currentPage;
/*获得之前看的页码
 *
 *  @return 页码数*/
+ (NSUInteger)Manager_getPageBefore;
/*保存章节
 *
 *  @param currentChapter 现章节*/
+ (void)saveCurrentChapter:(NSInteger)currentChapter;
/*获得主题背景
 *
 *  @return 主题背景id*/
+ (NSInteger)Manager_getReadTheme;
/*保存主题ID
 *
 *  @param currentThemeID 主题ID*/
+ (void)saveCurrentThemeID:(NSInteger)currentThemeID;
/*获得之前看的章节
 *
 *  @return 章节数*/
+ (NSUInteger)Manager_getChapterBefore;
/*获得字号
 *
 *  @return 字号大小*/
+ (NSUInteger)fontSize;
/*存储字号
 *
 *  @param fontSize 存储的字号大小*/
+ (void)saveFontSize:(NSUInteger)fontSize;
/*检查当前页是否加了书签
 *
 *  @param currentRange 当前range
 *  @param currentChapter
 *  @return 是否加了书签*/
+ (BOOL)checkIfHasBookmark:(NSRange)currentRange withChapter:(NSInteger)currentChapter;
/*保存书签
 *
 *  @param currentChapter 当前章节
 *  @param chapterRange   当前页起始的一段文字的range*/
+ (void)saveCurrentMark:(NSInteger)currentChapter andChapterRange:(NSRange)chapterRange byChapterContent:(NSString *)chapterContent;
/*获得书签数组
 *
 *  @return 书签数组*/
+ (NSMutableArray *)Manager_getMark;
@end
/*每章的内容与标题*/
@interface E_EveryChapter : NSObject
@property (nonatomic,strong)  NSString *chapterContent;
@property (nonatomic,strong)  NSString *chapterTitle;
@end
@interface E_Mark : NSObject
@property (nonatomic,strong) NSString  *markChapter;
@property (nonatomic,strong) NSString  *markRange;
@property (nonatomic,strong) NSString  *markContent;
@property (nonatomic,strong) NSString  *markTime;
@end
/*书籍内容来源部分   退出的时候页码存储未写，根据实际情况去存*/
@interface E_ReaderDataSource : NSObject
//当前章节数
@property (unsafe_unretained, nonatomic) NSUInteger currentChapterIndex;
//总章节数
@property (unsafe_unretained, nonatomic) NSUInteger totalChapter;
@property (copy             , nonatomic) NSMutableString  *totalString;//全文
@property (strong           , nonatomic) NSMutableArray   *everyChapterRange;//每章节的range
/*单例
 *
 *  @return 实例*/
+ (E_ReaderDataSource *)shareInstance;
/*通过传入id来获取章节信息
 *
 *  @return 章节类*/
- (E_EveryChapter *)openChapter;
/*章节跳转
 *
 *  @param clickChapter 跳转章节数
 *
 *  @return 该章节*/
- (E_EveryChapter *)openChapter:(NSInteger)clickChapter;
/*打开得页数
 *
 *  @return 返回页数*/
- (NSUInteger)openPage;
/*获得下一章内容
 *
 *  @return 章节类*/
- (E_EveryChapter *)nextChapter;
/*获得上一章内容
 *
 *  @return 章节类*/
- (E_EveryChapter *)preChapter;
/*全文搜索
 *
 *  @param keyWord 要搜索的关键字
 *
 *  @return 搜索的关键字所在的位置*/
- (NSMutableArray *)searchWithKeyWords:(NSString *)keyWord;
/*获得全文*/
- (void)resetTotalString;
/*获得指定章节的第一个字在整篇文章中的位置
 *
 *  @param page 指定章节
 *
 *  @return 位置*/
- (NSInteger)getChapterBeginIndex:(NSInteger)page;
@end
@interface BookReadMode : NSObject
@end
