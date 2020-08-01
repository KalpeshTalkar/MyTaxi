//
//  TaxiListViewModel.h
//  MyTaxiApp
//
//  Created by Kalpesh Talkar on 19/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

@class Taxi;
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaxiListViewModel : NSObject

@property NSArray <Taxi *> *taxiList;

- (instancetype _Nonnull)initWith:( NSArray<Taxi *> *_Nonnull) taxiList;

- (NSUInteger)totalTaxis;

- (Taxi *_Nonnull)getTaxiAt:(NSUInteger)index;


@end

NS_ASSUME_NONNULL_END
