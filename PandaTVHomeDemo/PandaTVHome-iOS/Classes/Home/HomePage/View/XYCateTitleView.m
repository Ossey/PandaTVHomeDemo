//
//  XYCateTitleView.m
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  分类标题内容视图

#import "XYCateTitleView.h"


@interface XYCateTitleView ()

/** 添加子分类按钮 */
@property (nonatomic, weak) UIButton *addSubCateBtn;
/** 分类标题内容视图 */
@property (nonatomic, weak) UIScrollView *cateTitleView;
/** 底部分割线 */
@property (nonatomic, weak) UIImageView *separatorView;
/** 外界的子控制器数组 */
@property (nonatomic, strong) NSMutableArray *cateTitles;
/** 存放标题按钮的数组 */
@property (nonatomic, strong) NSMutableArray *items;
/** 记录上次选中的按钮 */
@property (nonatomic, strong) UIButton *previousSelectedBtn;
/** 记录当前选中的按钮 */
@property (nonatomic, strong) UIButton *currentSelectBtn;
/** 下划线 */
@property (nonatomic, weak) UIImageView *underLine;
/** 根据按钮中label的文字计算按钮中label的宽度 */
@property (nonatomic, assign) CGFloat btnContentWidth;
/** 按钮中label的宽度的计算属性 */
@property (nonatomic, assign) CGFloat btnContentMargin;

@end

@implementation XYCateTitleView

@synthesize homeCateTitleFont = _homeCateTitleFont;
@synthesize itemScale = _itemScale;
@synthesize currentItemBackgroundColor = _currentItemBackgroundColor;
@synthesize otherItemBackgroundColor = _otherItemBackgroundColor;
@synthesize underLineBackgroundColor = _underLineBackgroundColor;
@synthesize underLineImage = _underLineImage;
@synthesize separatorBackgroundColor = _separatorBackgroundColor;
@synthesize separatorImage = _separatorImage;

- (UIColor *)separatorBackgroundColor {
    return _separatorBackgroundColor ?: [UIColor colorWithRed:140 / 255.0 green:140 / 255.0 blue:140 / 255.0 alpha:0.6];
}

- (void)setSeparatorBackgroundColor:(UIColor *)separatorBackgroundColor {
    
    _separatorBackgroundColor = separatorBackgroundColor;
    if (separatorBackgroundColor) {
        self.separatorView.image = [UIImage new];
        _separatorImage = [UIImage new];
        self.separatorView.backgroundColor = separatorBackgroundColor;
    }
}

- (void)setSeparatorImage:(UIImage *)separatorImage {
    _separatorImage = separatorImage;
    
    if (separatorImage) {
        self.separatorView.backgroundColor = [UIColor clearColor];
        _separatorBackgroundColor = [UIColor clearColor];
        self.separatorView.image = separatorImage;
    }
}

- (UIImage *)separatorImage {
    
    return _separatorImage ?: nil;
}

- (UIImage *)underLineImage {

    return _underLineImage ?: nil;
}

- (void)setUnderLineImage:(UIImage *)underLineImage {
    _underLineImage = underLineImage;
    
    if (_underLineImage) {
        _underLineBackgroundColor = [UIColor clearColor];
        self.underLine.backgroundColor = [UIColor clearColor];
        self.underLine.image = underLineImage;
    }
}

- (UIColor *)underLineBackgroundColor {
    
    return _underLineBackgroundColor ?: [UIColor clearColor];
    
}

- (void)setUnderLineBackgroundColor:(UIColor *)underLineBackgroundColor {
    _underLineBackgroundColor = underLineBackgroundColor;
    if (underLineBackgroundColor) {
        self.underLine.image = [UIImage new];
        _underLineImage = [UIImage new];
        self.underLine.backgroundColor = underLineBackgroundColor;
    }
}

- (UIColor *)currentItemBackGroundColor {

    if (self.currentSelectBtn != self.previousSelectedBtn) {
        
        return _currentItemBackgroundColor ?: [UIColor whiteColor];
    } else {
        return self.currentSelectBtn.backgroundColor;
    }
}

