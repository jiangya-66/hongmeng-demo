import { http } from '@kit.NetworkKit';
import { connection } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { JSON } from '@kit.ArkTS';
import { UserInfo } from './StorageService';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

/**
 * API响应数据接口
 */
export interface ApiResponse {
  code: number;
  message: string;
  data?: object;  // 改为可选字段
  token?: string; // 添加token字段支持
}

/**
 * 登录API响应数据接口
 */
interface LoginApiResponse {
  code: number;
  message: string;
  token?: string;
}

/**
 * 登录响应数据接口
 */
export interface LoginResponse {
  token: string;
  userInfo?: UserInfo;
}

/**
 * 注册响应数据接口
 */
export interface RegisterResponse {
  id?: number;
  username?: string;
  email?: string;
  createdAt?: string;
}

/**
 * HTTP请求数据接口
 */
export interface RequestData {
  username?: string;
  password?: string;
  repassword?: string;
  email?: string;
}

/**
 * 网络请求服务类
 */
export class HttpService {
  private static instance: HttpService;
  private httpRequest: http.HttpRequest;
  private baseUrl: string = 'http://big-event-vue-api-t.itheima.net/api';

  private constructor() {
    this.httpRequest = http.createHttp();
  }

  /**
   * 获取单例实例
   */
  public static getInstance(): HttpService {
    if (!HttpService.instance) {
      HttpService.instance = new HttpService();
    }
    return HttpService.instance;
  }

  /**
   * 检查网络是否可用
   */
  private async checkNetworkConnection(): Promise<boolean> {
    try {
      // 使用Promise方式获取默认网络
      const netHandle = await connection.getDefaultNet();
      if (!netHandle) {
        hilog.error(DOMAIN, 'HttpService', '网络连接检查失败: 无默认网络');
        return false;
      }

      // 检查网络ID是否为0（表示无网络）
      if (netHandle.netId === 0) {
        hilog.error(DOMAIN, 'HttpService', '网络连接检查失败: 无网络连接，netId为0');
        return false;
      }

      // 使用Promise方式获取网络能力
      const netCapabilities = await connection.getNetCapabilities(netHandle);
      if (!netCapabilities) {
        hilog.error(DOMAIN, 'HttpService', '网络连接检查失败: 无法获取网络能力');
        return false;
      }

      // 检查是否有网络连接 - 使用bearerTypes数组判断
      const bearerTypes = netCapabilities.bearerTypes;
      if (!bearerTypes || bearerTypes.length === 0) {
        hilog.error(DOMAIN, 'HttpService', '网络连接检查失败: 无网络连接类型');
        return false;
      }

      // 检查是否有互联网能力
      const linkUpBandwidthKbps = netCapabilities.linkUpBandwidthKbps;
      const linkDownBandwidthKbps = netCapabilities.linkDownBandwidthKbps;
      
      hilog.info(DOMAIN, 'HttpService', '网络连接检查成功 - 网络类型: %{public}s, 上行带宽: %{public}d, 下行带宽: %{public}d', 
        JSON.stringify(bearerTypes), linkUpBandwidthKbps, linkDownBandwidthKbps);
      return true;
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '未知错误';
      hilog.error(DOMAIN, 'HttpService', '网络连接检查异常: %{public}s', errorMessage);
      return false;
    }
  }

