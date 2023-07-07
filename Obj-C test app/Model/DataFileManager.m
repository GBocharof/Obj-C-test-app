//
//  DataFileManager.m
//  Obj-C test app
//
//  Created by Gleb Bocharov on 02.07.2023.
//

#import "DataFileManager.h"
#import "Character.h"

@implementation DataFileManager

+ (NSString *)getFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"saved_data.json"];
    return filePath;
}

+ (BOOL)saveData:(NSDictionary *)data toFileAtPath:(NSString *)filePath {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];

    if (error) {
        NSLog(@"Ошибка при преобразовании в JSON: %@", error);
        return NO;
    } else {
        return [jsonData writeToFile:filePath atomically:YES];
    }
}

+ (BOOL)removeDataAtFilePath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    
    if (!success) {
        NSLog(@"Ошибка при удалении данных из файла: %@", error);
    }
    
    return success;
}

+ (nullable NSDictionary *)loadDataFromFileAtPath:(NSString *)filePath {
    NSData *savedData = [NSData dataWithContentsOfFile:filePath];
    
    if (savedData) {
        NSError *jsonError = nil;
        NSDictionary *savedDataDict = [NSJSONSerialization JSONObjectWithData:savedData options:NSJSONReadingMutableContainers error:&jsonError];

        if (jsonError) {
            NSLog(@"Ошибка при чтении JSON: %@", jsonError);
            return nil;
        } else {
            return savedDataDict;
        }
    } else {
        return nil;
    }
}

+ (nullable NSArray *)loadCharactersFromFileAtPath:(NSString *)filePath {
    NSDictionary *savedData = [self loadDataFromFileAtPath:filePath];
    
    NSMutableArray *characters = NSMutableArray.array;
    
    if (savedData) {
        
        NSArray *savedCharacters = savedData[@"characters"];
        
        for (NSDictionary *characterDict in savedCharacters) {
            NSString *characterID = characterDict[@"id"];
            NSString *name = characterDict[@"name"];
            NSString *status = characterDict[@"status"];
            NSString *species = characterDict[@"species"];
            NSString *type = characterDict[@"type"];
            NSString *gender = characterDict[@"gender"];
            NSString *location = characterDict[@"location"];
            NSString *imageURLString = characterDict[@"imageURLString"];
            NSString *image = characterDict[@"image"];

            Character *character = [[Character alloc] initWithID:characterID name:name status:status species:species type:type gender:gender location:location imageURLString:imageURLString image:image];
            [characters addObject:character];
        }
    }
    return [characters copy];
}

+ (nullable NSString *)loadNextPageUrlStringFromFileAtPath:(NSString *)filePath {
    NSDictionary *savedData = [self loadDataFromFileAtPath:filePath];
    if (savedData) {
        return savedData[@"fileSettings"][@"nextPageUrlString"];
    } else {
        return nil;
    }
}

+ (void)saveDataToFile:(NSArray *)characters urlStr:(NSString *)nextPageUrlString {
    NSDictionary *fileSettings = @{
        @"nextPageUrlString" : nextPageUrlString
    };
    NSMutableArray *allCharacters = [NSMutableArray array];
    
    for (Character *character in characters) {
        NSDictionary *characterDict = @{
            @"id" : character.characterID,
            @"name" : character.name,
            @"status" : character.status,
            @"species" : character.species,
            @"type" : character.type,
            @"gender" : character.gender,
            @"location" : character.location,
            @"imageURLString" : character.imageURLString,
            @"image" : character.image
        };
        
        [allCharacters addObject:characterDict];
    }
    
    NSDictionary *finalData = @{
        @"fileSettings" : fileSettings,
        @"characters" : allCharacters
    };
    NSString *filePath = [self getFilePath];
    [self saveData:finalData toFileAtPath:filePath];
}

+ (nonnull NSString *)getDefaultPageUrlString {
    return @"https://rickandmortyapi.com/api/character";
}

@end