- (UIColor *)otherItemBackGroundColor {
    if (self.currentSelectBtn != self.previousSelectedBtn) {
        
        return _otherItemBackgroundColor ?: [UIColor whiteColor];
    } else {
        return self.previousSelectedBtn.backgroundColor;
    }
}

- (void)setCurrentItemBackgroundColor:(UIColor *)currentItemBackgroundColor {
    _currentItemBackgroundColor = currentItemBackgroundColor;
    
    if (self.currentSelectBtn != self.previousSelectedBtn) {
        
        self.currentSelectBtn.backgroundColor = currentItemBackgroundColor;
    }
}

- (void)setOtherItemBackGroundColor:(UIColor *)otherItemBackgroundColor {
    _otherItemBackgroundColor = otherItemBackgroundColor;
    
    for (UIButton *btn in self.items) {
        if (btn != self.currentSelectBtn) {
            btn.backgroundColor = otherItemBackgroundColor;
        }
    }
}

- (void)setItemScale:(CGFloat)itemScale {
    _itemScale = itemScale;
    /// 设置标题按钮的缩放
    self.currentSelectBtn.transform = CGAffineTransformMakeScale(1.0f + _itemScale, 1.0f + _itemScale);
}

- (CGFloat)itemScale {
    return _itemScale ?: 0.0;
}

- (CGFloat)btnContentMargin {
    CGFloat btnW = self.currentSelectBtn.frame.size.width;
    CGFloat margin = (btnW - self.btnContentWidth) * 0.5;
    return margin;
}

- (UIFont *)homeCateTitleFont {
    
    return self.currentSelectBtn.titleLabel.font ?: [UIFont systemFontOfSize:15 weight:0.3];
    
}
- (void)setHomeCateTitleFont:(UIFont *)homeCateTitleFont {
    
    _homeCateTitleFont = homeCateTitleFont;
    for (UIButton *btn in self.items) {
        [btn.titleLabel setFont:homeCateTitleFont];
    }
}

- (CGFloat)btnContentWidth {
    NSString *currentText = self.currentSelectBtn.currentTitle;
    UIImage *currentImage = self.currentSelectBtn.currentImage;
    CGSize size = [currentText sizeWithAttributes:@{NSFontAttributeName : self.homeCateTitleFont}];
    /// 只有文字， 没有图片时
    if ((currentText != nil || ![currentText isEqualToString:@""]) && !currentImage) {
        return size.width;

    }
    
    /// 没有文字， 只有图片时
    if ((currentText == nil || [currentText isEqualToString:@""]) && currentImage != nil) {
        return currentImage.size.width;
    }
    
    /// 图片和文字都有
    if ((currentText != nil || ![currentText isEqualToString:@""]) && currentImage) {
        return  currentImage.size.width + size.width + 10;
    }
    
    /// 全都没有
    return 0;
    
}

- (UIView *)underLine {
    if (_underLine == nil) {
        UIImageView *underLine = [UIImageView new];
        [self.cateTitleView addSubview:underLine];
        underLine.backgroundColor = self.underLineBackgroundColor;
        underLine.image = self.underLineImage;
        _underLine = underLine;
        _underLine.frame = CGRectMake(self.btnContentMargin, CGRectGetHeight(self.frame)-2, self.btnContentWidth, 2);
    }
    return _underLine;
}



- (NSInteger)selectedIndex {
    
    return  _selectedIndex == 0 || _selectedIndex > self.cateTitles.count ? 0 : _selectedIndex;
}


- (NSMutableArray *)items {
    
    if (_items == nil) {
        
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSMutableArray *)cateTitles {
    if (_cateTitles == nil) {
        _cateTitles = [NSMutableArray array];
    }
    return _cateTitles;
}

- (UIButton *)addSubCateBtn {
    if (_addSubCateBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"addbutton"] forState:UIControlStateNormal];
        _addSubCateBtn = btn;
        _addSubCateBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), 0, CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        [_addSubCateBtn addTarget:self action:@selector(addSubCateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addSubCateBtn];
    }
    
    return _addSubCateBtn;
}

