//
//  DataFileManager.h
//  Obj-C test app
//
//  Created by Gleb Bocharov on 02.07.2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataFileManager : NSObject

+ (NSString *)getFilePath;
+ (BOOL)saveData:(NSDictionary *)data toFileAtPath:(NSString *)filePath;
+ (BOOL)removeDataAtFilePath:(NSString *)filePath;
+ (nullable NSDictionary *)loadDataFromFileAtPath:(NSString *)filePath;
+ (nullable NSArray *)loadCharactersFromFileAtPath:(NSString *)filePath;
+ (nullable NSString *)loadNextPageUrlStringFromFileAtPath:(NSString *)filePath;
+ (void)saveDataToFile:(NSArray *)characters urlStr:(NSString *)nextPageUrlString;
+ (NSString *)getDefaultPageUrlString;

@end

NS_ASSUME_NONNULL_END
