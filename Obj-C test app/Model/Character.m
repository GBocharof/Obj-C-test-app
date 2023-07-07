//
//  Character.m
//  Obj-C test app
//
//  Created by Gleb Bocharov on 01.07.2023.
//

#import "Character.h"

@implementation Character

- (instancetype)initWithID:(NSString *)characterID
                      name:(NSString *)name
                    status:(NSString *)status
                   species:(NSString *)species
                      type:(NSString *)type
                    gender:(NSString *)gender
                  location:(NSString *)location
            imageURLString:(NSString *)imageURLString
                     image:(NSString *)image {
    self = [super init];
    if (self) {
        _characterID = characterID;
        _name = name;
        _status = status;
        _species = species;
        _type = type;
        _gender = gender;
        _location = location;
        _imageURLString = imageURLString;
        _image = image;
    }
    return self;
}

@end
