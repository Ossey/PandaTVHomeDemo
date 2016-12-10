//
//  XYChannelCategoryController.m
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  频道分类控制器

#import "XYChannelCategoryController.h"
#import "XYNetworkRequest.h"
#import "XYRearrangeView.h"

static NSString *const XYChannelCategoryInitialKey = @"XYChannelCategoryInitialKey";

@interface XYChannelCategoryController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;

/** 子分类组模型数组 */ /** 默认的模型数据都放在中 */
@property (nonatomic, strong) NSMutableArray *subcateGroups;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *firstSection;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *secondSection;
@property (nonatomic, strong) NSArray *sectionHeaderTitles;

@property (nonatomic, strong) XYChannelCategoryLayout *layout;
@property (nonatomic, copy) NSString *subcatePath;
@end

@implementation XYChannelCategoryController


static NSString *const cellIdentifier = @"XYChannelCategoryCell";
static NSString *const headerIdentifier = @"XYChannelCategoryHeaderView";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

- (void)setup {
    
    self.title = @"频道选择";
    
    [self.collectionView registerClass:[XYChannelCategoryCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[XYChannelCategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView xy_rollViewOriginalDataBlock:^NSArray *{
        
        return weakSelf.subcateGroups;
    } callBlckNewDataBlock:^(NSArray *newData, NSIndexPath *relocatedIndexPath) {
        __strong typeof(self) strongSelf = weakSelf;
        /// 将新数据保存到内存缓存中
        strongSelf.subcateGroups = [newData mutableCopy];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [newData writeToFile:strongSelf.subcatePath atomically:YES];
        });
    }];
    
    self.collectionView.autoRollCellSpeed = 20;
    
    [self loadSubcates];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backEvent) name:XYVCPopNotification object:nil];
    
}

- (void)loadSubcates {
    
    
    /// 先从plist中查找，如果有就直接使用plist中的
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:self.subcatePath];
    
    
    if ([dataArr[0] count]) {
        
        [self transformationModel:dataArr];
    } else {
        
        [self loadSubcatesFromNetwork];
    }
    
}

- (void)loadSubcatesFromNetwork {
    
    NSString *url = @"http://api.m.panda.tv/ajax_get_all_subcate?__version=2.1.3.1428&__plat=ios&__channel=appstore&pt_sign=eb36e0e0e82ee50c2406c6ae92f2cbc4&pt_time=1481166805";
    
    [[XYNetworkRequest shareInstance] request:XYNetworkRequestTypeGET url:url parameters:nil progress:nil finished:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error.debugDescription);
            /// 网络加载失败时从plist中加载数据
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"subcate.plist" ofType:nil];
            NSArray *dataArr = [NSArray arrayWithContentsOfFile:filePath];
            [self.subcateGroups removeAllObjects];
            [self transformationModel:dataArr];
            
            return;
        }
        
        /// 网络正常时从网络加载数据
        NSArray *dataArr = responseObject[@"data"];
        [self transformationModel:dataArr];
        
    }];
}

/// 将数组转换为模型
- (void)transformationModel:(NSArray *)dataArr {
    
    
    /// 由于第一次进入启动程序时，从服务器下载的数据dataArr中是字典，所以第一次启动程序时要对数据进行处理 只有第一次启动程序的时候才将前5个添加到第一组中，这里在偏好设置中存储一个key，能取出key的值时就说明不是第一次启动程序，取不出key就是第一次
    
    NSString *initialObj = [[NSUserDefaults standardUserDefaults] objectForKey:XYChannelCategoryInitialKey];
    if (!initialObj || [initialObj isEqualToString:@""]) {
        for (NSInteger i = 0; i < dataArr.count; ++i) {
            if (i < 5) {
                [self.firstSection addObject:dataArr[i]];
            } else {
                [self.secondSection addObject:dataArr[i]];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:@"initialObj" forKey:XYChannelCategoryInitialKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        NSInteger i = 0;
        for (id data in dataArr) {

            if ([data isKindOfClass:[NSArray class]] && i == 0) {
                [self.firstSection addObjectsFromArray:data];
            }
            
            if ([data isKindOfClass:[NSArray class]] && i == 1) {
                [self.secondSection addObjectsFromArray:data];
            }
            
            i++;
        }
        
    }
    
    [self.subcateGroups addObject:self.firstSection];
    [self.subcateGroups addObject:self.secondSection];
    
    [self.collectionView reloadData];
    
    /// 写入到plist
    [self.subcateGroups writeToFile:self.subcatePath atomically:YES];

}

#pragma mark - Events
- (void)backEvent {
    
    /// 将第一组的数据传递给HomePage，让HomePage根据数据创建对应的子控制器
    if (self.delegate && [self.delegate respondsToSelector:@selector(channelCategoryControllerWithCateTitles:)]) {
        [self.delegate channelCategoryControllerWithCateTitles:self.firstSection];
    }
}

#pragma mark - collectionView的代理和数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.subcateGroups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *arrray = self.subcateGroups[section];
    return arrray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYChannelCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    if (indexPath.section == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:57/255.0 green:217/255.0 blue:146/255.0 alpha:1.0];
        cell.label.textColor = [UIColor whiteColor];
    } else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.label.textColor = [UIColor blackColor];
    }
    
    /// 取出模型
    NSArray *arrray = self.subcateGroups[indexPath.section];
    cell.subcate = arrray[indexPath.row];
    
    return cell;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    /// 头部视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XYChannelCategoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];

        headerView.sectionHeaderTitle = self.sectionHeaderTitles[indexPath.section];
        return headerView;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        [self.secondSection addObject:self.firstSection[indexPath.row]];
        [self.firstSection removeObjectAtIndex:indexPath.row];
        
    } else if (indexPath.section == 1) {
        [self.firstSection addObject:self.secondSection[indexPath.row]];
        [self.secondSection removeObjectAtIndex:indexPath.row];
    }
    
    [collectionView reloadData];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.subcateGroups writeToFile:self.subcatePath atomically:YES];
    });
}


