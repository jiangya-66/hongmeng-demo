import router from '@ohos.router';
import prompt from '@ohos.promptAction';
import { Profile } from '../components/Profile';
import { HomeContent } from '../components/HomeContent';

@Entry
@Component
export struct Home {
  @State currentUser: string = '用户';
  @State selectedTab: number = 0;
  @State notifications: number = 3;
  @State searchText: string = '';
  
  // 退出登录
  private logout(): void {
    prompt.showToast({
      message: '正在退出登录...',
      duration: 1000
    });
    
    setTimeout(() => {
      router.replaceUrl({
        url: 'pages/Login'
      });
    }, 1000);
  }
  
  // 处理卡片点击
  private handleCardClick(cardName: string): void {
    prompt.showToast({
      message: `进入${cardName}`,
      duration: 1500
    });
  }
  
  // 处理通知点击
  private handleNotificationClick(): void {
    prompt.showToast({
      message: '查看所有通知',
      duration: 1500
    });
  }
  
  // 处理设置点击
  private handleSettingsClick(): void {
    prompt.showToast({
      message: '进入设置页面',
      duration: 1500
    });
  }
  
  // 处理搜索
  private handleSearch(): void {
    if (this.searchText.trim() === '') {
      prompt.showToast({
        message: '请输入搜索内容',
        duration: 1500
      });
      return;
    }
    
    prompt.showToast({
      message: `搜索: ${this.searchText}`,
      duration: 1500
    });
    
    // 这里可以添加实际的搜索逻辑
    this.searchText = '';
  }

