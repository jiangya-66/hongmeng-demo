import router from '@ohos.router';
import prompt from '@ohos.promptAction';

@Entry
@Component
export struct Login {
  @State username: string = '';
  @State password: string = '';
  @State isPasswordVisible: boolean = false;
  @State isLoading: boolean = false;
  @State errorMessage: string = '';
  @State rememberMe: boolean = false;
  
  // 模拟用户数据
  private readonly validUsername: string = 'admin';
  private readonly validPassword: string = '123456';
  
  aboutToAppear(): void {
    // 检查本地存储中是否有记住的用户名
    // 这里可以添加从Preferences读取保存的用户名逻辑
  }
  
  // 处理登录
  private handleLogin(): void {
    // 验证输入
    if (!this.username.trim()) {
      this.errorMessage = '请输入用户名';
      return;
    }
    
    if (!this.password.trim()) {
      this.errorMessage = '请输入密码';
      return;
    }
    
    // 清除错误信息
    this.errorMessage = '';
    this.isLoading = true;
    
    // 模拟登录验证（实际项目中应该调用API）
    setTimeout(() => {
      this.isLoading = false;
      
      if (this.username === this.validUsername && this.password === this.validPassword) {
        // 登录成功，跳转到主页
        prompt.showToast({
          message: '登录成功！',
          duration: 1500
        });
        
        // 保存记住我选项
        if (this.rememberMe) {
          // 这里可以添加保存用户名到Preferences的逻辑
        }
        
        // 延迟跳转，让用户看到成功提示
        setTimeout(() => {
          router.replaceUrl({
            url: 'pages/Home'
          });
        }, 1500);
      } else {
        this.errorMessage = '用户名或密码错误';
      }
    }, 1000);
  }
  
  // 切换密码可见性
  private togglePasswordVisibility(): void {
    this.isPasswordVisible = !this.isPasswordVisible;
  }
  
  // 跳转到注册页面
  private goToRegister(): void {
    router.pushUrl({
      url: 'pages/Register'
    });
  }
  
  // 忘记密码
  private forgotPassword(): void {
    prompt.showToast({
      message: '请联系管理员重置密码',
      duration: 2000
    });
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Image($r('app.media.startIcon'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          })

        Text('登录')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ left: 12 })

        Blank()
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 60, bottom: 20 })

      // 登录表单
      Scroll() {
        Column() {
          // 表单标题
          Column() {
            Text('欢迎回来')
              .fontSize(32)
              .fontWeight(FontWeight.Bold)
              .fontColor('#007DFF')
              .margin({ bottom: 8 })
            
            Text('请登录您的账号')
              .fontSize(16)
              .fontColor('#666666')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .margin({ top: 40, bottom: 60 })
          
          // 用户名输入框
          Row() {
            Text('用户名')
              .fontSize(20)
              .fontColor('#333333')
          }
          .width('100%')
          .margin({ bottom: 8 })


          Column() {
            TextInput({ placeholder: '请输入用户名', text: this.username })
              .width('100%')
              .height(52)
              .padding({ left: 16, right: 16 })
              .borderRadius(12)
              .border({ width: 1, color: this.username ? '#007DFF' : '#E5E5E5' })
              .backgroundColor('#FFFFFF')
              .fontSize(16)
              .onChange((value: string) => {
                this.username = value;
                if (this.errorMessage) {
                  this.errorMessage = '';
                }
              })
          }
          .width('100%')
          .margin({ bottom: 24 })
          
          // 密码输入框
          Column() {
            Row() {
              Text('密码')
                .fontSize(18)
                .fontColor('#333333')
            }
            .width('100%')
            .margin({ bottom: 8 })
            
            Row() {
              TextInput({
                placeholder: '请输入密码',
                text: this.password
              })
                .width('90%')
                .height(52)
                .padding({ left: 16, right: 16 })
                .borderRadius(12)
                .border({ width: 1, color: this.password ? '#007DFF' : '#E5E5E5' })
                .backgroundColor('#FFFFFF')
                .fontSize(16)
                .type(this.isPasswordVisible ? InputType.Normal : InputType.Password)
                .onChange((value: string) => {
                  this.password = value;
                  if (this.errorMessage) {
                    this.errorMessage = '';
                  }
                })
              
              // 密码可见性切换按钮
              Image(this.isPasswordVisible ? $r('app.media.startIcon') : $r('app.media.foreground'))
                .width(24)
                .height(24)
                .margin({ left: 12 })
                .onClick(() => {
                  this.togglePasswordVisibility();
                })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .margin({ bottom: 18 })
          
          // 记住我选项
          Row() {
            Checkbox({ name: 'remember', group: 'login' })
              .select(this.rememberMe)
              .selectedColor('#007DFF')
              .onChange((value: boolean) => {
                this.rememberMe = value;
              })
              .margin({ right: 8 })
            
            Text('记住我')
              .fontSize(14)
              .fontColor('#666666')
            
            Blank()

            Text('忘记密码？')
              .fontSize(14)
              .fontColor('#007DFF')
              .margin({ left: 'auto' })
              .onClick(() => {
                this.forgotPassword();
              })
          }
          .width('100%')
          .margin({ bottom: 24 })
          
          // 错误信息显示
          if (this.errorMessage) {
            Text(this.errorMessage)
              .fontSize(14)
              .fontColor('#FF3B30')
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ bottom: 16 })
          }
          
          // 登录按钮
          Button(this.isLoading ? '登录中...' : '登录', { type: ButtonType.Capsule })
            .width('100%')
            .height(52)
            .backgroundColor('#007DFF')
            .fontColor('#FFFFFF')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .enabled(!this.isLoading)
            .onClick(() => {
              this.handleLogin();
            })
            .margin({ bottom: 24 })
          
          // 其他登录方式
          Column() {
            Row() {
              Divider()
                .width('30%')
                .color('#E5E5E5')
              
              Text('其他登录方式')
                .fontSize(14)
                .fontColor('#999999')
                .margin({ left: 16, right: 16 })
              
              Divider()
                .width('30%')
                .color('#E5E5E5')
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: 24 })
            
            Row() {
              Button('微信登录', { type: ButtonType.Normal })
                .width('45%')
                .height(44)
                .backgroundColor('#07C160')
                .fontColor('#FFFFFF')
                .fontSize(14)
                .onClick(() => {
                  prompt.showToast({
                    message: '微信登录开发中',
                    duration: 1500
                  });
                })
              
              Button('QQ登录', { type: ButtonType.Normal })
                .width('45%')
                .height(44)
                .backgroundColor('#12B7F5')
                .fontColor('#FFFFFF')
                .fontSize(14)
                .margin({ left: '10%' })
                .onClick(() => {
                  prompt.showToast({
                    message: 'QQ登录开发中',
                    duration: 1500
                  });
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
          }
          .width('100%')
          .margin({ bottom: 40 })
          
          // 注册提示
          Row() {
            Text('还没有账号？')
              .fontSize(14)
              .fontColor('#666666')
            
            Text('立即注册')
              .fontSize(14)
              .fontColor('#007DFF')
              .margin({ left: 4 })
              .onClick(() => {
                this.goToRegister();
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .margin({ bottom: 40 })
        }
        .width('100%')
        .padding({ left: 40, right: 40 })
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
      
      // 底部版权信息
      Text('© 2024 MyApplication')
        .fontSize(12)
        .fontColor('#999999')
        .margin({ top: 'auto', bottom: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
  }
}