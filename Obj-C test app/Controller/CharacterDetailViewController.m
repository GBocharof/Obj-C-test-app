//
//  CharacterDetailViewController.m
//  Obj-C test app
//
//  Created by Gleb Bocharov on 03.07.2023.
//

#import "CharacterDetailViewController.h"

@interface CharacterDetailViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIStackView *stackView;
@property (strong, nonatomic) UIView *statusBarView;
@property (strong, nonatomic) UILabel *statusTextLabel;

@end

@implementation CharacterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UIImage *buttonImage = [UIImage systemImageNamed:@"chevron.left"];
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.closeButton setImage:buttonImage forState:UIControlStateNormal];
    [self.closeButton setTitle:@"Back" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    self.imageView = [UIImageView new];
    self.imageView.backgroundColor = UIColor.systemBackgroundColor;
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:self.character.image options:0];
    self.imageView.image = [UIImage imageWithData:decodedData];
    [self.view addSubview:self.imageView];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.text = self.character.name;
    self.nameLabel.font = [UIFont preferredFontForTextStyle: UIFontTextStyleTitle1];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.nameLabel];
    
    [self addStacks];
    [self setConstraints];
}

- (void)addStacks {
    NSString *status = self.spoilers ? self.character.status : @"*spoilers off*";
    NSArray *labels = @[@"Status: ", @"Species: ", @"Type: ", @"Gender: ", @"Location: "];
    NSArray *values = @[status, self.character.species, self.character.type, self.character.gender, self.character.location];
    NSMutableArray *stackViews = [NSMutableArray array];
    
    for (NSInteger i = 0; i < labels.count; i++) {
        NSString *currentValue = values[i];
        if (currentValue.length == 0) {
            continue;
        }
        UILabel *label = [UILabel new];
        label.text = labels[i];
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

        UILabel *valueLabel = [UILabel new];
        valueLabel.text = currentValue;
        valueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        valueLabel.numberOfLines = 0;

        UIStackView *stackView = [UIStackView new];
        stackView.axis = UILayoutConstraintAxisHorizontal;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 5.0;
        [stackView addArrangedSubview:label];
        [stackView addArrangedSubview:valueLabel];
        [stackViews addObject:stackView];
    }
    
    self.stackView = [UIStackView new];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.alignment = UIStackViewAlignmentLeading;
    self.stackView.spacing = 8.0;
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;

    for (UIStackView *stackView in stackViews) {
        [self.stackView addArrangedSubview:stackView];
    }
    [self.view addSubview:self.stackView];
}

- (void)setConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.closeButton.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:10],
        [self.closeButton.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10]
    ]];

    [NSLayoutConstraint activateConstraints:@[
        [self.nameLabel.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [self.nameLabel.topAnchor constraintEqualToAnchor:self.closeButton.bottomAnchor constant:10],
        [self.nameLabel.widthAnchor constraintLessThanOrEqualToAnchor:self.view.widthAnchor constant:-20]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:10],
        [self.imageView.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:10],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-10]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:15],
        [self.stackView.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:10],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-10],
        [self.stackView.widthAnchor constraintLessThanOrEqualToAnchor:self.view.widthAnchor constant:-20]
    ]];
}

- (void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
