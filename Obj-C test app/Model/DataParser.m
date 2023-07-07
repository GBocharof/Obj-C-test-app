//
//  DataParser.m
//  Obj-C test app
//
//  Created by Gleb Bocharov on 05.07.2023.
//

#import "DataParser.h"
#import "DataNetworkManager.h"
#import "Character.h"

@implementation DataParser

+ (void)parseDataFromAPI:(NSString *)url completion:(void (^)(NSArray *, NSString *, BOOL error))completion {
    [DataNetworkManager loadDataFromAPIForURL:url completion:^(NSDictionary *data, BOOL error){
        if (data) {
            NSArray *results = data[@"results"];
            NSDictionary *info = data[@"info"];
            NSString *nextPageUrlString = info[@"next"];
            NSMutableArray *characters = NSMutableArray.array;
            
            for (NSDictionary *characterDict in results) {
                NSString *characterID = characterDict[@"id"];
                NSString *name = characterDict[@"name"];
                NSString *status = characterDict[@"status"];
                NSString *species = characterDict[@"species"];
                NSString *type = characterDict[@"type"];
                NSString *gender = characterDict[@"gender"];
                NSDictionary *locationDict = characterDict[@"location"];
                NSString *location = locationDict[@"name"];
                NSString *imageURLString = characterDict[@"image"];
                
                Character *character = [[Character alloc] initWithID:characterID name:name status:status species:species type:type gender:gender location:location imageURLString:imageURLString image:@""];
                [characters addObject:character];
            }
            if (completion) {
                completion(characters, nextPageUrlString, error);
            }
        } else {
            completion(nil, nil, error);
        };
    }];
}

@end
