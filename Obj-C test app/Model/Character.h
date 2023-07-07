//
//  Character.h
//  Obj-C test app
//
//  Created by Gleb Bocharov on 01.07.2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Character : NSObject

@property (strong, nonatomic) NSString *characterID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *species;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *imageURLString;
@property (strong, nonatomic) NSString *image;

- (instancetype)initWithID:(NSString *)characterID
                      name:(NSString *)name
                    status:(NSString *)status
                   species:(NSString *)species
                      type:(NSString *)type
                    gender:(NSString *)gender
                  location:(NSString *)location
            imageURLString:(NSString *)imageURLString
                     image:(NSString *)image;

@end

NS_ASSUME_NONNULL_END
