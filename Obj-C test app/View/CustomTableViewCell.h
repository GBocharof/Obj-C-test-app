//
//  CustomTableViewCell.h
//  Obj-C test app
//
//  Created by Gleb Bocharov on 02.07.2023.
//

#import <UIKit/UIKit.h>
#import "Character.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIActivityIndicatorView *loaderView;
@property (strong, nonatomic) UILabel *statusValueLabel;
@property (strong, nonatomic) UIStackView *statusStackView;
@property (strong, nonatomic) UIView *statusBackgroundView;
@property (strong, nonatomic, nullable) Character *character;

- (void)configureWith:(Character *)character and:(BOOL) spoilers;
- (void)setDataToCellFrom:(Character *)character by:(NSString *)characterID;
- (void)getImage:(Character *)character;

@end

NS_ASSUME_NONNULL_END
