//
//  TaxiListVC.m
//  MyTaxiApp
//
//  Created by Kalpesh Talkar on 19/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

#import "TaxiListVC.h"
#import "TaxiListCell.h"

@interface TaxiListVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TaxiListVC

#pragma mark: - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
}

#pragma mark: - IBActions

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark: - UITableView setup

- (void)setupTable {
    [_tableView setEstimatedRowHeight:110];
    [_tableView setRowHeight:UITableViewAutomaticDimension];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TaxiListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TaxiListCell class])];
    _tableView.allowsSelection = true;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorColor = [UIColor clearColor];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
}

#pragma mark: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_listViewModel isEqual:nil]) {
        return 0;
    }
    return [_listViewModel totalTaxis];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaxiListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TaxiListCell class]) forIndexPath:indexPath];
    [cell display:[_listViewModel getTaxiAt:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.3 animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
