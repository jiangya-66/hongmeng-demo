import router from '@ohos.router';
import prompt from '@ohos.promptAction';
import webview from '@ohos.web.webview';

@Entry
@Component
export struct WebTestLocalPage {
  @State searchText: string = '';
  @State selectedTab: number = 0;
  
  // Web控制器
  controller: webview.WebviewController = new webview.WebviewController();
  
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
    
    this.searchText = '';
  }
  
  // 处理导航栏点击
  private handleTabClick(tabIndex: number): void {
    this.selectedTab = tabIndex;
    
    // 根据选中的标签页进行不同的操作
    switch (tabIndex) {
      case 0:
        // 首页 - 保持当前Web页面
        break;
      case 1:
        // 通讯录 - 跳转到通讯录页面
        router.pushUrl({
          url: 'pages/Home',
          params: { tabIndex: 1 }
        });
        break;
      case 2:
        // 日程安排 - 跳转到日程页面
        router.pushUrl({
          url: 'pages/Home',
          params: { tabIndex: 2 }
        });
        break;
      case 3:
        // 个人中心 - 跳转到个人中心页面
        router.pushUrl({
          url: 'pages/Home',
          params: { tabIndex: 3 }
        });
        break;
    }
  }
  
  // 返回上一页
  private goBack(): void {
    router.back();
  }
  
  // 页面即将消失时清理Web资源
  aboutToDisappear(): void {
    // 清理WebView资源
    if (this.controller) {
      // 可以在这里添加WebView清理逻辑
    }
  }

  build() {
    // 使用Stack布局实现顶部和底部固定，中间内容区域显示WebView
    Stack() {
      // 中间内容区域 - WebView
      Column() {
        // WebView组件 - 加载本地HTML文件
        Web({
          src: $rawfile('index.html'), // 加载本地HTML文件 - 使用$rawfile资源引用
          controller: this.controller
        })
          .width('100%')
          .height('100%')
          .javaScriptAccess(true) // 启用JavaScript
          .fileAccess(true) // 允许文件访问
          .onPageBegin(() => {
            console.info('本地H5页面开始加载');
          })
          .onPageEnd(() => {
            console.info('本地H5页面加载完成');
          })
      }
      .width('100%')
      .height('100%')
      .padding({ top: 50, bottom: 60 }) // 为顶部和底部留出空间
      
      // 顶部状态栏和搜索栏（固定）
      Column() {
        // 返回按钮和标题
        Row() {
          // // 返回按钮
          // Image($r('app.media.startIcon'))
          //   .width(24)
          //   .height(24)
          //   .fillColor('#FFFFFF')
          //   .margin({ left: 16 })
          //   .onClick(() => {
          //     this.goBack();
          //   })
          
          // // 页面标题
          // Text('H5测试页面')
          //   .fontSize(18)
          //   .fontWeight(FontWeight.Bold)
          //   .fontColor('#FFFFFF')
          //   .margin({ left: 12 })
          //   .alignSelf(ItemAlign.Center)
          //
          // 右侧占位
          Row()
            .width(40)
            .height(24)
            .margin({ right: 16 })
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        
        // 搜索栏
        Stack() {
          TextInput({ placeholder: '搜索内容', text: this.searchText })
            .width('100%')
            .height(35)
            .backgroundColor('#808BC2')
            .margin({ left: 15, top: 15 })
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
      .height(50)
      .position({ top: 0 }) // 固定在顶部
      .backgroundImage($r('app.media.headerbg'))
      .backgroundImageSize(ImageSize.Cover)
      .clip(true)
      
      // 底部导航栏（固定）
      Row() {
        // 首页（当前页面）
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
          this.handleTabClick(0);
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
          this.handleTabClick(1);
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
          this.handleTabClick(2);
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
          this.handleTabClick(3);
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
    .backgroundColor('#F8F9FA')
  }
}