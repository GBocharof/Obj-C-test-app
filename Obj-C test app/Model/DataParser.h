//
//  DataParser.h
//  Obj-C test app
//
//  Created by Gleb Bocharov on 05.07.2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataParser : NSObject

+ (void)parseDataFromAPI:(NSString *)url completion:(void (^)(NSArray *, NSString *, BOOL error))completion;

@end

NS_ASSUME_NONNULL_END