  build() {
    // 使用Stack布局实现顶部和底部固定，中间内容区域可滚动
    Stack() {
      // 中间内容区域 - 可滚动部分
      Scroll() {
        Column() {
          // 顶部占位空间，确保内容不被顶部固定区域遮挡
          Column()
            .width('100%')
            .height(50) // 顶部区域的高度：状态栏(60+24+24=108) + 搜索栏(44+16=60) + 额外间距
            
          if (this.selectedTab === 0) {
            // 首页内容 - 使用新的HomeContent组件
            HomeContent()
              .width('100%')
          } else if (this.selectedTab === 1) {
            // 消息页面
            Column() {
              Text('消息中心')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ top: 40, bottom: 40 })
                .alignSelf(ItemAlign.Center)
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
          } else if (this.selectedTab === 2) {
            // 设置页面
            Column() {
              Text('设置')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ top: 40, bottom: 40 })
                .alignSelf(ItemAlign.Center)
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
          } else if (this.selectedTab === 3) {
            // 个人中心页面
            Profile()
          }
          
          // 底部占位空间，确保内容不被底部导航栏遮挡
          Column()
            .width('100%')
            .height(80) // 底部导航栏高度 + 额外间距
        }
        .width('100%')
        .padding({ bottom: 80 }) // 为底部导航栏留出空间
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
      .backgroundColor('#F8F9FA')
      
      // 顶部状态栏和搜索栏（固定）
      Column() {
        // Row() {
          // Column() {
          //   Text('下午好')
          //     .fontSize(14)
          //     .fontColor('#666666')
          //
          //   Text(this.currentUser)
          //     .fontSize(20)
          //     .fontWeight(FontWeight.Bold)
          //     .fontColor('#333333')
          // }
          //
          // Row() {
          //   // 通知按钮
          //   Stack() {
          //     Image($r('app.media.startIcon'))
          //       .width(24)
          //       .height(24)
          //
          //     if (this.notifications > 0) {
          //       Text(this.notifications.toString())
          //         .fontSize(10)
          //         .fontColor('#FFFFFF')
          //         .backgroundColor('#FF3B30')
          //         .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          //         .borderRadius(10)
          //         .position({ x: '80%', y: '-20%' })
          //     }
          //   }
          //   .onClick(() => {
          //     this.handleNotificationClick();
          //   })
          //   .margin({ right: 20 })
          //
          //   // 设置按钮
          //   Image($r('app.media.foreground'))
          //     .width(24)
          //     .height(24)
          //     .onClick(() => {
          //       this.handleSettingsClick();
          //     })
          // }
          // .margin({ left: 'auto' })
        // }
        // .width('100%')
        // .padding({ left: 24, right: 24, top: 60, bottom: 24 })
        
        // 搜索栏
        Stack() {
          TextInput({ placeholder: '搜索内容', text: this.searchText })
            .width('100%')
            .height(35)
            .backgroundColor('#808BC2')
            .margin({left:15, top:15})
            .padding({ left: 40, right: 16 })
            .borderRadius(22)
            .fontSize(14)
            .fontColor('#ffffff')
            .placeholderColor('#ffffff')
            .onChange((value: string) => {
              this.searchText = value;
            })
            .onSubmit(() => {
              this.handleSearch();
            })
          
          // 搜索图标叠加在搜索栏之上
          Image($r('app.media.iconsearch'))
            .width(25)
            .height(25)
            .position({ x: 15, y: 12 })
            .onClick(() => {
              this.handleSearch();
            })
        }
        .width('45%')
        .height(50)
        .alignSelf(ItemAlign.Center)
        .padding({ bottom: 16 })
      }
      .width('100%')
      .height(50) // 设置高度为80
      .position({ top: 0 }) // 固定在顶部
      .backgroundImage($r('app.media.headerbg'))
      .backgroundImageSize(ImageSize.Cover) // 图片宽度设为父容器大小，高度超出的部分截掉
      .clip(true) // 超出部分裁剪
      
      // 底部导航栏（固定）
      Row() {
        // 首页
        Column() {
          Image(this.selectedTab === 0 ? $r('app.media.iconhome') : $r('app.media.iconhome'))
            .width(24)
            .height(24)
            .fillColor(this.selectedTab === 0 ? '#007DFF' : '#999999')
          
          Text('首页')
            .fontSize(10)
            .fontColor(this.selectedTab === 0 ? '#007DFF' : '#999999')
            .margin({ top: 4 })
        }
        .width('25%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.selectedTab = 0;
        })
        
        // 通讯录
        Column() {
          Image(this.selectedTab === 1 ? $r('app.media.iconaddress') : $r('app.media.iconaddress'))
            .width(24)
            .height(24)
            .fillColor(this.selectedTab === 1 ? '#007DFF' : '#999999')
          
          Text('通讯录')
            .fontSize(10)
            .fontColor(this.selectedTab === 1 ? '#007DFF' : '#999999')
            .margin({ top: 4 })
        }
        .width('25%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.selectedTab = 1;
        })
        
        // 日程安排
        Column() {
          Image(this.selectedTab === 2 ? $r('app.media.icontime') : $r('app.media.icontime'))
            .width(24)
            .height(24)
            .fillColor(this.selectedTab === 2 ? '#007DFF' : '#999999')
          
          Text('日程安排')
            .fontSize(10)
            .fontColor(this.selectedTab === 2 ? '#007DFF' : '#999999')
            .margin({ top: 4 })
        }
        .width('25%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.selectedTab = 2;
        })
        
        // 个人中心
        Column() {
          Image(this.selectedTab === 3 ? $r('app.media.iconman') : $r('app.media.iconman'))
            .width(24)
            .height(24)
            .fillColor(this.selectedTab === 3 ? '#007DFF' : '#999999')
          
          Text('个人中心')
            .fontSize(10)
            .fontColor(this.selectedTab === 3 ? '#007DFF' : '#999999')
            .margin({ top: 4 })
        }
        .width('25%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.selectedTab = 3;
        })
      }
      .width('100%')
      .height(60)
      .backgroundColor('#FFFFFF')
      .border({ width: { top: 1 }, color: '#F0F0F0' })
      .shadow({ radius: 8, color: '#00000010', offsetX: 0, offsetY: -2 })
      .position({ bottom: 0 }) // 固定在底部
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffd0e0f5')
  }
}