import router from '@ohos.router';

@Entry
@Component
export struct Splash {
  @State private progressValue: number = 0;
  @State private countdown: number = 3;
  
  aboutToAppear(): void {
    // 启动进度条动画
    const interval = setInterval(() => {
      if (this.progressValue < 100) {
        this.progressValue += 10;
      }
    }, 100);

    // 倒计时显示
    const countdownInterval = setInterval(() => {
      if (this.countdown > 0) {
        this.countdown -= 1;
      }
    }, 1000);

    // 3秒后跳转到登录页
    setTimeout(() => {
      clearInterval(interval);
      clearInterval(countdownInterval);
      router.pushUrl({
        url: 'pages/Login'
      });
    }, 3000);
  }
  
  build() {
    Column() {
      // 应用Logo
      Image($r('app.media.layered_image'))
        .width(180)
        .height(180)
        .margin({ bottom: 40 })
        .borderRadius(30)
        .shadow({ radius: 20, color: '#007DFF20', offsetX: 0, offsetY: 10 })
      
      // 应用名称
      Text('HONGMENG-APP')
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
        .fontColor('#007DFF')
        .margin({ bottom: 12 })

      // // 应用描述
      // Text('HarmonyOS 应用')
      //   .fontSize(18)
      //   .fontColor('#666666')
      //   .margin({ bottom: 60 })

      // 加载进度条
      Column() {
        Progress({ value: this.progressValue, total: 100, type: ProgressType.Ring })
          .width(80)
          .height(80)
          .color('#007DFF')
          .backgroundColor('#F0F5FF')
        
        Text(`${this.progressValue}%`)
          .fontSize(16)
          .fontColor('#007DFF')
          .fontWeight(FontWeight.Medium)
          .margin({ top: 8 })
      }
      .margin({ bottom: 40 })
      
      // 倒计时提示
      Row() {
        Text('正在启动应用，请稍候...')
          .fontSize(14)
          .fontColor('#999999')
        
        Text(`${this.countdown}s`)
          .fontSize(14)
          .fontColor('#007DFF')
          .fontWeight(FontWeight.Medium)
          .margin({ left: 4 })
      }
      
      // 底部版权信息
      Text('© 2025 中软国际')
        .fontSize(12)
        .fontColor('#CCCCCC')
        .margin({ top: 80 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
  }
}
