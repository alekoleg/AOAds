
//
//  AOAdsView.h
//  Чтения
//
//  Created by Alek Oleg on 17.11.13.
//  Copyright (c) 2013 ЕАД. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AOAdsView : UIView

+ (instancetype)showAdsViewWithImages:(NSArray *)images andLink:(NSURL *)url;

@property (nonatomic, assign) BOOL shouldShare;
@property (nonatomic, strong) UIButton *showButton;

@end
