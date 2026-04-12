import router from '@ohos.router';
import prompt from '@ohos.promptAction';
import { connection } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { httpService } from '../services/HttpService';
import { getStorageService } from '../services/StorageService';

@Entry
@Component
export struct Login {
  @State username: string = '';
  @State password: string = '';
  @State isPasswordVisible: boolean = false;
  @State isLoading: boolean = false;
  @State errorMessage: string = '';
  @State rememberMe: boolean = false;
  
  aboutToAppear(): void {
    // 检查本地存储中是否有记住的用户名
    // 这里可以添加从Preferences读取保存的用户名逻辑
  }
  
  // 检查网络连接
  private async checkNetworkBeforeLogin(): Promise<boolean> {
    try {
      // 使用Promise方式获取默认网络
      const netHandle = await connection.getDefaultNet();
      if (!netHandle) {
        prompt.showToast({
          message: '网络连接不可用，请检查网络设置',
          duration: 2000
        });
        return false;
      }

      // 检查网络ID是否为0（表示无网络）
      if (netHandle.netId === 0) {
        prompt.showToast({
          message: '无网络连接，请检查网络设置',
          duration: 2000
        });
        return false;
      }

      // 使用Promise方式获取网络能力
      const netCapabilities = await connection.getNetCapabilities(netHandle);
      if (!netCapabilities) {
        prompt.showToast({
          message: '无法获取网络状态，请检查网络设置',
          duration: 2000
        });
        return false;
      }

      // 检查是否有网络连接 - 使用bearerTypes数组判断
      const bearerTypes = netCapabilities.bearerTypes;
      if (!bearerTypes || bearerTypes.length === 0) {
        prompt.showToast({
          message: '无网络连接类型，请检查网络设置',
          duration: 2000
        });
        return false;
      }

      console.info('网络连接检查成功 - 网络类型:', JSON.stringify(bearerTypes));
      return true;
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '未知错误';
      console.error('网络连接检查失败:', errorMessage);
      prompt.showToast({
        message: '网络连接检查失败，请重试',
        duration: 2000
      });
      return false;
    }
  }

  // 处理登录
  private async handleLogin(): Promise<void> {
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

    // 检查网络连接
    const isNetworkAvailable = await this.checkNetworkBeforeLogin();
    if (!isNetworkAvailable) {
      this.isLoading = false;
      this.errorMessage = '网络连接不可用，请检查网络设置';
      return;
    }
    
    try {
      // 调用登录API
      const response = await httpService.login(this.username, this.password);
      
      // 验证响应数据
      if (!response || typeof response !== 'object') {
        throw new Error('登录响应无效');
      }
      
      if (!response.token || typeof response.token !== 'string') {
        throw new Error('登录响应缺少有效的token');
      }
      
      // 登录成功，保存token到本地存储
      try {
        const storageService = await getStorageService();
        await storageService.saveAuthToken(response.token);
        
        // 如果有用户信息，也保存起来
        if (response.userInfo) {
          await storageService.saveUserInfo(response.userInfo);
        }
      } catch (storageError) {
        console.error('保存认证信息失败:', storageError);
        throw new Error('保存登录信息失败，请稍后重试');
      }
      
      // 保存记住我选项
      if (this.rememberMe) {
        // 这里可以添加保存用户名到Preferences的逻辑
      }
      
      // 显示成功提示
      prompt.showToast({
        message: '登录成功！',
        duration: 1500
      });
      
      // 延迟跳转到主页，让用户看到成功提示
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/Home'
        });
      }, 1500);
      
    } catch (err) {
      // 登录失败，显示错误信息
      this.isLoading = false;
      
      // 根据错误类型显示不同的错误消息
      let errorMessage = '登录失败，请稍后重试';
      if (err instanceof Error) {
        const errMsg = err.message.toLowerCase();
        console.error('登录失败详情:', errMsg);
        
        if (errMsg.includes('network') || errMsg.includes('网络') || errMsg.includes('连接') || errMsg.includes('connect')) {
          errorMessage = '网络连接失败，请检查网络设置和API服务器地址';
        } else if (errMsg.includes('timeout') || errMsg.includes('超时')) {
          errorMessage = '请求超时，请检查网络连接或稍后重试';
        } else if (errMsg.includes('token') || errMsg.includes('响应') || errMsg.includes('json') || errMsg.includes('解析')) {
          errorMessage = '服务器响应异常，请稍后重试';
        } else if (errMsg.includes('storage') || errMsg.includes('保存')) {
          errorMessage = '保存登录信息失败，请稍后重试';
        } else if (errMsg.includes('permission') || errMsg.includes('权限')) {
          errorMessage = '网络权限不足，请检查应用权限设置';
        } else if (errMsg.includes('用户名') || errMsg.includes('密码') || errMsg.includes('验证失败')) {
          errorMessage = '用户名或密码错误';
        } else if (errMsg.includes('http') && errMsg.includes('error')) {
          const match = errMsg.match(/http error[:\s]*(\d+)/i);
          if (match && match[1]) {
            const statusCode = match[1];
            if (statusCode === '404') {
              errorMessage = 'API接口不存在，请联系管理员';
            } else if (statusCode === '500') {
              errorMessage = '服务器内部错误，请稍后重试';
            } else {
              errorMessage = `服务器错误: HTTP ${statusCode}`;
            }
          } else {
            errorMessage = '服务器请求失败，请稍后重试';
          }
        } else {
          errorMessage = err.message || '未知错误';
        }
      }
      
      this.errorMessage = errorMessage;
      
      // 显示错误提示
      prompt.showToast({
        message: errorMessage,
        duration: 3000
      });
      
      console.error('登录失败详情:', err);
    }
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
  
  // 跳转到网络测试页面
  private testNetworkConnection(): void {
    router.pushUrl({
      url: 'pages/NetworkTest'
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
              .fontSize(16)
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
                .fontSize(16)
                .fontColor('#333333')
                .width('100%')

            }
            .width('100%')
            .margin({ bottom: 8 })
            
            Row() {
              TextInput({
                placeholder: '请输入密码',
                text: this.password
              })
                .width('100%')
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
            .onClick(async () => {
              await this.handleLogin();
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
          .margin({ bottom: 20 })
          
          // 网络测试按钮
          Row() {
            Text('网络连接有问题？')
              .fontSize(14)
              .fontColor('#666666')
            
            Text('测试网络连接')
              .fontSize(14)
              .fontColor('#FF6B35')
              .margin({ left: 4 })
              .onClick(() => {
                this.testNetworkConnection();
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