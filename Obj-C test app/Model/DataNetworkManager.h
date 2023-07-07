//
//  DataNetworkManager.h
//  Obj-C test app
//
//  Created by Gleb Bocharov on 02.07.2023.
//

#import <Foundation/Foundation.h>
#import "Character.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataNetworkManager : NSObject

+ (void)loadDataFromAPIForURL:(NSString *)url completion:(void (^)(NSDictionary *jsonData, BOOL error))completion;
+ (void)loadImageInBase64StringFromUrl:(NSString *)url completion:(void (^)(NSString *base64Image))completion;

@end

NS_ASSUME_NONNULL_END