  /**
   * 发起POST请求
   */
  public async post<T>(url: string, data: RequestData): Promise<T> {
    try {
      // // 检查网络连接
      // const isNetworkAvailable = await this.checkNetworkConnection();
      // if (!isNetworkAvailable) {
      //   throw new Error('网络连接不可用，请检查网络设置');
      // }

      const fullUrl = `${this.baseUrl}${url}`;
      hilog.info(DOMAIN, 'HttpService', 'POST请求开始: %{public}s', fullUrl);
      hilog.info(DOMAIN, 'HttpService', '请求数据: %{public}s', JSON.stringify(data));
      
      const options: http.HttpRequestOptions = {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        // extraData: JSON.stringify(data),
        extraData: data,
        connectTimeout: 10000, // 10秒连接超时
        readTimeout: 10000     // 10秒读取超时
      };

      hilog.info(DOMAIN, 'HttpService', '请求选项: %{public}s', JSON.stringify(options));
      
      const response = await this.httpRequest.request(fullUrl, options);
      
      hilog.info(DOMAIN, 'HttpService', '响应状态码: %{public}d', response.responseCode);
      hilog.info(DOMAIN, 'HttpService', '响应头: %{public}s', JSON.stringify(response.header));
      
      if (response.responseCode === 200) {
        // 检查响应结果是否存在
        if (!response.result) {
          hilog.error(DOMAIN, 'HttpService', 'API响应为空，响应头: %{public}s', JSON.stringify(response.header));
          throw new Error('API响应为空');
        }
        
        hilog.info(DOMAIN, 'HttpService', '响应结果长度: %{public}d', (response.result as string).length);
        hilog.debug(DOMAIN, 'HttpService', '响应结果: %{public}s', response.result as string);
        
        try {
          const result = JSON.parse(response.result as string) as ApiResponse;
          
          // 验证API响应格式
          if (typeof result !== 'object' || result === null) {
            hilog.error(DOMAIN, 'HttpService', 'API响应格式无效，响应内容: %{public}s', response.result as string);
            throw new Error('API响应格式无效');
          }
          
          hilog.info(DOMAIN, 'HttpService', 'API响应码: %{public}d, 消息: %{public}s', result.code, result.message || '无消息');
          
          if (result.code === 0) {
            // 检查data是否存在
            if (!result.data) {
              hilog.error(DOMAIN, 'HttpService', 'API响应数据为空，响应: %{public}s', JSON.stringify(result));
              throw new Error('API响应数据为空');
            }
            
            hilog.info(DOMAIN, 'HttpService', 'API请求成功，返回数据');
            return result.data as T;
          } else {
            hilog.error(DOMAIN, 'HttpService', 'API请求失败: 代码=%{public}d, 消息=%{public}s', result.code, result.message || '请求失败');
            throw new Error(result.message || '请求失败');
          }
        } catch (parseError) {
          const parseErrorMessage = parseError instanceof Error ? parseError.message : '未知解析错误';
          hilog.error(DOMAIN, 'HttpService', 'JSON解析失败: %{public}s, 原始响应: %{public}s', parseErrorMessage, response.result as string);
          throw new Error('API响应格式错误: ' + parseErrorMessage);
        }
      } else {
        hilog.error(DOMAIN, 'HttpService', 'HTTP错误: %{public}d, 错误信息: %{public}s', response.responseCode, response.result || '无错误信息');
        throw new Error(`HTTP错误: ${response.responseCode}`);
      }
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '未知错误';
      const errorStack = err instanceof Error ? err.stack : '无堆栈信息';
      hilog.error(DOMAIN, 'HttpService', 'HTTP请求异常: %{public}s', errorMessage);
      hilog.error(DOMAIN, 'HttpService', '错误堆栈: %{public}s', errorStack);
      console.error('HTTP请求失败:', errorMessage, errorStack);
      
      // 根据错误类型提供更具体的错误消息
      if (errorMessage.includes('Network') || errorMessage.includes('network') || errorMessage.includes('连接') || errorMessage.includes('connect')) {
        throw new Error('网络连接失败，请检查网络设置和API服务器地址');
      } else if (errorMessage.includes('timeout') || errorMessage.includes('超时')) {
        throw new Error('请求超时，请检查网络连接或稍后重试');
      } else if (errorMessage.includes('JSON') || errorMessage.includes('解析')) {
        throw new Error('服务器响应格式错误，请联系管理员');
      } else if (errorMessage.includes('Permission') || errorMessage.includes('permission') || errorMessage.includes('权限')) {
        throw new Error('网络权限不足，请检查应用权限设置');
      } else if (errorMessage.includes('ENETUNREACH') || errorMessage.includes('ECONNREFUSED')) {
        throw new Error('无法连接到服务器，请检查API地址是否正确');
      } else if (errorMessage.includes('cleartext') || errorMessage.includes('CLEARTEXT')) {
        throw new Error('HTTP明文传输被阻止，请使用HTTPS或配置网络安全策略');
      } else if (errorMessage.includes('SSL') || errorMessage.includes('certificate')) {
        throw new Error('SSL证书验证失败，请检查服务器证书');
      } else {
        throw new Error('网络请求失败: ' + errorMessage);
      }
    }
  }

