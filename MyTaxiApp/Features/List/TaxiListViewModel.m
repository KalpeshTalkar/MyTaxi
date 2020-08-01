//
//  TaxiListViewModel.m
//  MyTaxiApp
//
//  Created by Kalpesh Talkar on 19/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

#import "TaxiListViewModel.h"

@implementation TaxiListViewModel

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWith:(NSArray<Taxi *> *)taxiList {
    self = [super init];
    _taxiList = [NSArray new];
    if (self) {
        _taxiList = taxiList;
    }
    return self;
}

- (NSUInteger)totalTaxis {
    return _taxiList.count;
}

- (Taxi *)getTaxiAt:(NSUInteger)index {
    return [_taxiList objectAtIndex:index];
}

@end
