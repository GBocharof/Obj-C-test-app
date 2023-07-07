//
//  DataNetworkManager.m
//  Obj-C test app
//
//  Created by Gleb Bocharov on 02.07.2023.
//

#import "DataNetworkManager.h"

@implementation DataNetworkManager

+ (void)loadDataFromAPIForURL:(NSString *)url completion:(void (^)(NSDictionary *jsonData, BOOL error))completion {
    if (url == (id)[NSNull null]) {
        completion(nil, NO);
        return;
    }
    NSURL *apiURL = [NSURL URLWithString:url];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:apiURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Ошибка при выполнении запроса: %@", error);
            completion(nil, YES);
        } else {
            NSError *jsonError = nil;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if (jsonError) {
                NSLog(@"Ошибка при разборе JSON: %@", jsonError);
                completion(nil, YES);
            } else {
                completion(jsonData, NO);
            }
        }
    }];
    [task resume];
}

+ (void)loadImageInBase64StringFromUrl:(NSString *)url completion:(void (^)(NSString *base64Image))completion {
    NSURL *imageURL = [NSURL URLWithString:url];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Ошибка при загрузке изображения: %@", error);
            completion(nil);
        } else {
            NSString *base64String = [data base64EncodedStringWithOptions:0];
            completion(base64String);
        }
    }];
    [task resume];
}

@end
