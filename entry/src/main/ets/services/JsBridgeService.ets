
import deviceInfo from '@ohos.deviceInfo';
import prompt from '@ohos.promptAction';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';
import Want from '@ohos.app.ability.Want';
import call from '@ohos.telephony.call';

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

// 拨打电话响应接口
interface DialResponse {
  success: boolean;
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
      const err = error as Error;
      console.error(`JsBridgeService: 获取设备信息失败: ${JSON.stringify(err)}`);
      return {
        success: false,
        data: null,
        message: `获取设备信息失败: ${err.message || err}`
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
      { name: 'getMethods', description: '获取所有可用方法' },
      { name: 'makeCall', description: '拨打电话（打开拨号界面）' }
    ];
    
    return {
      methods: methods
    };
  }

  /**
   * 拨打电话（打开拨号界面）
   * @param phoneNumber 电话号码
   * @returns 拨打电话结果
   */
  public makeCall(phoneNumber: string): DialResponse {
    try {
      // 验证电话号码格式
      if (!phoneNumber || phoneNumber.trim() === '') {
        return {
          success: false,
          message: '电话号码不能为空'
        };
      }

      // 简单的电话号码格式验证（支持国际号码格式）
      const phoneRegex = /^[\d\+\-\s\(\)]{5,20}$/;
      if (!phoneRegex.test(phoneNumber)) {
        return {
          success: false,
          message: '电话号码格式不正确，请输入有效的电话号码'
        };
      }

      // 清理电话号码中的空格和特殊字符
      const cleanPhoneNumber = phoneNumber.replace(/\s+/g, '').replace(/[\(\)\-]/g, '');
      
      // 检查设备是否支持语音功能
      try {
        const isVoiceCapable = call.hasVoiceCapability();
        if (!isVoiceCapable) {
          return {
            success: false,
            message: '当前设备不支持语音通话功能'
          };
        }
      } catch (error) {
        const err = error as Error;
        console.warn(`JsBridgeService: 检查语音能力失败: ${err.message || err}`);
        // 继续执行，不中断流程
      }

      // 使用HarmonyOS标准的call.makeCall()方法拉起拨号界面
      // 注意：call.makeCall()不需要特殊权限，而call.dial()需要ohos.permission.PLACE_CALL权限
      call.makeCall(cleanPhoneNumber, (err: BusinessError) => {
        if (err) {
          console.error(`JsBridgeService: 拉起拨号界面失败，错误码: ${err.code}, 信息: ${err.message}`);
          // 显示错误提示
          prompt.showToast({
            message: `拉起拨号界面失败: ${err.message || '未知错误'}`,
            duration: 3000
          });
        } else {
          console.info(`JsBridgeService: 成功拉起拨号界面，电话号码: ${cleanPhoneNumber}`);
        }
      });

      return {
        success: true,
        message: `正在打开拨号界面，电话号码: ${cleanPhoneNumber}`
      };
    } catch (error) {
      const err = error as Error;
      console.error(`JsBridgeService: 拨打电话失败: ${JSON.stringify(err)}`);
      return {
        success: false,
        message: `拨打电话失败: ${err.message || err}`
      };
    }
  }
}