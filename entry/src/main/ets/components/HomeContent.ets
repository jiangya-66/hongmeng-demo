import prompt from '@ohos.promptAction';

// 定义数据类型接口
interface StatItem {
  title: string;
  value: string;
  change: string;
  icon: string;
}

interface TaskItem {
  title: string;
  description: string;
  time: string;
  priority: number;
  completed: boolean;
}

interface ActivityItem {
  title: string;
  description: string;
  time: string;
  icon: string;
}

interface WeeklyDataItem {
  day: string;
  value: number;
}

// 新闻轮播数据接口
interface NewsItem {
  id: number;
  title: string;
  content: string;
}

@Component
export struct HomeContent {
  // 数据统计卡片数据
  @State statsData: StatItem[] = [
    { title: '今日活跃用户', value: '1,234', change: '+12%', icon: 'app.media.startIcon' },
    { title: '新增订单', value: '567', change: '+8%', icon: 'app.media.startIcon' },
    { title: '总收入', value: '¥89,012', change: '+15%', icon: 'app.media.startIcon' },
    { title: '任务完成率', value: '94%', change: '+3%', icon: 'app.media.startIcon' }
  ];

  // 任务列表数据
  @State tasks: TaskItem[] = [
    { title: '设计评审会议', description: '与设计团队讨论新功能UI', time: '10:00 AM', priority: 1, completed: false },
    { title: '代码审查', description: '审查团队成员的PR', time: '2:00 PM', priority: 2, completed: false },
    { title: '项目进度报告', description: '准备本周项目进度报告', time: '4:30 PM', priority: 3, completed: true },
    { title: '团队建设活动', description: '组织团队建设活动', time: '6:00 PM', priority: 2, completed: false }
  ];

  // 图表数据 - 周活跃度
  @State weeklyData: WeeklyDataItem[] = [
    { day: '周一', value: 120 },
    { day: '周二', value: 180 },
    { day: '周三', value: 150 },
    { day: '周四', value: 220 },
    { day: '周五', value: 190 },
    { day: '周六', value: 140 },
    { day: '周日', value: 100 }
  ];

  // 最近活动数据
  @State activities: ActivityItem[] = [
    { title: '新用户注册', description: '用户"张三"刚刚注册了账户', time: '5分钟前', icon: 'app.media.startIcon' },
    { title: '订单完成', description: '订单 #12345 已完成支付', time: '15分钟前', icon: 'app.media.startIcon' },
    { title: '系统更新', description: '系统已更新到最新版本', time: '1小时前', icon: 'app.media.startIcon' },
    { title: '数据备份', description: '每日数据备份已完成', time: '2小时前', icon: 'app.media.startIcon' }
  ];

  // 新闻轮播数据
  @State newsItems: NewsItem[] = [
    { id: 1, title: '公司新闻', content: '公司荣获2024年度科技创新企业奖' },
    { id: 2, title: '产品发布', content: '新产品HarmonyOS 4.0正式发布，带来全新体验' },
    { id: 3, title: '员工活动', content: '公司组织年度团建活动，提升团队凝聚力' },
    { id: 4, title: '市场动态', content: '公司市场份额在Q2季度增长15%，创历史新高' },
    { id: 5, title: '技术突破', content: '研发团队在AI算法领域取得重大突破' },
    { id: 6, title: '合作伙伴', content: '公司与华为达成战略合作，共同推进生态建设' }
  ];

  // 轮播相关状态
  @State currentNewsIndex: number = 0;
  @State marqueeAnimation: number = 0;

  // 处理统计卡片点击
  private handleStatClick(statTitle: string): void {
    prompt.showToast({
      message: `查看${statTitle}详情`,
      duration: 1500
    });
  }

  // 处理任务点击
  private handleTaskClick(taskTitle: string): void {
    prompt.showToast({
      message: `处理任务: ${taskTitle}`,
      duration: 1500
    });
  }

  // 处理任务完成状态切换
  private toggleTaskCompletion(index: number): void {
    this.tasks[index].completed = !this.tasks[index].completed;
  }

