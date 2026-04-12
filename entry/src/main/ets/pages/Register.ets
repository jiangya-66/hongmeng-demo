import router from '@ohos.router';
import prompt from '@ohos.promptAction';
import { httpService } from '../services/HttpService';

@Entry
@Component
export struct Register {
  @State username: string = '';
  @State email: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State isPasswordVisible: boolean = false;
  @State isConfirmPasswordVisible: boolean = false;
  @State isLoading: boolean = false;
  @State errorMessage: string = '';
  @State agreeToTerms: boolean = false;

  // 处理注册
  private async handleRegister(): Promise<void> {
    // 验证输入
    if (!this.username.trim()) {
      this.errorMessage = '请输入用户名';
      return;
    }

    if (!this.email.trim()) {
      this.errorMessage = '请输入邮箱';
      return;
    }

    if (!this.validateEmail(this.email)) {
      this.errorMessage = '请输入有效的邮箱地址';
      return;
    }

    if (!this.password.trim()) {
      this.errorMessage = '请输入密码';
      return;
    }

    if (this.password.length < 6) {
      this.errorMessage = '密码长度不能少于6位';
      return;
    }

    if (this.password !== this.confirmPassword) {
      this.errorMessage = '两次输入的密码不一致';
      return;
    }

    if (!this.agreeToTerms) {
      this.errorMessage = '请阅读并同意用户协议';
      return;
    }

    // 清除错误信息
    this.errorMessage = '';
    this.isLoading = true;

    try {
      // 调用注册API
      const response = await httpService.register(this.username, this.password, this.confirmPassword, this.email);
      
      this.isLoading = false;
      
      // 注册成功
      prompt.showToast({
        message: '注册成功！请登录',
        duration: 2000
      });

      // 延迟2秒后跳转到登录页
      setTimeout(() => {
        router.back();
      }, 2000);
      
    } catch (err) {
      // 注册失败
      this.isLoading = false;
      const errorMessage = (err as Error).message || '注册失败，请稍后重试';
      this.errorMessage = errorMessage;
      
      // 显示错误提示
      prompt.showToast({
        message: errorMessage,
        duration: 2000
      });
      
      console.error('注册失败:', err instanceof Error ? err.message : '未知错误');
    }
  }

  // 验证邮箱格式
  private validateEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  // 切换密码可见性
  private togglePasswordVisibility(): void {
    this.isPasswordVisible = !this.isPasswordVisible;
  }

  // 切换确认密码可见性
  private toggleConfirmPasswordVisibility(): void {
    this.isConfirmPasswordVisible = !this.isConfirmPasswordVisible;
  }

  // 跳转到登录页
  private goToLogin(): void {
    router.back();
  }

