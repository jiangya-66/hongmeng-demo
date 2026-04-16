import deviceInfo from '@ohos.deviceInfo';
import prompt from '@ohos.promptAction';

// 设备信息接口
interface DeviceInfoData {
  deviceType: string;
  osFullName: string;
  sdkApiVersion: number;
  displayVersion: string;
  buildVersion: string;
  timestamp: string;
}

// 方法信息接口
interface MethodInfo {
  name: string;
  description: string;
}

// 方法列表接口
interface MethodsResponse {
  methods: MethodInfo[];
}

// 设备信息响应接口
interface DeviceInfoResponse {
  success: boolean;
  data: DeviceInfoData | null;
  message: string;
}

/**
 * JSBridge服务类
 * 提供鸿蒙端与H5页面之间的JavaScript桥接功能
 */
export class JsBridgeService {
  // 单例实例
  private static instance: JsBridgeService | null = null;

  // 获取单例实例
  public static getInstance(): JsBridgeService {
    if (!JsBridgeService.instance) {
      JsBridgeService.instance = new JsBridgeService();
    }
    return JsBridgeService.instance;
  }

  // 私有构造函数
  private constructor() {
    // 初始化
  }

  /**
   * 获取设备信息（仅获取不需要特殊权限的信息）
   * @returns 设备信息对象
   */
  public getDeviceInfo(): DeviceInfoResponse {
    try {
      const deviceInfoData: DeviceInfoData = {
        // 设备基本信息
        deviceType: deviceInfo.deviceType || '未知',
        
        // 系统信息
        osFullName: deviceInfo.osFullName || '未知',
        sdkApiVersion: Number(deviceInfo.sdkApiVersion) || 0,
        displayVersion: deviceInfo.displayVersion || '未知',
        buildVersion: String(deviceInfo.buildVersion) || '未知',
        
        // 时间戳
        timestamp: new Date().toISOString(),
      };

      console.info('JsBridgeService: 成功获取设备信息（仅公开信息）');
      return {
        success: true,
        data: deviceInfoData,
        message: '设备信息获取成功（仅公开信息）'
      };
    } catch (error) {
      console.error(`JsBridgeService: 获取设备信息失败: ${JSON.stringify(error)}`);
      return {
        success: false,
        data: null,
        message: `获取设备信息失败: ${error.message || error}`
      };
    }
  }

  /**
   * 测试方法 - 返回简单字符串
   * @returns 测试字符串
   */
  public testMethod(): string {
    return 'JSBridge连接成功！当前时间：' + new Date().toLocaleString();
  }

  /**
   * 显示提示信息
   * @param message 要显示的消息
   */
  public showToast(message: string): void {
    prompt.showToast({
      message: message,
      duration: 2000
    });
  }

  /**
   * 获取所有可用的JSBridge方法
   * @returns 方法列表
   */
  public getMethods(): MethodsResponse {
    const methods: MethodInfo[] = [
      { name: 'getDeviceInfo', description: '获取设备信息' },
      { name: 'testMethod', description: '测试方法，返回连接状态' },
      { name: 'showToast', description: '显示提示信息' },
      { name: 'getMethods', description: '获取所有可用方法' }
    ];
    
    return {
      methods: methods
    };
  }
}