  // 获取优先级颜色
  private getPriorityColor(priority: number): string {
    switch (priority) {
      case 1: return '#FF3B30'; // 高优先级 - 红色
      case 2: return '#FF9500'; // 中优先级 - 橙色
      case 3: return '#34C759'; // 低优先级 - 绿色
      default: return '#8E8E93'; // 默认 - 灰色
    }
  }

  // 获取优先级文本
  private getPriorityText(priority: number): string {
    switch (priority) {
      case 1: return '高';
      case 2: return '中';
      case 3: return '低';
      default: return '-';
    }
  }

  // 轮播相关方法
  private startMarqueeAnimation(): void {
    // 启动轮播动画
    const animate = () => {
      this.marqueeAnimation += 1;
      
      // 如果动画值达到一定阈值，切换到下一条新闻
      if (this.marqueeAnimation >= 100) {
        this.marqueeAnimation = 0;
        this.currentNewsIndex = (this.currentNewsIndex + 1) % this.newsItems.length;
      }
      
      // 继续动画
      setTimeout(() => {
        animate();
      }, 50); // 每50ms更新一次动画
    };
    
    animate();
  }

  // 处理轮播点击
  private handleNewsClick(newsItem: NewsItem): void {
    prompt.showToast({
      message: `查看新闻: ${newsItem.title}`,
      duration: 1500
    });
  }

  build() {
    Column() {
      // 新闻轮播区域
      this.BuildNewsMarquee()

      // // 欢迎卡片
      // Column() {
      //   Row() {
      //     Column() {
      //       Text('欢迎回来')
      //         .fontSize(18)
      //         .fontColor('#FFFFFF')
      //         .opacity(0.9)
      //
      //       Text('MyApplication')
      //         .fontSize(28)
      //         .fontWeight(FontWeight.Bold)
      //         .fontColor('#FFFFFF')
      //         .margin({ top: 4 })
      //     }
      //
      //     Image($r('app.media.startIcon'))
      //       .width(60)
      //       .height(60)
      //       .margin({ left: 'auto' })
      //   }
      //   .width('100%')
      //   .padding({ left: 24, right: 24, top: 24, bottom: 24 })
      // }
      // .width('94%')
      // .margin({ top: 16, left: 16, right: 16 })
      // .backgroundColor('#007DFF')
      // .borderRadius(20)
      // .shadow({ radius: 16, color: '#007DFF40', offsetX: 0, offsetY: 6 })
      //
      // // 数据统计卡片
      // this.BuildStatsCard()
      //
      // // 任务列表
      // this.BuildTaskList()
      //
      // // 图表区域
      // this.BuildChartSection()
      //
      // // 最近活动
      // this.BuildRecentActivities()

      // 底部占位空间
      Column()
        .width('100%')
        .height(40)
    }
    .width('100%')
    .height('100%')
    .position({ top: 0 }) // 固定在顶部
    .backgroundImage($r('app.media.content12'))
    .backgroundImageSize(ImageSize.Cover) // 图片宽度设为父容器大小，高度超出的部分截掉
    .clip(true) // 超出部分裁剪
    .onAppear(() => {
      // 组件出现时启动轮播动画
      this.startMarqueeAnimation();
    })
  }

