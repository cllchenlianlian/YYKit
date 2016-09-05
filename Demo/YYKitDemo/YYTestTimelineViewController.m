//
//  YYTestTimelineViewController.m
//  YYKitDemo
//
//  Created by DMW_W on 16/8/25.
//  Copyright © 2016年 ibireme. All rights reserved.
//

#import "YYTestTimelineViewController.h"
#import "YYKit.h"
#import "YYFPSLabel.h"
#import "YYTableView.h"
#import "ZKNearCollectionCell.h"
#import "YYTestModel.h"
@interface YYTestTimelineViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray    *layouts;
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) YYFPSLabel        *fpsLabel;

@end

@implementation YYTestTimelineViewController

- (instancetype)init {
    self = [super init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = ( [UIScreen mainScreen].bounds.size.width - 8 ) / 3;
    CGFloat height = width / 112 * 160;
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    return self;
}
- (NSMutableArray *)layouts {
    if (_layouts == nil) {
        _layouts = [NSMutableArray array];
    }
    return _layouts;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.919];
    
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _collectionView.frame = self.view.bounds;
    _collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _collectionView.scrollIndicatorInsets = _collectionView.contentInset;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"EDEDEC"];
    _collectionView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[ZKNearCollectionCell class] forCellWithReuseIdentifier:@"YYTestTableViewCell"];
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = self.view.height - 8;
    _fpsLabel.left = 8;
    _fpsLabel.alpha = 0;
    [self.view addSubview:_fpsLabel];
    
    self.navigationController.view.userInteractionEnabled = NO;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.size = CGSizeMake(80, 80);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"nearBy.json" ofType:nil];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *arr = dict[@"data"][@"list"];
        arr = [NSArray yy_modelArrayWithClass:[YYTestModel class] json:arr];
        for (YYTestModel *model in arr) {
            [self.layouts addObject:[[ZKNeaStatusLayout alloc]initWithModel:model]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = [NSString stringWithFormat:@"Weibo (loaded:%d)", (int)_layouts.count];
            [indicator removeFromSuperview];
            self.navigationController.view.userInteractionEnabled = YES;
            [_collectionView reloadData];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.layouts.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZKNearCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YYTestTableViewCell" forIndexPath:indexPath];
    [cell setLayout:[self.layouts objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
}

#pragma mark - scrollView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:NULL];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        if (_fpsLabel.alpha != 0) {
            [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                _fpsLabel.alpha = 0;
            } completion:NULL];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha != 0) {
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 0;
        } completion:NULL];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (_fpsLabel.alpha == 0) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _fpsLabel.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [[cache memoryCache] removeAllObjects];
    [[cache diskCache] removeAllObjects];
}

@end