  /**
   * 用户登录
   */
  public async login(username: string, password: string): Promise<LoginResponse> {
    try {
      const requestData: RequestData = { username, password };
      const fullUrl = `${this.baseUrl}/login`;
      hilog.info(DOMAIN, 'HttpService', 'POST请求开始: %{public}s', fullUrl);
      hilog.info(DOMAIN, 'HttpService', '请求数据: %{public}s', JSON.stringify(requestData));
      
      const options: http.HttpRequestOptions = {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: requestData,
        connectTimeout: 10000,
        readTimeout: 10000
      };

      hilog.info(DOMAIN, 'HttpService', '请求选项: %{public}s', JSON.stringify(options));
      
      const response = await this.httpRequest.request(fullUrl, options);
      
      hilog.info(DOMAIN, 'HttpService', '响应状态码: %{public}d', response.responseCode);
      hilog.info(DOMAIN, 'HttpService', '响应头: %{public}s', JSON.stringify(response.header));
      
      if (response.responseCode === 200) {
        // 检查响应结果是否存在
        if (!response.result) {
          hilog.error(DOMAIN, 'HttpService', 'API响应为空，响应头: %{public}s', JSON.stringify(response.header));
          throw new Error('API响应为空');
        }
        
        hilog.info(DOMAIN, 'HttpService', '响应结果长度: %{public}d', (response.result as string).length);
        hilog.debug(DOMAIN, 'HttpService', '响应结果: %{public}s', response.result as string);
        
        try {
          const result = JSON.parse(response.result as string) as LoginApiResponse;
          
          // 验证API响应格式
          if (typeof result !== 'object' || result === null) {
            hilog.error(DOMAIN, 'HttpService', 'API响应格式无效，响应内容: %{public}s', response.result as string);
            throw new Error('API响应格式无效');
          }
          
          hilog.info(DOMAIN, 'HttpService', 'API响应码: %{public}d, 消息: %{public}s', result.code, result.message || '无消息');
          
          if (result.code === 0) {
            // 登录API特殊处理：直接返回token
            if (!result.token) {
              hilog.error(DOMAIN, 'HttpService', '登录响应缺少token，响应: %{public}s', JSON.stringify(result));
              throw new Error('登录响应缺少token');
            }
            
            hilog.info(DOMAIN, 'HttpService', '登录成功，返回token');
            return { token: result.token };
          } else {
            hilog.error(DOMAIN, 'HttpService', '登录失败: 代码=%{public}d, 消息=%{public}s', result.code, result.message || '请求失败');
            throw new Error(result.message || '登录失败');
          }
        } catch (parseError) {
          const parseErrorMessage = parseError instanceof Error ? parseError.message : '未知解析错误';
          hilog.error(DOMAIN, 'HttpService', 'JSON解析失败: %{public}s, 原始响应: %{public}s', parseErrorMessage, response.result as string);
          throw new Error('API响应格式错误: ' + parseErrorMessage);
        }
      } else {
        hilog.error(DOMAIN, 'HttpService', 'HTTP错误: %{public}d, 错误信息: %{public}s', response.responseCode, response.result || '无错误信息');
        throw new Error(`HTTP错误: ${response.responseCode}`);
      }
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '未知错误';
      const errorStack = err instanceof Error ? err.stack : '无堆栈信息';
      hilog.error(DOMAIN, 'HttpService', 'HTTP请求异常: %{public}s', errorMessage);
      hilog.error(DOMAIN, 'HttpService', '错误堆栈: %{public}s', errorStack);
      console.error('HTTP请求失败:', errorMessage, errorStack);
      
      // 根据错误类型提供更具体的错误消息
      if (errorMessage.includes('Network') || errorMessage.includes('network') || errorMessage.includes('连接') || errorMessage.includes('connect')) {
        throw new Error('网络连接失败，请检查网络设置和API服务器地址');
      } else if (errorMessage.includes('timeout') || errorMessage.includes('超时')) {
        throw new Error('请求超时，请检查网络连接或稍后重试');
      } else if (errorMessage.includes('JSON') || errorMessage.includes('解析')) {
        throw new Error('服务器响应格式错误，请联系管理员');
      } else if (errorMessage.includes('Permission') || errorMessage.includes('permission') || errorMessage.includes('权限')) {
        throw new Error('网络权限不足，请检查应用权限设置');
      } else if (errorMessage.includes('ENETUNREACH') || errorMessage.includes('ECONNREFUSED')) {
        throw new Error('无法连接到服务器，请检查API地址是否正确');
      } else if (errorMessage.includes('cleartext') || errorMessage.includes('CLEARTEXT')) {
        throw new Error('HTTP明文传输被阻止，请使用HTTPS或配置网络安全策略');
      } else if (errorMessage.includes('SSL') || errorMessage.includes('certificate')) {
        throw new Error('SSL证书验证失败，请检查服务器证书');
      } else {
        throw new Error('网络请求失败: ' + errorMessage);
      }
    }
  }