  // 构建新闻轮播组件
  @Builder
  BuildNewsMarquee() {
    Column() {
      // 轮播容器
      Row() {
        // 轮播内容区域
        Column() {
          Row() {
            
            // 新闻指示器
            Row() {
              ForEach(this.newsItems, (item: NewsItem, index: number) => {
                Column()
                  // .width(6)
                  // .height(6)
                  // .backgroundColor(index === this.currentNewsIndex ? '#FFFFFF' : '#FFFFFF80')
                  // .borderRadius(3)
                  // .margin({ right: 4 })
              })
            }
            .margin({ left: 'auto' })
          }
          .width('100%')

          
          // 轮播内容 - 使用Stack实现从右到左滚动效果
          Stack() {
            // 当前新闻
            Row() {
              Text(this.newsItems[this.currentNewsIndex].content)
                .fontSize(14)
                .fontWeight(FontWeight.Normal)
                .fontColor('#666666')
                .textOverflow({ overflow: TextOverflow.Clip })
                .maxLines(1)
            }
            .width('100%')
            .translate({ x: -this.marqueeAnimation * 2 }) // 从右到左滚动
          }
          .width('100%')
          .height(24)
          .clip(true) // 超出部分裁剪
        }
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .padding({ left: 16, right: 16 })
      .alignItems(VerticalAlign.Center)
    }
    .width('98%') // 宽度为父容器的90%
    .height(38) // 高度为50
    .backgroundColor('#ffffff')
    .borderRadius(20) // 圆角
    .margin({ top: 92, left: '5%', right: '5%' }) // 水平居中
    .shadow({ radius: 10, color: '#00000020', offsetX: 0, offsetY: 4 })
    .onClick(() => {
      this.handleNewsClick(this.newsItems[this.currentNewsIndex]);
    })
  }

  // 构建统计卡片
  @Builder
  BuildStatsCard() {
    Column() {
      // 标题区域
      // 统计卡片网格
      Grid() {
        ForEach(this.statsData, (item: StatItem, index: number) => {
          GridItem() {
            Column() {
              Row() {
                Image($r(item.icon))
                  .width(24)
                  .height(24)
                  .fillColor('#007DFF')
                
                Text(item.change)
                  .fontSize(12)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(item.change.startsWith('+') ? '#34C759' : '#FF3B30')
                  .margin({ left: 'auto' })
              }
              .width('100%')
              .margin({ bottom: 12 })

              Text(item.value)
                .fontSize(28)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ bottom: 6 })

              Text(item.title)
                .fontSize(14)
                .fontColor('#666666')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .width('100%')
            .height(140)
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius(16)
            .border({ width: 1, color: '#F0F0F0' })
            .shadow({ radius: 8, color: '#00000010', offsetX: 0, offsetY: 4 })
            .onClick(() => {
              this.handleStatClick(item.title);
            })
          }
          .rowStart(Math.floor(index / 2))
          .rowEnd(Math.floor(index / 2))
          .columnStart(index % 2)
          .columnEnd(index % 2)
        })
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap(16)
      .rowsGap(16)
      .width('100%')
    }
    .width('100%')
    .margin({ top: 8, bottom: 24, left: 16, right: 16 })
  }

  // 构建任务列表
  @Builder
  BuildTaskList() {
    Column() {
      // 标题区域
      Row() {
        Text('今日任务')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        
        Text('全部')
          .fontSize(14)
          .fontColor('#007DFF')
          .margin({ left: 'auto' })
          .onClick(() => {
            prompt.showToast({
              message: '查看所有任务',
              duration: 1500
            });
          })
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 任务列表
      Column() {
        ForEach(this.tasks, (task: TaskItem, index: number) => {
          Row() {
            // 任务完成状态
            Column() {
              if (task.completed) {
                Image($r('app.media.startIcon'))
                  .width(24)
                  .height(24)
                  .fillColor('#34C759')
              } else {
                Column()
                  .width(24)
                  .height(24)
                  .border({ width: 2, color: '#C7C7CC' })
                  .borderRadius(12)
              }
            }
            .width(36)
            .height(36)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
            .onClick(() => {
              this.toggleTaskCompletion(index);
            })

            // 任务信息
            Column() {
              Row() {
                Text(task.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(task.completed ? '#8E8E93' : '#333333')
                  .decoration({ type: task.completed ? TextDecorationType.LineThrough : TextDecorationType.None })
                
                // 优先级标签
                Column() {
                  Text(this.getPriorityText(task.priority))
                    .fontSize(10)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#FFFFFF')
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                }
                .backgroundColor(this.getPriorityColor(task.priority))
                .borderRadius(6)
                .margin({ left: 8 })
              }
              .width('100%')
              .margin({ bottom: 6 })

              Text(task.description)
                .fontSize(14)
                .fontColor('#666666')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .margin({ left: 16 })
            .flexGrow(1)

            // 时间
            Text(task.time)
              .fontSize(14)
              .fontColor('#999999')
              .margin({ left: 'auto' })
          }
          .width('100%')
          .padding({ top: 20, bottom: 20 })
          .border({ width: { bottom: 1 }, color: '#F0F0F0' })
          .onClick(() => {
            this.handleTaskClick(task.title);
          })
        })
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .border({ width: 1, color: '#F0F0F0' })
      .shadow({ radius: 8, color: '#00000010', offsetX: 0, offsetY: 4 })
    }
    .width('100%')
    .margin({ bottom: 24, left: 16, right: 16 })
  }

  // 构建图表区域
  @Builder
  BuildChartSection() {
    Column() {
      // 标题区域
      Row() {
        Text('本周活跃度')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        
        Text('详细')
          .fontSize(14)
          .fontColor('#007DFF')
          .margin({ left: 'auto' })
          .onClick(() => {
            prompt.showToast({
              message: '查看详细图表',
              duration: 1500
            });
          })
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 图表容器
      Column() {
        // 图表标题和值
        Row() {
          Column() {
            Text('平均活跃度')
              .fontSize(16)
              .fontColor('#666666')
              .margin({ bottom: 4 })
            
            Text('157')
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
          }

          Column() {
            Text('较上周')
              .fontSize(14)
              .fontColor('#666666')
            
            Row() {
              Text('+12%')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#34C759')
              
              Image($r('app.media.startIcon'))
                .width(18)
                .height(18)
                .fillColor('#34C759')
                .margin({ left: 6 })
            }
            .margin({ top: 6 })
          }
          .margin({ left: 'auto' })
        }
        .width('100%')
        .margin({ bottom: 32 })

        // 柱状图
        Row() {
          ForEach(this.weeklyData, (item: WeeklyDataItem, index: number) => {
            Column() {
              Column()
                .width(32)
                .height(item.value * 0.8)
                .backgroundColor('#007DFF')
                .borderRadius(8)
              
              Text(item.day)
                .fontSize(14)
                .fontColor('#666666')
                .margin({ top: 12 })
            }
            .margin({ right: index === this.weeklyData.length - 1 ? 0 : 16 })
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)
          })
        }
        .width('100%')
        .height(240)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Bottom)
      }
      .width('100%')
      .padding({ top: 28, bottom: 28, left: 24, right: 24 })
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .border({ width: 1, color: '#F0F0F0' })
      .shadow({ radius: 8, color: '#00000010', offsetX: 0, offsetY: 4 })
    }
    .width('100%')
    .margin({ bottom: 24, left: 16, right: 16 })
  }

  // 构建最近活动
  @Builder
  BuildRecentActivities() {
    Column() {
      // 标题区域
      Row() {
        Text('最近活动')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        
        Text('查看全部')
          .fontSize(14)
          .fontColor('#007DFF')
          .margin({ left: 'auto' })
          .onClick(() => {
            prompt.showToast({
              message: '查看所有活动记录',
              duration: 1500
            });
          })
      }
      .width('100%')
      .margin({ bottom: 16 })

      // 活动列表
      Column() {
        ForEach(this.activities, (activity: ActivityItem, index: number) => {
          Row() {
            // 活动图标
            Column() {
              Image($r(activity.icon))
                .width(24)
                .height(24)
                .fillColor('#007DFF')
            }
            .width(48)
            .height(48)
            .backgroundColor('#007DFF20')
            .borderRadius(24)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)

            // 活动信息
            Column() {
              Text(activity.title)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
                .margin({ bottom: 4 })

              Text(activity.description)
                .fontSize(14)
                .fontColor('#666666')
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
            }
            .margin({ left: 16 })
            .flexGrow(1)

            // 时间
            Text(activity.time)
              .fontSize(14)
              .fontColor('#999999')
          }
          .width('100%')
          .padding({ top: 20, bottom: 20 })
          .border({ width: { bottom: 1 }, color: '#F0F0F0' })
        })
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .border({ width: 1, color: '#F0F0F0' })
      .shadow({ radius: 8, color: '#00000010', offsetX: 0, offsetY: 4 })
    }
    .width('100%')
    .margin({ left: 16, right: 16 })
  }
}