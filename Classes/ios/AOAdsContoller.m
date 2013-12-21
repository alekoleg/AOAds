//
//  AOAdsContoller.m
//  
//
//  Created by Alek Oleg on 17.11.13.
//
//

#import "AOAdsContoller.h"
#import <Parse/Parse.h>
#import "AOAdsView.h"
static AOAdsContoller *_contoler = nil;

NSString * const kIphoneImages = @"images";
NSString * const kIpadImages = @"ipadImages";
NSString * const kPromoteLink = @"PromoteLink";
NSString * const kShouldPromote = @"shouldPromote";
NSString * const kObjectId = @"objetcId";
NSString * const kSavedObjectIds = @"savedObjectId";
NSString * const kImageFirst = @"image1";
NSString * const kImageSecond = @"image2";
NSString * const kImageThird = @"image3";

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
        
        PFQuery *query = [[PFQuery alloc]initWithClassName:@"Ads"];
        [query whereKey:kShouldPromote equalTo:@YES];
        NSError *error = nil;
        NSArray *runnigCompanies = [query findObjects:&error];
        if (error) {
            NSLog(@"%@", error.description);
        }
        [runnigCompanies enumerateObjectsUsingBlock:^(PFObject *obj, NSUInteger idx, BOOL *stop) {
            if ((objectsIds && ![objectsIds containsObject:obj.objectId]) || !objectsIds) {
                [self showCompany:obj];
                return ;
            }
        }];
    });
}

- (void)showCompany:(PFObject *)object {
    NSString *link = [object valueForKey:kPromoteLink];
    NSURL *url = [NSURL URLWithString:link];
    PFRelation *relaction = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [object relationforKey:kIpadImages]:[object relationforKey:kIphoneImages];
    NSError *error = nil;
    PFObject *imageObject = [[relaction query]getFirstObject:&error];
    if (error) {
        NSLog(@"%@", error.description);
    }
    NSMutableArray *images = [NSMutableArray array];
    [self addImageFrom:imageObject[kImageFirst] toArray:images];
    [self addImageFrom:imageObject[kImageSecond] toArray:images];
    [self addImageFrom:imageObject[kImageThird] toArray:images];
    
    if (images.count > 0 && url) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [AOAdsView showAdsViewWithImages:images andLink:url];
        });

        NSMutableArray *objectsIds = [[[NSUserDefaults standardUserDefaults]valueForKey:kSavedObjectIds]mutableCopy];
        if (!objectsIds) {
            objectsIds = [NSMutableArray array];
        }
        [objectsIds addObject:object.objectId];
        [[NSUserDefaults standardUserDefaults]setValue:objectsIds forKey:kSavedObjectIds];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (void)addImageFrom:(PFFile *)file toArray:(NSMutableArray *)array {
    if (file) {
        NSData *data = [file getData];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            [array addObject:image];
        }
    }
}


@end
