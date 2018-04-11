//
//  HotCommentController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "HotCommentController.h"
#import "ArticleModel.h"
#import "ArticleApi.h"
#import "HPKViewController.h"

@interface HotCommentController ()
@property(nonatomic,weak,readwrite) __kindof HPKViewController *controller;
@property(nonatomic,strong,readwrite)HotCommentModel *hotCommentModel;
@property(nonatomic,strong,readwrite)HotCommentView *hotCommentView;
@property(nonatomic,strong,readwrite)ArticleApi *adApi;
@end

@implementation HotCommentController

- (void)pullToRefresh{
#warning later need a get model method
    
    __weak typeof(self) wself = self;
    _adApi = [[ArticleApi alloc]initWithApiType:kArticleApiTypeHotComment completionBlock:^(NSDictionary *responseDic, NSError *error) {
        
        //
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *arrayTmp = self.hotCommentModel.HotCommentArray.mutableCopy;
            
            for (NSString * comment in [responseDic objectForKey:@"hotComment"]) {
                [ arrayTmp addObject:[NSString stringWithFormat:@"%@-%@",comment,@(arrayTmp.count)]];
            }
            [wself.hotCommentModel setHotComments:arrayTmp.copy];
            
            CGPoint origin = [wself.hotCommentModel getComponentFrame].origin;
            
            [wself.hotCommentModel setComponentFrame:CGRectMake(origin.x, origin.y, [UIScreen mainScreen].bounds.size.width, arrayTmp.count * kHotCommentViewCellHeight)];
            
            [wself.controller reLayoutOutWebViewComponents];
            [wself.hotCommentView layoutWithData:wself.hotCommentModel];
            
            [wself.controller stopRefreshLoadingWithMoreData:arrayTmp.count<50];
        });
        
    }];
    

}

#pragma mark -
-(BOOL)shouldResponseWithComponentView:(__kindof UIView *)componentView
                         componentModel:(NSObject<RNSModelProtocol> *)componentModel{
    return [componentView class] == [HotCommentView class] && [componentModel class] == [HotCommentModel class];
}

- (void)controllerInit:(__kindof HPKViewController *)controller{
    _controller = controller;
}
- (void)controllerViewDidLoad:(__kindof HPKViewController *)controller{
    
}
- (void)controllerViewWillAppear:(__kindof HPKViewController *)controller{
    
}
- (void)controllerViewDidAppear:(__kindof HPKViewController *)controller{
    
}
- (void)controllerViewWillDisappear:(__kindof HPKViewController *)controller{
    
}
- (void)controllerViewDidDisappear:(__kindof HPKViewController *)controller{
    
}

//data
- (void)controller:(__kindof HPKViewController *)controller
    didReceiveData:(NSObject *)data{
    if([data isKindOfClass:[ArticleModel class]]){
        for (NSObject *component in ((ArticleModel *)data).outWebViewComponents) {
            if ([component isKindOfClass:[HotCommentModel class]]) {
                self.hotCommentModel = (HotCommentModel *)component;
                break;
            }
        }
    }
}

//webview
- (void)webViewDidFinishNavigation:(__kindof HPKWebView *)webView{
    
}
- (void)webViewDidShow:(__kindof HPKWebView *)webView{
    
}
- (void)webViewScrollViewDidScroll:(__kindof HPKWebView *)webView{
    
}

//component scroll
- (void)scrollViewWillDisplayComponentView:(__kindof UIView *)componentView
                            componentModel:(NSObject<RNSModelProtocol> *)componentModel{
    _hotCommentView = (HotCommentView *)componentView;
    [((HotCommentView *)componentView) layoutWithData:(HotCommentModel *)componentModel];
}

- (void)scrollViewEndDisplayComponentView:(__kindof UIView *)componentView
                           componentModel:(NSObject<RNSModelProtocol> *)componentModel{
}

- (void)scrollViewWillPrepareComponentView:(__kindof UIView *)componentView
                            componentModel:(NSObject<RNSModelProtocol> *)componentModel{
}

- (void)scrollViewEndPrepareComponentView:(__kindof UIView *)componentView
                           componentModel:(NSObject<RNSModelProtocol> *)componentModel{
}
@end
