import prompt from '@ohos.promptAction';
import router from '@ohos.router';

@Component
export struct Profile {
  @State userName: string = '张三';
  @State userEmail: string = 'zhangsan@example.com';
  @State userAvatar: string = 'https://via.placeholder.com/80';
  
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
  
  // 处理菜单项点击
  private handleMenuItemClick(itemName: string): void {
    prompt.showToast({
      message: `进入${itemName}`,
      duration: 1500
    });
  }

  build() {
    Column() {
      // 用户信息卡片
      Column() {
        // 头像和基本信息
        Row() {
          // 头像
          Column() {
            Image($r('app.media.startIcon'))
              .width(80)
              .height(80)
              .borderRadius(40)
              .backgroundColor('#F0F5FF')
          }
          .margin({ right: 16 })
          
          // 用户信息
          Column() {
            Text(this.userName)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ bottom: 4 })
            
            Text(this.userEmail)
              .fontSize(14)
              .fontColor('#666666')
              .margin({ bottom: 12 })
            
            // 编辑资料按钮
            Row() {
              Text('编辑资料')
                .fontSize(12)
                .fontColor('#007DFF')
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .border({ width: 1, color: '#007DFF', radius: 15 })
                .onClick(() => {
                  this.handleMenuItemClick('编辑资料');
                })
            }
          }
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
        .margin({ bottom: 24 })
        
        // 数据统计
        Row() {
          Column() {
            Text('12')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
            
            Text('关注')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .width('33%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          
          Column() {
            Text('356')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
            
            Text('粉丝')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .width('33%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          
          Column() {
            Text('89')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
            
            Text('动态')
              .fontSize(12)
              .fontColor('#666666')
              .margin({ top: 4 })
          }
          .width('33%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .padding({ top: 16, bottom: 16 })
        .border({ width: { top: 1, bottom: 1 }, color: '#F0F0F0' })
      }
      .width('100%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(16)
      .margin({ top: 16, left: 16, right: 16 })
      
      // 菜单列表
      Column() {
        // 我的收藏
        Row() {
          Image($r('app.media.startIcon'))
            .width(24)
            .height(24)
            .margin({ right: 16 })
          
          Text('我的收藏')
            .fontSize(16)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
          
          Image($r('app.media.foreground'))
            .width(16)
            .height(16)
            .margin({ left: 'auto' })
        }
        .width('100%')
        .padding({ top: 20, bottom: 20 })
        .border({ width: { bottom: 1 }, color: '#F0F0F0' })
        .onClick(() => {
          this.handleMenuItemClick('我的收藏');
        })
        
        // 我的订单
        Row() {
          Image($r('app.media.foreground'))
            .width(24)
            .height(24)
            .margin({ right: 16 })
          
          Text('我的订单')
            .fontSize(16)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
          
          Image($r('app.media.startIcon'))
            .width(16)
            .height(16)
            .margin({ left: 'auto' })
        }
        .width('100%')
        .padding({ top: 20, bottom: 20 })
        .border({ width: { bottom: 1 }, color: '#F0F0F0' })
        .onClick(() => {
          this.handleMenuItemClick('我的订单');
        })
        
        // 设置
        Row() {
          Image($r('app.media.startIcon'))
            .width(24)
            .height(24)
            .margin({ right: 16 })
          
          Text('设置')
            .fontSize(16)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
          
          Image($r('app.media.foreground'))
            .width(16)
            .height(16)
            .margin({ left: 'auto' })
        }
        .width('100%')
        .padding({ top: 20, bottom: 20 })
        .border({ width: { bottom: 1 }, color: '#F0F0F0' })
        .onClick(() => {
          this.handleMenuItemClick('设置');
        })
        
        // 帮助与反馈
        Row() {
          Image($r('app.media.foreground'))
            .width(24)
            .height(24)
            .margin({ right: 16 })
          
          Text('帮助与反馈')
            .fontSize(16)
            .fontColor('#333333')
            .fontWeight(FontWeight.Medium)
          
          Image($r('app.media.startIcon'))
            .width(16)
            .height(16)
            .margin({ left: 'auto' })
        }
        .width('100%')
        .padding({ top: 20, bottom: 20 })
        .border({ width: { bottom: 1 }, color: '#F0F0F0' })
        .onClick(() => {
          this.handleMenuItemClick('帮助与反馈');
        })
        
        // 退出登录
        Row() {
          Image($r('app.media.startIcon'))
            .width(24)
            .height(24)
            .margin({ right: 16 })
          
          Text('退出登录')
            .fontSize(16)
            .fontColor('#FF3B30')
            .fontWeight(FontWeight.Medium)
          
          Image($r('app.media.foreground'))
            .width(16)
            .height(16)
            .margin({ left: 'auto' })
        }
        .width('100%')
        .padding({ top: 20, bottom: 20 })
        .onClick(() => {
          this.logout();
        })
      }
      .width('100%')
      .padding({ top: 24, left: 24, right: 24, bottom: 24 }) // 添加底部padding
    }
    .width('100%')
    .backgroundColor('#F8F9FA')
  }
}