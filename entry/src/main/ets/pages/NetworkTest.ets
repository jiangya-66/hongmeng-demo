import { hilog } from '@kit.PerformanceAnalysisKit';
import { http } from '@kit.NetworkKit';
import prompt from '@ohos.promptAction';
import router from '@ohos.router';

const DOMAIN = 0x0000;

@Entry
@Component
export struct NetworkTest {
  @State message: string = '点击测试网络连接';
  @State isLoading: boolean = false;

  // 测试网络连接
  private async testNetworkConnection(): Promise<void> {
    this.isLoading = true;
    this.message = '正在测试网络连接...';
    
    try {
      // 测试1: 直接使用http.request测试连接
      const httpRequest = http.createHttp();
      const testUrl = 'http://big-event-vue-api-t.itheima.net/api/login';
      
      hilog.info(DOMAIN, 'NetworkTest', '开始测试网络连接: %{public}s', testUrl);
      
      const response = await httpRequest.request(testUrl, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      });
      
      hilog.info(DOMAIN, 'NetworkTest', '网络测试响应状态码: %{public}d', response.responseCode);
      hilog.info(DOMAIN, 'NetworkTest', '网络测试响应结果: %{public}s', JSON.stringify(response.result));
      
      if (response.responseCode === 200) {
        this.message = '网络连接成功！';
        prompt.showToast({
          message: '网络连接测试成功',
          duration: 2000
        });
      } else {
        this.message = `HTTP错误: ${response.responseCode}`;
        prompt.showToast({
          message: `HTTP错误: ${response.responseCode}`,
          duration: 2000
        });
      }
      
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '未知错误';
      hilog.error(DOMAIN, 'NetworkTest', '网络测试失败: %{public}s', errorMessage);
      this.message = `网络连接失败: ${errorMessage}`;
      prompt.showToast({
        message: `网络连接失败: ${errorMessage}`,
        duration: 2000
      });
    } finally {
      this.isLoading = false;
    }
  }

  // 测试本地连接
  private async testLocalConnection(): Promise<void> {
    this.isLoading = true;
    this.message = '正在测试本地连接...';
    
    try {
      const httpRequest = http.createHttp();
      const testUrl = 'http://localhost:8080';
      
      hilog.info(DOMAIN, 'NetworkTest', '开始测试本地连接: %{public}s', testUrl);
      
      const response = await httpRequest.request(testUrl, {
        method: http.RequestMethod.GET,
        connectTimeout: 5000, // 5秒超时
        readTimeout: 5000
      });
      
      hilog.info(DOMAIN, 'NetworkTest', '本地连接测试响应状态码: %{public}d', response.responseCode);
      
      if (response.responseCode === 200) {
        this.message = '本地连接成功！';
      } else {
        this.message = `本地连接HTTP错误: ${response.responseCode}`;
      }
      
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '未知错误';
      hilog.error(DOMAIN, 'NetworkTest', '本地连接测试失败: %{public}s', errorMessage);
      this.message = `本地连接失败: ${errorMessage}`;
    } finally {
      this.isLoading = false;
    }
  }

  // 测试DNS解析
  private async testDNSResolution(): Promise<void> {
    this.isLoading = true;
    this.message = '正在测试DNS解析...';
    
    try {
      // 测试多个常见网站
      const testUrls = [
        'http://www.baidu.com',
        'http://www.qq.com',
        'http://www.163.com'
      ];
      
      const httpRequest = http.createHttp();
      let successCount = 0;
      
      for (const url of testUrls) {
        try {
          hilog.info(DOMAIN, 'NetworkTest', '测试DNS解析: %{public}s', url);
          const response = await httpRequest.request(url, {
            method: http.RequestMethod.GET,
            connectTimeout: 3000,
            readTimeout: 3000
          });
          
          if (response.responseCode === 200) {
            successCount++;
            hilog.info(DOMAIN, 'NetworkTest', 'DNS解析成功: %{public}s', url);
          }
        } catch (err) {
          hilog.error(DOMAIN, 'NetworkTest', 'DNS解析失败 %{public}s: %{public}s', url, err instanceof Error ? err.message : '未知错误');
        }
      }
      
      if (successCount > 0) {
        this.message = `DNS解析成功 (${successCount}/${testUrls.length})`;
        prompt.showToast({
          message: `DNS解析成功 (${successCount}/${testUrls.length})`,
          duration: 2000
        });
      } else {
        this.message = 'DNS解析失败，请检查网络设置';
        prompt.showToast({
          message: 'DNS解析失败，请检查网络设置',
          duration: 2000
        });
      }
      
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '未知错误';
      hilog.error(DOMAIN, 'NetworkTest', 'DNS解析测试失败: %{public}s', errorMessage);
      this.message = `DNS解析测试失败: ${errorMessage}`;
    } finally {
      this.isLoading = false;
    }
  }

  // 返回登录页面
  private goBackToLogin(): void {
    router.back();
  }

  build() {
    Column() {
      Text('网络连接测试')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40, bottom: 20 })

      Text(this.message)
        .fontSize(16)
        .textAlign(TextAlign.Center)
        .margin({ bottom: 30 })
        .width('90%')

      Button('测试API服务器连接')
        .width('80%')
        .height(50)
        .margin({ bottom: 15 })
        .backgroundColor(Color.Blue)
        .enabled(!this.isLoading)
        .onClick(() => {
          this.testNetworkConnection();
        })

      Button('测试DNS解析')
        .width('80%')
        .height(50)
        .margin({ bottom: 15 })
        .backgroundColor(Color.Green)
        .enabled(!this.isLoading)
        .onClick(() => {
          this.testDNSResolution();
        })

      Button('测试本地连接')
        .width('80%')
        .height(50)
        .margin({ bottom: 15 })
        .backgroundColor(Color.Orange)
        .enabled(!this.isLoading)
        .onClick(() => {
          this.testLocalConnection();
        })

      Button('返回登录页面')
        .width('80%')
        .height(50)
        .margin({ top: 30 })
        .backgroundColor(Color.Gray)
        .onClick(() => {
          this.goBackToLogin();
        })

      if (this.isLoading) {
        LoadingProgress()
          .color(Color.Blue)
          .width(50)
          .height(50)
          .margin({ top: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}