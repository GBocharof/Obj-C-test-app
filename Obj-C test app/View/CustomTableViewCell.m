//
//  CustomTableViewCell.m
//  Obj-C test app
//
//  Created by Gleb Bocharov on 02.07.2023.
//

#import "CustomTableViewCell.h"
#import "Character.h"
#import "DataNetworkManager.h"

@implementation CustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImageView = [UIImageView new];
        self.avatarImageView.layer.cornerRadius = 30;
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.backgroundColor = UIColor.systemGray6Color;
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.avatarImageView];
        
        self.nameLabel = [UILabel new];
        self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.nameLabel];
        
        UILabel *statusLabel = [UILabel new];
        statusLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        statusLabel.text = @"Status:";
        statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.statusBackgroundView = [UIView new];
        self.statusBackgroundView.layer.cornerRadius = 10;
        self.statusBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.statusValueLabel = [UILabel new];
        self.statusValueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
        self.statusValueLabel.backgroundColor = UIColor.clearColor;
        self.statusValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.statusBackgroundView addSubview: self.statusValueLabel];
        
        self.statusStackView = [UIStackView new];
        self.statusStackView.axis = UILayoutConstraintAxisHorizontal;
        self.statusStackView.alignment = UIStackViewAlignmentCenter;
        self.statusStackView.spacing = 2.0;
        self.statusStackView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.statusStackView addArrangedSubview:statusLabel];
        [self.statusStackView addArrangedSubview:self.statusBackgroundView];
        [self.contentView addSubview:self.statusStackView];
        
        self.loaderView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        self.loaderView.hidesWhenStopped = YES;
        self.loaderView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.avatarImageView addSubview:self.loaderView];
        
        [self setConstraints];
    }
    return self;
}

- (void)setConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.avatarImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
        [self.avatarImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.avatarImageView.widthAnchor constraintEqualToConstant:60],
        [self.avatarImageView.heightAnchor constraintEqualToConstant:60]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.nameLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.avatarImageView.trailingAnchor constant:10],
        [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.statusStackView.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:5],
        [self.statusStackView.leadingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.statusBackgroundView.leadingAnchor constraintEqualToAnchor:self.statusValueLabel.leadingAnchor constant:-8],
        [self.statusBackgroundView.trailingAnchor constraintEqualToAnchor:self.statusValueLabel.trailingAnchor constant:8],
        [self.statusBackgroundView.topAnchor constraintEqualToAnchor:self.statusValueLabel.topAnchor constant:-1],
        [self.statusBackgroundView.bottomAnchor constraintEqualToAnchor:self.statusValueLabel.bottomAnchor constant:1]
        
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.loaderView.centerXAnchor constraintEqualToAnchor:self.avatarImageView.centerXAnchor],
        [self.loaderView.centerYAnchor constraintEqualToAnchor:self.avatarImageView.centerYAnchor]
    ]];
}

- (void)configureWith:(Character *)character and:(BOOL) spoilers {
    self.character = character;
    self.nameLabel.text = character.name;
    [self.statusStackView setHidden:YES];
    if (spoilers) {
        [self.statusStackView setHidden:NO];
    }
    self.statusValueLabel.text = @"";
    self.statusBackgroundView.backgroundColor = UIColor.systemBackgroundColor;
    self.avatarImageView.image = nil;
    [self.loaderView startAnimating];
    [self getImage:character];
}

- (void)getImage:(Character *)character {
    NSString *characterID = self.character.characterID;
    if (character.image.length == 0) {
        [DataNetworkManager loadImageInBase64StringFromUrl:character.imageURLString completion:^(NSString *base64Image){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (base64Image) {
                    character.image = base64Image;
                    [self setDataToCellFrom: character by: characterID];
                }
            });
        }];
    } else {
        [self setDataToCellFrom: character by: characterID];
    }
}

- (void)setDataToCellFrom:(Character *)character by:(NSString *)characterID {
    if ([characterID isEqual:self.character.characterID]) {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:character.image options:0];
        UIImage *image = [UIImage imageWithData:decodedData];
        if (image) {
            [self.loaderView stopAnimating];
            self.avatarImageView.image = image;
        }
        self.statusValueLabel.text = character.status;
        self.statusBackgroundView.backgroundColor = [self colorForStatus:character.status];
    }
}

- (UIColor *)colorForStatus:(NSString *)status {
    if ([status isEqualToString:@"Alive"]) {
        return UIColor.systemGreenColor;
    } else if ([status isEqualToString:@"Dead"]) {
        return UIColor.systemRedColor;
    } else {
        return UIColor.systemGray3Color;
    }
}

@end
