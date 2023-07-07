//
//  ViewController.m
//  Obj-C test app
//
//  Created by Gleb Bocharov on 30.06.2023.
//

#import "ViewController.h"
#import "Character.h"
#import "CustomTableViewCell.h"
#import "DataFileManager.h"
#import "CharacterDetailViewController.h"
#import "DataParser.h"

@interface ViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) BOOL isFetchingNextPage;
@property (strong, nonatomic) NSMutableArray *characters;
@property (strong, nonatomic) NSString *nextPageUrlString;
@property (assign, nonatomic) BOOL spoilers;
@property (strong, nonatomic) UISwitch *spoilersSwitch;
@property (strong, nonatomic) UILabel *networkErrorLabel;
@property (strong, nonatomic) NSLayoutConstraint *networkErrorLabelHeight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.characters = NSMutableArray.array;
    self.nextPageUrlString = nil;
    [self setupTableView];
    [self setupNetworkErrorLabel];
    [self setConstraints];
    [self loadSettingsFromFile];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveDefaults];
    [DataFileManager saveDataToFile:self.characters urlStr:self.nextPageUrlString];
}

- (void)saveDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.spoilers forKey:@"SpoilersEnabled"];
    [defaults synchronize];
}

- (void)setupTableView {
    UIBarButtonItem *rebootButton = [[UIBarButtonItem alloc] initWithTitle:@"Reboot" style:UIBarButtonItemStyleDone target:self action:@selector(rebootButtonTapped)];
    self.navigationItem.rightBarButtonItem = rebootButton;
    
    self.spoilersSwitch = [UISwitch new];
    [self.spoilersSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *spoilersLabel = [UILabel new];
    spoilersLabel.text = @"Spoilers";
    
    UIStackView *spoilersStack = [UIStackView new];
    spoilersStack.axis = UILayoutConstraintAxisHorizontal;
    spoilersStack.alignment = UIStackViewAlignmentFill;
    spoilersStack.distribution = UIStackViewDistributionFill;
    spoilersStack.spacing = 8.0;
    [spoilersStack addArrangedSubview:self.spoilersSwitch];
    [spoilersStack addArrangedSubview:spoilersLabel];
    
    UIBarButtonItem *spoilersItem = [[UIBarButtonItem alloc] initWithCustomView:spoilersStack];
    self.navigationItem.leftBarButtonItem = spoilersItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)loadData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.spoilers = [defaults boolForKey:@"SpoilersEnabled"];
    [self.spoilersSwitch setOn:self.spoilers];
    [self loadCharactersFromFileAndUpdateTable];
    if (self.characters.count == 0) {
        [self fetchPageAndReloadTable];
    }
}
- (void)loadSettingsFromFile {
    NSString *filePath = [DataFileManager getFilePath];
    self.nextPageUrlString = [DataFileManager loadNextPageUrlStringFromFileAtPath:filePath];
    self.nextPageUrlString = !self.nextPageUrlString ? [DataFileManager getDefaultPageUrlString] : self.nextPageUrlString;
}

- (void)loadCharactersFromFileAndUpdateTable {
    NSString *filePath = [DataFileManager getFilePath];
    [self.characters addObjectsFromArray:[DataFileManager loadCharactersFromFileAtPath:filePath]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)setConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.topAnchor constraintEqualToAnchor:self.networkErrorLabel.bottomAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
    
    self.networkErrorLabelHeight = [self.networkErrorLabel.heightAnchor constraintEqualToConstant:0];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.networkErrorLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.networkErrorLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.networkErrorLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        self.networkErrorLabelHeight
    ]];
}

- (void)fetchPageAndReloadTable {
    self.isFetchingNextPage = YES;
    [DataParser parseDataFromAPI:self.nextPageUrlString completion:^(NSArray *characters, NSString *nextPageUrlString, BOOL error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (characters) {
                [self.characters addObjectsFromArray: characters];
                self.nextPageUrlString = nextPageUrlString;
                [self.tableView reloadData];
            }
            [self showNetworkErrorView:error];
        });
        self.isFetchingNextPage = NO;
    }];
}

- (void)rebootButtonTapped {
    NSString *filePath = [DataFileManager getFilePath];
    [DataFileManager removeDataAtFilePath:filePath];
    self.characters = NSMutableArray.array;
    self.nextPageUrlString = [DataFileManager getDefaultPageUrlString];
    self.spoilers = NO;
    [self.spoilersSwitch setOn: self.spoilers];
    [self saveDefaults];
    [self.tableView reloadData];
    [self fetchPageAndReloadTable];
}

- (void)switchValueChanged:(UISwitch *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.spoilers = sender.isOn;
        [self.tableView reloadData];
    });
}

- (void)setupNetworkErrorLabel {
    self.networkErrorLabel = [UILabel new];
    self.networkErrorLabel.text = @"Network error, check your internet connection";
    self.networkErrorLabel.textAlignment = NSTextAlignmentCenter;
    self.networkErrorLabel.textColor = UIColor.whiteColor;
    self.networkErrorLabel.backgroundColor = UIColor.systemRedColor;
    self.networkErrorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.networkErrorLabel];
}

- (void)showNetworkErrorView:(BOOL)showLabel {
    long constant = self.networkErrorLabelHeight.constant;
    if (showLabel) {
        self.networkErrorLabelHeight.constant = 30;
    } else {
        self.networkErrorLabelHeight.constant = 0;
    }
    
    if (constant != self.networkErrorLabelHeight.constant) {
        [UIView animateWithDuration:1 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.characters.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CustomCell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Character *character = self.characters[indexPath.row];
    
    [cell configureWith:character and: self.spoilers];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.characters.count - 1 && !self.isFetchingNextPage) {
        [self fetchPageAndReloadTable];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Character *selectedCharacter = self.characters[indexPath.row];
    
    CharacterDetailViewController *detailViewController = [CharacterDetailViewController new];
    detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    detailViewController.character = selectedCharacter;
    detailViewController.spoilers = self.spoilers;
    [self.navigationController presentViewController:detailViewController animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
