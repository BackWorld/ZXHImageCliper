## Usage 用法
将 ZXHImageCliper文件夹 拖入工程即可

## Demo 代码
```
    //截屏视图类
    CliperView *cliper = [[CliperView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight)];
    [self.view addSubview:cliper];
    
    //添加约束 全屏
    NSArray *HCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cliper]|" options:0 metrics:nil views:@{@"cliper":cliper}];
    NSArray *VCons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cliper]|" options:0 metrics:nil views:@{@"cliper":cliper}];
    [self.view addConstraints:HCons];
    [self.view addConstraints:VCons];
    
    //协议方法，点击菜单按钮回调
    @protocol CliperViewDelegate <NSObject>
    
    @required
    -(void)didCancelClipImage;
    -(void)saveClipRegionImage;
    -(void)didConfirmClipImage;
    
    @end
    
    
```
  
![Demo](https://github.com/BackWorld/ZXHImageCliper/blob/master/demo.png)