  /**
   * 用户注册
   */
  public async register(username: string, password: string, repassword: string, email?: string): Promise<RegisterResponse> {
    try {
      const requestData: RequestData = { username, password, repassword, email };
      const fullUrl = `${this.baseUrl}/reg`;
      hilog.info(DOMAIN, 'HttpService', 'POST请求开始: %{public}s', fullUrl);
      hilog.info(DOMAIN, 'HttpService', '请求数据: %{public}s', JSON.stringify(requestData));
      
      const options: http.HttpRequestOptions = {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: requestData,
        connectTimeout: 10000,
        readTimeout: 10000
      };

      hilog.info(DOMAIN, 'HttpService', '请求选项: %{public}s', JSON.stringify(options));
      
      const response = await this.httpRequest.request(fullUrl, options);
      
      hilog.info(DOMAIN, 'HttpService', '响应状态码: %{public}d', response.responseCode);
      hilog.info(DOMAIN, 'HttpService', '响应头: %{public}s', JSON.stringify(response.header));
      
      if (response.responseCode === 200) {
        // 检查响应结果是否存在
        if (!response.result) {
          hilog.error(DOMAIN, 'HttpService', 'API响应为空，响应头: %{public}s', JSON.stringify(response.header));
          throw new Error('API响应为空');
        }
        
        hilog.info(DOMAIN, 'HttpService', '响应结果长度: %{public}d', (response.result as string).length);
        hilog.debug(DOMAIN, 'HttpService', '响应结果: %{public}s', response.result as string);
        
        try {
          const result = JSON.parse(response.result as string) as ApiResponse;
          
          // 验证API响应格式
          if (typeof result !== 'object' || result === null) {
            hilog.error(DOMAIN, 'HttpService', 'API响应格式无效，响应内容: %{public}s', response.result as string);
            throw new Error('API响应格式无效');
          }
          
          hilog.info(DOMAIN, 'HttpService', 'API响应码: %{public}d, 消息: %{public}s', result.code, result.message || '无消息');
          
          if (result.code === 0) {
            // 注册成功，返回空RegisterResponse对象
            hilog.info(DOMAIN, 'HttpService', '注册成功');
            return {} as RegisterResponse;
          } else {
            hilog.error(DOMAIN, 'HttpService', '注册失败: 代码=%{public}d, 消息=%{public}s', result.code, result.message || '请求失败');
            throw new Error(result.message || '注册失败');
          }
        } catch (parseError) {
          const parseErrorMessage = parseError instanceof Error ? parseError.message : '未知解析错误';
          hilog.error(DOMAIN, 'HttpService', 'JSON解析失败: %{public}s, 原始响应: %{public}s', parseErrorMessage, response.result as string);
          throw new Error('API响应格式错误: ' + parseErrorMessage);
        }
      } else {
        hilog.error(DOMAIN, 'HttpService', 'HTTP错误: %{public}d, 错误信息: %{public}s', response.responseCode, response.result || '无错误信息');
        throw new Error(`HTTP错误: ${response.responseCode}`);
      }
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '未知错误';
      const errorStack = err instanceof Error ? err.stack : '无堆栈信息';
      hilog.error(DOMAIN, 'HttpService', 'HTTP请求异常: %{public}s', errorMessage);
      hilog.error(DOMAIN, 'HttpService', '错误堆栈: %{public}s', errorStack);
      console.error('HTTP请求失败:', errorMessage, errorStack);
      
      // 根据错误类型提供更具体的错误消息
      if (errorMessage.includes('Network') || errorMessage.includes('network') || errorMessage.includes('连接') || errorMessage.includes('connect')) {
        throw new Error('网络连接失败，请检查网络设置和API服务器地址');
      }
      throw new Error('注册失败: ' + errorMessage);
    }
  }

  /**
   * 测试API服务器连接
   */
  public async testApiConnection(): Promise<boolean> {
    try {
      hilog.info(DOMAIN, 'HttpService', '开始测试API服务器连接');
      
      // 检查网络连接
      const isNetworkAvailable = await this.checkNetworkConnection();
      if (!isNetworkAvailable) {
        hilog.error(DOMAIN, 'HttpService', 'API连接测试失败: 网络不可用');
        return false;
      }

      const testUrl = `${this.baseUrl}/login`;
      hilog.info(DOMAIN, 'HttpService', '测试API连接URL: %{public}s', testUrl);
      
      const response = await this.httpRequest.request(testUrl, {
        method: http.RequestMethod.GET,
        connectTimeout: 5000,
        readTimeout: 5000
      });

      hilog.info(DOMAIN, 'HttpService', 'API连接测试响应状态码: %{public}d', response.responseCode);
      
      // 如果返回200或404都表示服务器可达（404表示接口存在但参数错误）
      if (response.responseCode === 200 || response.responseCode === 404) {
        hilog.info(DOMAIN, 'HttpService', 'API服务器连接成功');
        return true;
      } else {
        hilog.error(DOMAIN, 'HttpService', 'API服务器连接失败，状态码: %{public}d', response.responseCode);
        return false;
      }
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : '未知错误';
      hilog.error(DOMAIN, 'HttpService', 'API连接测试异常: %{public}s', errorMessage);
      return false;
    }
  }

  /**
   * 销毁HTTP请求实例
   */
  public destroy(): void {
    this.httpRequest.destroy();
  }
}

// 导出单例实例
export const httpService = HttpService.getInstance();