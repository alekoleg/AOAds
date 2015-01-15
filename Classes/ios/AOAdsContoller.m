//
//  AOAdsContoller.m
//  
//
//  Created by Alek Oleg on 17.11.13.
//
//

#import "AOAdsContoller.h"
#import "AOAdsView.h"
#import <AOInfoNetManager.h>
#import <AOAdsModel.h>

static AOAdsContoller *_contoler = nil;

NSString * const kSavedObjectIds = @"savedObjectId";

@implementation AOAdsContoller {
    dispatch_queue_t _query;
}

+ (instancetype)sharedContoller {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _contoler = [[AOAdsContoller alloc]init];

    });
    return _contoler;
}

+ (void)checkCompanies {
    [[AOAdsContoller sharedContoller]checkCompanies];
}

//============================================================================================
#pragma mark - Init -
//--------------------------------------------------------------------------------------------

- (id)init {
    if (self = [super init]) {
        _query = dispatch_queue_create("com.alekoleg.ads", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

//============================================================================================
#pragma mark - Actions -
//--------------------------------------------------------------------------------------------
- (void)checkCompanies {
    
    dispatch_async(_query, ^{
        NSArray *objectsIds = [[NSUserDefaults standardUserDefaults]valueForKey:kSavedObjectIds];
       
        [[AOInfoNetManager sharedManager] getAdsWithSuccess:^(NSArray *objects) {
            for (AOAdsModel *model in objects) {
                if ((objectsIds && ![objectsIds containsObject:model.objectId]) || !objectsIds) {
                    [self showCompany:model];
                    return;
                }
            }
        } fail:NULL];
    });
}

- (void)showCompany:(AOAdsModel *)object {
    
    NSString *link = object.link;
    NSURL *url = [NSURL URLWithString:link];
    if (object.schemeLink) {
        NSURL *deepUrl = [NSURL URLWithString:object.schemeLink];
        if ([[UIApplication sharedApplication]canOpenURL:deepUrl]) {
            url = deepUrl;
        }
    }
    [[AOInfoNetManager sharedManager] loadImagesFromLinks:object.links success:^(NSArray *images) {
        if (images.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                AOAdsView *view = [AOAdsView showAdsViewWithImages:images andLink:url];
                if (object.buttonTitle.length > 0) {
                    [view.showButton setTitle:object.buttonTitle forState:UIControlStateNormal];
                }
                view.shouldShare = object.shouldShare.boolValue;
            });
            
            NSMutableArray *objectsIds = [[[NSUserDefaults standardUserDefaults]valueForKey:kSavedObjectIds]mutableCopy];
            if (!objectsIds) {
                objectsIds = [NSMutableArray array];
            }
            [objectsIds addObject:object.objectId];
            [[NSUserDefaults standardUserDefaults]setValue:objectsIds forKey:kSavedObjectIds];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    } fail:NULL];
}



@end