- (UIScrollView *)cateTitleView {
    if (_cateTitleView == nil) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        _cateTitleView = scrollView;
        _cateTitleView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - CGRectGetHeight(self.frame), CGRectGetHeight(self.frame));
        [self addSubview:_cateTitleView];
    }
    return _cateTitleView;
}

- (UIView *)separatorView {
    if (_separatorView == nil) {
        UIImageView *separatorView = [[UIImageView alloc] init];
        separatorView.image = self.separatorImage;
        separatorView.backgroundColor = self.separatorBackgroundColor;
        _separatorView = separatorView;
        CGRect frame = _separatorView.frame;
        frame.origin.y = CGRectGetHeight(self.cateTitleView.frame) - 0.5;
        frame.size.height = 0.5;
        frame.size.width = CGRectGetWidth(self.frame);
        frame.origin.x = 0;
        _separatorView.frame = frame;
        [self addSubview:_separatorView];
    }
    return _separatorView;
}



- (instancetype)initWithFrame:(CGRect)frame channelCates:(NSArray *)channelCates {

    if (self = [super initWithFrame:frame]) {
        self.cateTitles = [channelCates mutableCopy];
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    self.cateTitleView.hidden = NO;
    self.addSubCateBtn.hidden = NO;
    self.separatorView.hidden = NO;
    [self setupAllTitle];
    self.underLine.hidden = NO;

    /// 监听containerView滚动的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerViewDidScroll:) name:@"homeContainerViewDidScrollNote" object:nil];
    /// 发布containerView减速完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(containerViewDidScrollDidEndDecelerating:) name:@"homeContainerViewDidEndDeceleratingNote" object:nil];
}


#pragma mark - 设置所有的子标题
- (void)setupAllTitle {
    
    NSInteger count = self.cateTitles.count;
    CGFloat x = 0;
    
    // 控制每个标题按钮的宽度，当小于5个的时候，让他们平分整个屏幕的宽度
    CGFloat w = count < 5 ? CGRectGetWidth(self.cateTitleView.frame) / count : 100;
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        x = i * w;
        button.frame = CGRectMake(x, 0, w, CGRectGetHeight(self.cateTitleView.frame));
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        NSDictionary *dict = self.cateTitles[i];
        NSString *imageName = dict[@"ename"];
        [button setTitle:dict[@"cname"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_h"]] forState:UIControlStateSelected];
        button.titleLabel.font = self.homeCateTitleFont;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.items addObject:button];
        
        [self.cateTitleView addSubview:button];
        
    }
    
    // 设置标题视图的滚动范围
    self.cateTitleView.contentSize = CGSizeMake(count * w, 0);
    
    // 设置内容滚动视图的滚动范围 -- 通知代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(cateTitleView:cateTitleItemDidCreated:)]) {
        [self.delegate cateTitleView:self cateTitleItemDidCreated:count];
    }
    
    // 让默认选择的按钮
    [self selecteTitleItemWithIndex:self.selectedIndex];

}

#pragma mark - 切换到index索引对应的子控制
- (void)selecteTitleItemWithIndex:(NSInteger)index {
    
    if (index > self.items.count - 1 || index < 0) {
        return;
    }
    UIButton *btn = self.items[index];
    [self titleButtonClick:btn];
}

#pragma mark - 监听标题按钮的点击
- (void)titleButtonClick:(UIButton *)button {
    
    [self selectedBtn:button];

}


- (void)addSubCateBtnClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cateTitleView:didSelectedAddSubTitle:)]) {
        [self.delegate cateTitleView:self didSelectedAddSubTitle:button];
    }
}

