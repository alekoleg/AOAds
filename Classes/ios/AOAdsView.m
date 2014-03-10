//
//  AOAdsView.m
//  Чтения
//
//  Created by Alek Oleg on 17.11.13.
//  Copyright (c) 2013 ЕАД. All rights reserved.
//

#import "AOAdsView.h"
#define AOAdsIsiOS7 ([[[UIDevice currentDevice]systemVersion]floatValue] > 6.9)


@interface AOAdsView () <UIScrollViewDelegate> {
    NSURL *_url ;
    NSArray *_images;
}

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *hideButton;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControll;
@end

@implementation AOAdsView

+ (instancetype)showAdsViewWithImages:(NSArray *)images andLink:(NSURL *)url {
    if (images.count > 0) {
       AOAdsView *view = [[AOAdsView alloc]initWithImage:images andUrl:url];
        [view show];
        return view;
    }
    return nil;
}

- (id)initWithImage:(NSArray *)images andUrl:(NSURL *)url {
    if (self = [super init]) {
        _images = images;
        _url = url;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [self setupForIpad];
        } else {
            [self setupForIphone];
        }
    }
    return self;
}

//============================================================================================
#pragma mark - Setup -
//--------------------------------------------------------------------------------------------
- (void)setupForIphone {
    CGSize size = [[[[UIApplication sharedApplication]keyWindow]rootViewController]view].bounds.size;
    self.frame = CGRectMake(0, 0, size.width, size.height);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, AOAdsIsiOS7 * 20 , self.frame.size.width, self.frame.size.height - AOAdsIsiOS7 * 20)];
    [self addSubview:_containerView];
    [self setupContent];
}

- (void)setupForIpad {
    CGSize size = [[[[UIApplication sharedApplication]keyWindow]rootViewController]view] .bounds.size;    
    self.frame = CGRectMake(0, 0, size.width, size.height);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.contentMode = UIViewContentModeCenter;
    
    _containerView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.5 - 300, self.frame.size.height * 0.5 - 300, 600, 600)];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [self addSubview:_containerView];
    [self setupContent];
}

- (void)setupContent {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 5, _containerView.frame.size.width, _containerView.frame.size.height - 4 - 44 * ([[_url absoluteString]length] > 0))];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * _images.count, _scrollView.contentSize.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [_containerView addSubview:_scrollView];
    [self setupImages];
    
    _pageControll = [[UIPageControl alloc]initWithFrame:CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y + _scrollView.frame.size.height - 36,  _scrollView.frame.size.width, 36)];
    _pageControll.currentPage = 0;
    _pageControll.numberOfPages = _images.count;
    [_containerView addSubview:_pageControll];
    
    _hideButton = [[UIButton alloc]initWithFrame:CGRectMake(_containerView.frame.size.width - 45, 5, 44, 44)];
    _hideButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_hideButton setImage:[UIImage imageNamed:@"AOAdsCancel"] forState:UIControlStateNormal];
    [_hideButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    _hideButton.layer.cornerRadius = 22;
    [_containerView addSubview:_hideButton];
    
    if (_url) {
        _showButton = [[UIButton alloc]initWithFrame:CGRectMake(0, _containerView.frame.size.height - 44, _containerView.frame.size.width, 44)];
        _showButton.backgroundColor = [UIColor colorWithRed:0 green:0.65 blue:1 alpha:1];
        [_showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showButton setTitle:@"Просмотр" forState:UIControlStateNormal];
        [_showButton addTarget:self action:@selector(openURL) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_showButton];
    }
}

- (void)setupImages {
    [_images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(idx * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.image = image;
        [_scrollView addSubview:view];
    }];
}

- (void)layoutSubviews {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _containerView.frame = ({
            CGRect frame = _containerView.frame;
            frame.origin.x = (self.frame.size.width - frame.size.width ) * 0.5;
            frame.origin.y = (self.frame.size.height - frame.size.height) * 0.5;
            frame;
        });
    }
}
- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show {
    self.alpha = 0.0;
    [[[[[UIApplication sharedApplication]keyWindow]rootViewController]view] addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)openURL {
    if (_shouldShare) {
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:@[_url] applicationActivities:nil];
        vc.completionHandler = ^(NSString *type, BOOL result) {
            [self hide];
        };
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:NULL];
    } else  {
        [[UIApplication sharedApplication]openURL:_url];
        [self hide];
    }
}

//============================================================================================
#pragma mark - Variables -
//--------------------------------------------------------------------------------------------

//============================================================================================
#pragma mark - UIScrollView Delegate -
//--------------------------------------------------------------------------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControll.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}
@end
