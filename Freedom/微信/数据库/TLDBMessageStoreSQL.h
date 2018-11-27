//  TLDBMessageStoreSQL.h
//  Freedom
// Created by Super
#ifndef TLDBMessageStoreSQL_h
#define TLDBMessageStoreSQL_h
#define     MESSAGE_TABLE_NAME              @"message"
#define     SQL_CREATE_MESSAGE_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
    msgid TEXT,\
uid TEXT,\
fid TEXT,\
subfid TEXT,\
date TEXT,\
partner_type INTEGER DEFAULT (0),\
own_type INTEGER DEFAULT (0),\
msg_type INTEGER DEFAULT (0),\
content TEXT,\
send_status INTEGER DEFAULT (0),\
received_status BOOLEAN DEFAULT (0),\
ext1 TEXT,\
ext2 TEXT,\
ext3 TEXT,\
ext4 TEXT,\
ext5 TEXT,\
PRIMARY KEY(uid, msgid, fid, subfid))"
#define     SQL_ADD_MESSAGE                 @"REPLACE INTO %@ ( msgid, uid, fid, subfid, date, partner_type, own_type, msg_type, content, send_status, received_status, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
#define     SQL_SELECT_MESSAGES_PAGE        @"SELECT * FROM %@ WHERE uid = '%@' and fid = '%@' and date < '%@' order by date desc LIMIT '%ld'"
#define     SQL_SELECT_CHAT_FILES           @"SELECT * FROM %@ WHERE uid = '%@' and fid = '%@' and msg_type = '2'"
#define     SQL_SELECT_CHAT_MEDIA           @"SELECT * FROM %@ WHERE uid = '%@' and fid = '%@' and msg_type = '2'"
#define     SQL_SELECT_LAST_MESSAGE         @"SELECT * FROM %@ WHERE date = ( SELECT MAX(date) FROM %@ WHERE uid = '%@' and fid = '%@' )"
#define     SQL_DELETE_MESSAGE              @"DELETE FROM %@ WHERE msgid = '%@'"
#define     SQL_DELETE_FRIEND_MESSAGES      @"DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"
#define     SQL_DELETE_USER_MESSAGES        @"DELETE FROM %@ WHERE uid = '%@'"
#define     CONV_TABLE_NAME             @"conversation"
#define     SQL_CREATE_CONV_TABLE       @"CREATE TABLE IF NOT EXISTS %@(\
uid TEXT,\
fid TEXT,\
conv_type INTEGER DEFAULT (0), \
date TEXT,\
unread_count INTEGER DEFAULT (0),\
ext1 TEXT,ext2 TEXT,ext3 TEXT,\
ext4 TEXT,\
ext5 TEXT,\
PRIMARY KEY(uid, fid))"
#define     SQL_ADD_CONV                @"REPLACE INTO %@ ( uid, fid, conv_type, date, unread_count, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
#define     SQL_SELECT_CONVS            @"SELECT * FROM %@ WHERE uid = %@ ORDER BY date DESC"
#define     SQL_SELECT_CONV_UNREAD      @"SELECT unread_count FROM %@ WHERE uid = '%@' and fid = '%@'"
#define     SQL_DELETE_CONV             @"DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"
#define     SQL_DELETE_ALL_CONVS        @"DELETE FROM %@ WHERE uid = '%@'"
#pragma mark - 表情组
#define     EXP_GROUP_TABLE_NAME             @"expression_group"
#define     SQL_CREATE_EXP_GROUP_TABLE       @"CREATE TABLE IF NOT EXISTS %@(\
uid TEXT,\
gid TEXT,\
type INTEGER DEFAULT (0), \
name TEXT,\
desc TEXT,\
detail TEXT,\
count INTEGER DEFAULT (0), \
auth_id TEXT,\
auth_name TEXT,\
date TEXT,\
ext1 TEXT,\
ext2 TEXT,\
ext3 TEXT,\
ext4 TEXT,\
ext5 TEXT,\
PRIMARY KEY(uid, gid))"
#define     SQL_ADD_EXP_GROUP           @"REPLACE INTO %@ ( uid, gid, type, name, desc, detail, count, auth_id, auth_name, date, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"
#define     SQL_SELECT_EXP_GROUP        @"SELECT * FROM %@ WHERE uid = '%@'"
#define     SQL_DELETE_EXP_GROUP        @"DELETE FROM %@ WHERE uid = '%@' and gid = '%@'"
#define     SQL_SELECT_COUNT_EXP_GROUP_USERS    @"SELECT count(uid) FROM %@ WHERE gid = '%@'"
#pragma mark -  表情
#define     EXPS_TABLE_NAME             @"expressions"
#define     SQL_CREATE_EXPS_TABLE       @"CREATE TABLE IF NOT EXISTS %@(\
gid TEXT,\
eid TEXT, \
name TEXT,\
ext1 TEXT,\
ext2 TEXT,\
ext3 TEXT,\
ext4 TEXT,\
ext5 TEXT,\
PRIMARY KEY(gid, eid))"
#define     SQL_ADD_EXP           @"REPLACE INTO %@ ( gid, eid, name, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )"
#define     SQL_SELECT_EXPS        @"SELECT * FROM %@ WHERE gid = '%@'"
#define     FRIENDS_TABLE_NAME              @"friends"
#define     SQL_CREATE_FRIENDS_TABLE        @"CREATE TABLE IF NOT EXISTS %@(\
uid TEXT,\
fid TEXT,\
username TEXT,\
nikename TEXT, \
avatar TEXT,\
remark TEXT,\
ext1 TEXT,\
ext2 TEXT,\
ext3 TEXT,\
ext4 TEXT,\
ext5 TEXT,\
PRIMARY KEY(uid, fid))"
#define     SQL_UPDATE_FRIEND               @"REPLACE INTO %@ ( uid, fid, username, nikename, avatar, remark, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
#define     SQL_SELECT_FRIENDS              @"SELECT * FROM %@ WHERE uid = %@"
#define     SQL_DELETE_FRIEND               @"DELETE FROM %@ WHERE uid = '%@' and fid = '%@'"
#pragma mark - GROUPS
#define     GROUPS_TABLE_NAME               @"groups"
#define     SQL_CREATE_GROUPS_TABLE         @"CREATE TABLE IF NOT EXISTS %@(\
uid TEXT,\
gid TEXT,\
name TEXT,\
ext1 TEXT,\
ext2 TEXT,\
ext3 TEXT,\
ext4 TEXT,\
ext5 TEXT,\
PRIMARY KEY(uid, gid))"
#define     SQL_UPDATE_GROUP                @"REPLACE INTO %@ ( uid, gid, name, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? )"
#define     SQL_SELECT_GROUPS               @"SELECT * FROM %@ WHERE uid = %@"
#define     SQL_DELETE_GROUP                @"DELETE FROM %@ WHERE uid = '%@' and gid = '%@'"
#pragma mark - GROUP MEMBERS
#define     GROUP_MEMBER_TABLE_NAMGE            @"group_members"
#define     SQL_CREATE_GROUP_MEMBERS_TABLE      @"CREATE TABLE IF NOT EXISTS %@(\
uid TEXT,\
gid TEXT,\
fid TEXT,\
username TEXT,\
nikename TEXT, \
avatar TEXT,\
remark TEXT,\
ext1 TEXT,\
ext2 TEXT,\
ext3 TEXT,\
ext4 TEXT,\
ext5 TEXT,\
PRIMARY KEY(uid, gid, fid))"
#define     SQL_UPDATE_GROUP_MEMBER             @"REPLACE INTO %@ ( uid, gid, fid, username, nikename, avatar, remark, ext1, ext2, ext3, ext4, ext5) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
#define     SQL_SELECT_GROUP_MEMBERS            @"SELECT * FROM %@ WHERE uid = %@"
#define     SQL_DELETE_GROUP_MEMBER             @"DELETE FROM %@ WHERE uid = '%@' and gid = '%@' and fid = '%@'"
#endif /* TLDBMessageStoreSQL_h */