#pragma mark - 设置选中按钮文字的默认颜色
- (void)selectedBtn:(UIButton *)button {
    
    _currentSelectBtn = button; /// 记录当前选中的按钮
    
    _currentSelectBtn.backgroundColor = self.currentItemBackGroundColor;
    _previousSelectedBtn.backgroundColor = self.otherItemBackGroundColor;
    _previousSelectedBtn.selected = NO;
    _previousSelectedBtn.transform = CGAffineTransformIdentity;
    button.selected = YES;
    [_previousSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    /// 设置标题居中
    [self setupTitleCenter:button];
    
    /// 设置标题按钮的缩放
    button.transform = CGAffineTransformMakeScale(1.0f + self.itemScale, 1.0f + self.itemScale);
    
    _previousSelectedBtn = button; /// 记录上次选中的按钮
    
    [UIView animateWithDuration:0.15 animations:^{
        CGRect underLineFrame = self.underLine.frame;
        underLineFrame.size.width = self.btnContentWidth;
        underLineFrame.origin.x = button.frame.origin.x + self.btnContentMargin;
        self.underLine.frame = underLineFrame;
    }];
    
    /// 通知代理，并把点击按钮的索引传递出去，让外界切换对应的子控制器的view,内容滚动范围滚动到对应的位置
    if (self.delegate && [self.delegate respondsToSelector:@selector(cateTitleView:didSelectedItem:)]) {
        NSInteger i = [button tag];
        [self.delegate cateTitleView:self didSelectedItem:i];
    }
    
}

#pragma mark - 设置标题居中
- (void)setupTitleCenter:(UIButton *)button {
    
    // 本质：移动标题滚动视图的偏移量
    // 计算当选择的标题按钮的中心点x在屏幕屏幕中心点时，标题滚动视图的x轴的偏移量
    CGFloat offsetX = button.center.x - CGRectGetWidth(self.cateTitleView.frame) * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算最大的偏移量
    CGFloat maxOffsetX = self.cateTitleView.contentSize.width - CGRectGetWidth(self.cateTitleView.frame);

    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.cateTitleView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - 监听通知的方法
/// containerView滚动的通知
- (void)containerViewDidScroll:(NSNotification *)note {
    // scrollView滚动的时候调用,让字体跟随滚动渐变缩放
    UIScrollView *scrollView = note.object;
    
    NSInteger leftI = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    NSInteger rightI = leftI + 1;
    // 取出缩放的两个按钮
    // 取出左边按钮
    UIButton *leftBtn = self.items[leftI];
    
    // 取出右边的按钮
    UIButton *rightBtn;
    // 容错处理，防止数组越界
    if (rightI < self.items.count) {
        
        rightBtn = self.items[rightI];
    }
    
    // 缩放按钮
    // 计算需要缩放的比例
    CGFloat scaleR = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame); // 放大
    scaleR -= leftI;
    CGFloat scaleL = 1 - scaleR; // 缩小，与放大取反即可

    // 让按钮的缩放范围在1 ~ 1.3的范围，如果不设置按钮的缩放范围在0 ~ 1
    rightBtn.transform = CGAffineTransformMakeScale(scaleR * self.itemScale + 1, scaleR * self.itemScale + 1);
    leftBtn.transform = CGAffineTransformMakeScale(scaleL * self.itemScale + 1, scaleL * self.itemScale + 1);
    
    // 标题按钮文字颜色渐变
    UIColor *leftColor = [UIColor colorWithRed:0.0f green:scaleL blue:0.0f alpha:1.0f];
    UIColor *rightColor = [UIColor colorWithRed:0.0f green:scaleR blue:0.0f alpha:1.0f];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
}

// containerView滚动完成的时候调用
- (void)containerViewDidScrollDidEndDecelerating:(NSNotification *)note {
    
    UIScrollView *scrollView = note.object;
    
    // 计算当前角标
    NSInteger i = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    // 设置选中的按钮的默认颜色为红色
    // 注意：当我们创建完按钮时，应该讲按钮添加到一个可变数组中，方便我们使用的时候根据角标取出对应按钮
    UIButton *button = self.items[i];
    [self selectedBtn:button];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