  // 查看用户协议
  private viewTerms(): void {
    prompt.showToast({
      message: '用户协议页面开发中',
      duration: 1500
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
            this.goToLogin();
          })

        Text('注册账号')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ left: 12 })

        Blank()
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 60, bottom: 20 })

      // 注册表单
      Scroll() {
        Column() {
          // 表单标题
          Column() {
            Text('创建新账号')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor('#007DFF')
              .margin({ bottom: 8 })

            Text('填写以下信息完成注册')
              .fontSize(16)
              .fontColor('#666666')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .margin({ top: 20, bottom: 40 })

          // 用户名输入框
          Column() {

            Row() {
              Text('用户名')
                .fontSize(14)
                .fontColor('#333333')
                .margin({ right: 8 })
            }
            .width('100%')
            .margin({ bottom: 8 })

            Row() {
              TextInput({ placeholder: '请输入用户名（3-20位字符）', text: this.username })
                .width('100%')
                .height(48)
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

          }
          .width('100%')
          .margin({ bottom: 20 })

          // 邮箱输入框
          Column() {
            Row() {
              Text('邮箱')
                .fontSize(14)
                .fontColor('#333333')
                .margin({ right: 8 })
            }
            .width('100%')
            .margin({ bottom: 8 })
            Row() {
              TextInput({ placeholder: '请输入邮箱地址', text: this.email })
                .width('100%')
                .height(48)
                .padding({ left: 16, right: 16 })
                .borderRadius(12)
                .border({ width: 1, color: this.email ? '#007DFF' : '#E5E5E5' })
                .backgroundColor('#FFFFFF')
                .fontSize(16)
                .onChange((value: string) => {
                  this.email = value;
                  if (this.errorMessage) {
                    this.errorMessage = '';
                  }
                })
            }
          }
          .width('100%')
          .margin({ bottom: 20 })

          // 密码输入框
          Column() {
            Row() {
              Text('密码')
                .fontSize(14)
                .fontColor('#333333')

              Text('至少6位字符')
                .fontSize(12)
                .fontColor('#999999')
                .margin({ left: 8 })
            }
            .width('100%')
            .margin({ bottom: 8 })

            Row() {
              TextInput({
                placeholder: '请输入密码',
                text: this.password
              })
                .width('100%')
                .height(48)
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

              // // 密码可见性切换按钮
              // Image(this.isPasswordVisible ? $r('app.media.startIcon') : $r('app.media.foreground'))
              //   .width(24)
              //   .height(24)
              //   .margin({ left: 12 })
              //   .onClick(() => {
              //     this.togglePasswordVisibility();
              //   })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .margin({ bottom: 20 })

          // 确认密码输入框
          Column() {
            Row () {
              Text('确认密码')
                .fontSize(14)
                .fontColor('#333333')
                .margin({ bottom: 8 })
            }
            .width('100%')
            .margin({ bottom: 8 })

            Row() {
              TextInput({
                placeholder: '请再次输入密码',
                text: this.confirmPassword
              })
                .width('100%')
                .height(48)
                .padding({ left: 16, right: 16 })
                .borderRadius(12)
                .border({ width: 1, color: this.confirmPassword ? '#007DFF' : '#E5E5E5' })
                .backgroundColor('#FFFFFF')
                .fontSize(16)
                .type(this.isConfirmPasswordVisible ? InputType.Normal : InputType.Password)
                .onChange((value: string) => {
                  this.confirmPassword = value;
                  if (this.errorMessage) {
                    this.errorMessage = '';
                  }
                })

              // // 确认密码可见性切换按钮
              // Image(this.isConfirmPasswordVisible ? $r('app.media.startIcon') : $r('app.media.foreground'))
              //   .width(24)
              //   .height(24)
              //   .margin({ left: 12 })
              //   .onClick(() => {
              //     this.toggleConfirmPasswordVisibility();
              //   })
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .width('100%')
          .margin({ bottom: 20 })

          // 用户协议
          Row() {
            Checkbox({ name: 'agree', group: 'terms' })
              .select(this.agreeToTerms)
              .selectedColor('#007DFF')
              .onChange((value: boolean) => {
                this.agreeToTerms = value;
                if (this.errorMessage) {
                  this.errorMessage = '';
                }
              })
              .margin({ right: 8 })

            Text('我已阅读并同意')
              .fontSize(14)
              .fontColor('#666666')

            Text('《用户协议》')
              .fontSize(14)
              .fontColor('#007DFF')
              .margin({ left: 4 })
              .onClick(() => {
                this.viewTerms();
              })

            Text('和')
              .fontSize(14)
              .fontColor('#666666')
              .margin({ left: 4 })

            Text('《隐私政策》')
              .fontSize(14)
              .fontColor('#007DFF')
              .margin({ left: 4 })
              .onClick(() => {
                this.viewTerms();
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

          // 注册按钮
          Button(this.isLoading ? '注册中...' : '立即注册', { type: ButtonType.Capsule })
            .width('100%')
            .height(52)
            .backgroundColor('#007DFF')
            .fontColor('#FFFFFF')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .enabled(!this.isLoading)
            .onClick(async () => {
              await this.handleRegister();
            })
            .margin({ bottom: 24 })

          // 已有账号提示
          Row() {
            Text('已有账号？')
              .fontSize(14)
              .fontColor('#666666')

            Text('立即登录')
              .fontSize(14)
              .fontColor('#007DFF')
              .margin({ left: 4 })
              .onClick(() => {
                this.goToLogin();
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
      Text('© 2024 我的应用 版权所有')
        .fontSize(12)
        .fontColor('#999999')
        .margin({ top: 'auto', bottom: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
  }
}