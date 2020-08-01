//
//  TaxiListCell.h
//  MyTaxiApp
//
//  Created by Kalpesh Talkar on 19/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Taxi;

NS_ASSUME_NONNULL_BEGIN

@interface TaxiListCell : UITableViewCell

- (void)display:(Taxi * _Nonnull)taxi;

@end

NS_ASSUME_NONNULL_END
