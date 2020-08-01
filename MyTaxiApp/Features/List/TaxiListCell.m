//
//  TaxiListCell.m
//  MyTaxiApp
//
//  Created by Kalpesh Talkar on 19/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

#import "TaxiListCell.h"
#import <MyTaxiApp-Swift.h>

@interface TaxiListCell()

@property (weak, nonatomic) IBOutlet UIView *childView;
@property (weak, nonatomic) IBOutlet UILabel *taxiLabel;
@property (weak, nonatomic) IBOutlet UILabel *fleetTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *taxiImageView;

@end

@implementation TaxiListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_taxiImageView applyShadow:false];
    [_childView applyShadow:true];
    [_childView cornerRadiusWithRadius:[UIConstants margin]];
    _childView.backgroundColor = UIColor.whiteColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self animate:highlighted];
}

- (void)animate:(BOOL)selected {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = selected ? CGAffineTransformMakeScale(0.9, 0.9) : CGAffineTransformIdentity;
    }];
}

- (void)display:(Taxi *)taxi {
    _taxiLabel.text = @"Taxi";
    _fleetTypeLabel.text = [NSString stringWithFormat:@"Fleet type: %@", taxi.fleetType];
    _directionLabel.text = [NSString stringWithFormat:@"Heading: %@",[taxi getHeadingDirection]];
}

@end