#pragma mark - UICollectionViewDelegateFlowLayout

static CGFloat const cellMarginV = 10;

/// 返回每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellW = (CGRectGetWidth(collectionView.frame) - 4 * cellMarginV) / 4;
    CGFloat cellH = 35;
    return CGSizeMake(cellW, cellH);
}


/// 返回每个cell的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(5, cellMarginV, 5, cellMarginV);
}


#pragma mark set \ get

- (NSArray *)sectionHeaderTitles {
    return @[@"常用频道(长按可以拖动调整频道顺序,点击删除)",@"所有频道(点击添加您感兴趣的频道)"];
}

- (XYChannelCategoryLayout *)layout {
    if (_layout == nil) {
        _layout = [[XYChannelCategoryLayout alloc] init];
    }
    return _layout;
}

- (NSMutableArray *)firstSection {
    if (_firstSection == nil) {
        _firstSection = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _firstSection;
}

- (NSMutableArray *)secondSection {
    if (_secondSection == nil) {
        _secondSection = [NSMutableArray arrayWithCapacity:0];
    }
    return _secondSection;
}



- (NSString *)subcatePath {
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    return [documentPath stringByAppendingPathComponent:@"subcate.plist"];
}

- (NSMutableArray *)subcateGroups {
    if (_subcateGroups == nil) {
        _subcateGroups = [NSMutableArray arrayWithCapacity:2];
    }
    return _subcateGroups;
}


- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    
    return _collectionView;
}

- (void)dealloc {
    
    NSLog(@"%s", __FUNCTION__);
}


@end


/// CollectionView的头部视图
@interface XYChannelCategoryHeaderView()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIView *separatorLine;
@end

@implementation XYChannelCategoryHeaderView
- (UIView *)separatorLine {
    if (_separatorLine == nil) {
        UIView *separatorLine = [UIView new];
        separatorLine.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        separatorLine.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 10);
        [self addSubview:separatorLine];
        _separatorLine = separatorLine;
    }
    
    return _separatorLine;
}

- (UILabel *)label {
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:13];
        label.frame = CGRectMake(10, CGRectGetMaxY(self.separatorLine.frame), CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame) - 10);
        [self addSubview:label];
        _label = label;
    }
    
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label.hidden = NO;
        self.separatorLine.hidden = NO;
    }
    
    return self;
}


- (void)setSectionHeaderTitle:(NSString *)sectionHeaderTitle {
    _sectionHeaderTitle = sectionHeaderTitle;
    
    self.label.text = sectionHeaderTitle;
}
@end


@implementation XYChannelCategoryLayout

- (void)prepareLayout {
    [super prepareLayout];
    
//    self.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame)/3, 35);
    self.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 45);
//    self.minimumLineSpacing = 10;
//    self.minimumInteritemSpacing = 10;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

@end

/// 频道分类cell
@interface XYChannelCategoryCell ()
@property (nonatomic, weak) UILabel *label;
@end

@implementation XYChannelCategoryCell

- (UILabel *)label {
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.frame = self.contentView.bounds;
        [self.contentView addSubview:label];
        _label = label;
    }
    
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label.textColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = CGRectGetWidth(self.contentView.frame) * 0.13;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [UIColor colorWithRed:57/255.0 green:217/255.0 blue:146/255.0 alpha:1.0].CGColor;
    }
    
    return self;
}

- (void)setSubcate:(NSDictionary *)subcate {
    _subcate = subcate;
    
    self.label.text = subcate[@"cname"];
}



@end
