//
//  CharacterDetailViewController.h
//  Obj-C test app
//
//  Created by Gleb Bocharov on 03.07.2023.
//

#import <UIKit/UIKit.h>
#import "Character.h"

NS_ASSUME_NONNULL_BEGIN

@interface CharacterDetailViewController : UIViewController

@property (strong, nonatomic) Character *character;
@property (assign, nonatomic) BOOL spoilers;

@end

NS_ASSUME_NONNULL_END
