//  E_ContantFile.h
//  Freedom
//  Created by Super on 14/12/25.
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
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))
#endif
