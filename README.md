# 前言
前几天在群里看见一个朋友说这种菜单用哪个控件写比较好，有的人说用UICollectionView,有的说用UIButton自己计算。我今天上午正好暂时没接口。写了一下，最后还是感觉用UIButton比较好用，没有必要用UICollectionView。写个Demo,大家如果需要这个思路可以看一下。

# 正文
最重要的一个方法就是怎么让菜单按钮显示正常：

```
/**
 *  数据显示
 */
- (void)loadData:(UIView *)bgView whatArray:(NSMutableArray *)array
{
   __block CGFloat weakX = locaX;
   __block CGFloat weakY = locaY;
    for(int i = 0;i < array.count;i++)
    {
        [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            //创建按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i+1;
            //判断是否是选中的数组
            BOOL isS = NO;
            if (array.count == self.sMenuArray.count) {
                isS = YES;
                for(int i=0; i<array.count;i++)
                {
                    NSString *str1 = array[i];
                    NSString *str2 = self.sMenuArray[i];
                    if (![str1 isEqualToString:str2]) {
                        isS = NO;
                        break;
                    }
                }
            }
            if (isS == YES) {
                btn.tag = i+1+100;
            }
            [btn setTitle:array[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
            //计算btn的宽度
            CGSize btnSize = [array[i] boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            CGFloat btnW = btnSize.width + 2 * locaX;
            CGFloat btnH = 30;
            //判断一下按钮是否超出
            if ((weakX + btnW) >= self.view.frame.size.width - locaX) {
                weakX = locaX;
                weakY +=btnH + 5;
            }
            
            btn.frame = CGRectMake(weakX, weakY, btnW, btnH);
            
            //判断下一次xy位置
            weakX += btnW + locaX;
            if (weakX >= self.view.frame.size.width - locaX) {
                weakX = locaX;
                weakY += btnH + 5;
            }
            [bgView addSubview:btn];
            btn.layer.cornerRadius = btn.frame.size.width /10;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithWhite:0.000 alpha:0.105].CGColor;
            
        } completion:^(BOOL finished) {
            
        }];
       
    }
}
```	
知道了如何显示菜单按钮之后，其他的就简单了。点击菜单按钮把它移动到常用菜单处:
```
/**
 *  按钮事件
 *
 *  @param sender <#sender description#>
 */
- (void)doSomething:(UIButton *)sender
{
    //判断按钮处于哪个区域
    if (sender.tag<100) {
        // 从menuarray取出这个数据放到smenuarray里面
        NSInteger index = sender.tag - 1;
        [self.sMenuArray addObject:self.menuArray[index]];
        [self.menuArray removeObjectAtIndex:index];
    }else
    {
        // 从smenuarray取出这个数据放到smenuarray里面
        NSInteger index = sender.tag - 1 - 100;
        [self.menuArray addObject:self.sMenuArray[index]];
        [self.sMenuArray removeObjectAtIndex:index];
    }
    //数据重新加载,把上一次数据显示去除
    for(UIView *view in [self.dataView subviews])
    {
        [view removeFromSuperview];
    }
    for (UIView *view in [self.selectedView subviews]) {
        [view removeFromSuperview];
    }
    [self loadData:self.dataView whatArray:self.menuArray];
    [self loadData:self.selectedView whatArray:self.sMenuArray];
}
```
在代码里我已经把每一步操作说的很清楚了，大家如果感兴趣可以去下载运行一下。
运行截图：
![这里写图片描述](http://img.blog.csdn.net/20160128132804533)
![这里写图片描述](http://img.blog.csdn.net/20160128132816041)
![这里写图片描述](http://img.blog.csdn.net/20160128132828916)
# 结语
我是程序员，我为自己代言
