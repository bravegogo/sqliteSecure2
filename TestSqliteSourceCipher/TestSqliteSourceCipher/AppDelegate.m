//
//  AppDelegate.m
//  TestSqliteSourceCipher
//
//  Created by yanjing on 9/15/15.
//  Copyright (c) 2015 com. All rights reserved.
//

#import "AppDelegate.h"
#include "sqlite3.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    testdb();
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//工程中只加入 sqlite3secure.c ,但是其他的 sqlite文件要加入 工程目录下。

int testdb()
{
    int ret, i;
    sqlite3* db;
    ret = sqlite3_open("/Users/baidu/Desktop/test_db.db3", &db);
    printf(ret == SQLITE_OK ? "success.\n" : "failure.\n");
    
    ret = sqlite3_key(db, "abcdefghijklmnopqrstuvwxyz", 26);
    printf(ret == SQLITE_OK ? "success.\n" : "failure.\n");
    
    /*ret = sqlite3_rekey(db, "zyxwvutsrqponmlkjihgfedcba", 26);
     printf(ret == SQLITE_OK ? "success.\n" : "failure.\n");*/
    
    //#if 1
    ret = sqlite3_exec(db, "CREATE TABLE test_table(col1 varchar(10), col2 integer);", NULL, NULL, NULL);
    printf(ret == SQLITE_OK ? "success.\n" : "failure.\n");
    
    clock_t start, finish;
    double duration;
    
    start = clock();
    sqlite3_exec(db, "begin;", NULL, NULL, NULL);
    
    //#pragma omp parallel for
    for(i = 0; i< 10000; i++)
    {
        ret = sqlite3_exec(db, "INSERT INTO test_table VALUES('test_name', 1000);", NULL, NULL, NULL);
        //printf("thread id %d.\n", omp_get_thread_num());
        //printf(ret == SQLITE_OK ? "success.\n" : "failure.\n");
    }
    sqlite3_exec(db, "commit;", NULL, NULL, NULL);
    finish = clock();
    
    duration = (double)(finish - start);
    printf("%f ms.\n", duration);
    //#else
    
    ret = sqlite3_exec(db, "SELECT * FROM test_table;", print_result, NULL, NULL);
    printf(ret == SQLITE_OK ? "success.\n" : "failure.\n");
    //#endif
    
    sqlite3_close(db);
    
    int input;
    scanf("%d", &input);
    return 0;
}

int print_result(void* data, int n_columns, char** column_values, char** column_names)
{
    printf("name: %s.  num:%s \n", column_values[0],column_values[1]);
    return SQLITE_OK;
}

@end
