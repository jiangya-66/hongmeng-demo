import preferences from '@ohos.data.preferences';
import { common } from '@kit.AbilityKit';
import { JSON } from '@kit.ArkTS';

/**
 * 存储键名常量
 */
export class StorageKeys {
  // 用户认证相关
  static readonly AUTH_TOKEN = 'auth_token';
  static readonly USER_INFO = 'user_info';
  static readonly IS_LOGGED_IN = 'is_logged_in';
  
  // 应用设置相关
  static readonly FIRST_LAUNCH = 'first_launch';
  static readonly THEME_MODE = 'theme_mode';
  static readonly LANGUAGE = 'language';
}

/**
 * 用户信息接口
 */
export interface UserInfo {
  id: number;
  username: string;
  email?: string;
  createdAt?: string;
}

/**
 * 本地存储服务类
 */
export class StorageService {
  public static instance: StorageService | null = null;
  private preferences: preferences.Preferences | null = null;
  private context: common.UIAbilityContext | null = null;
  private readonly PREFERENCES_NAME = 'app_storage';

  constructor() {}

  /**
   * 初始化存储服务
   */
  public async initialize(context: common.UIAbilityContext): Promise<void> {
    this.context = context;
    try {
      this.preferences = await preferences.getPreferences(context, this.PREFERENCES_NAME);
      console.info('StorageService initialized successfully');
    } catch (err) {
      console.error('Failed to initialize StorageService:', err instanceof Error ? err.message : '未知错误');
      throw new Error('Failed to initialize StorageService');
    }
  }

  /**
   * 获取单例实例
   */
  public static async getInstance(context?: common.UIAbilityContext): Promise<StorageService> {
    if (!StorageService.instance) {
      StorageService.instance = new StorageService();
      if (context) {
        await StorageService.instance.initialize(context);
      } else {
        throw new Error('StorageService需要UIAbilityContext进行初始化。请在EntryAbility中调用initializeStorageService()');
      }
    } else if (!StorageService.instance.preferences || !StorageService.instance.context) {
      // 实例存在但未初始化
      if (context) {
        await StorageService.instance.initialize(context);
      } else {
        throw new Error('StorageService实例已存在但未初始化。需要UIAbilityContext进行初始化');
      }
    }
    return StorageService.instance;
  }

  /**
   * 检查是否已初始化
   */
  private checkInitialized(): void {
    if (!this.preferences || !this.context) {
      throw new Error('StorageService not initialized. Call initialize() first.');
    }
  }

  /**
   * 公共方法：检查存储服务是否已初始化
   */
  public isInitialized(): boolean {
    return !!(this.preferences && this.context);
  }

  /**
   * 保存字符串数据
   */
  public async setString(key: string, value: string): Promise<void> {
    this.checkInitialized();
    try {
      await this.preferences!.put(key, value);
      await this.preferences!.flush();
      console.info(`Saved string: ${key} = ${value}`);
    } catch (err) {
      console.error(`Failed to save string for key ${key}:`, err instanceof Error ? err.message : '未知错误');
      throw new Error(`Failed to save string for key ${key}`);
    }
  }

  /**
   * 获取字符串数据
   */
  public async getString(key: string, defaultValue: string = ''): Promise<string> {
    this.checkInitialized();
    try {
      const value = await this.preferences!.get(key, defaultValue);
      return value as string;
    } catch (err) {
      console.error(`Failed to get string for key ${key}:`, JSON.stringify(err));
      return defaultValue;
    }
  }

  /**
   * 保存布尔值数据
   */
  public async setBoolean(key: string, value: boolean): Promise<void> {
    this.checkInitialized();
    try {
      await this.preferences!.put(key, value);
      await this.preferences!.flush();
      console.info(`Saved boolean: ${key} = ${value}`);
    } catch (err) {
      console.error(`Failed to save boolean for key ${key}:`, JSON.stringify(err));
      throw new Error(`Failed to save boolean for key ${key}`);
    }
  }

  /**
   * 获取布尔值数据
   */
  public async getBoolean(key: string, defaultValue: boolean = false): Promise<boolean> {
    this.checkInitialized();
    try {
      const value = await this.preferences!.get(key, defaultValue);
      return value as boolean;
    } catch (err) {
      console.error(`Failed to get boolean for key ${key}:`, JSON.stringify(err));
      return defaultValue;
    }
  }

  /**
   * 保存数字数据
   */
  public async setNumber(key: string, value: number): Promise<void> {
    this.checkInitialized();
    try {
      await this.preferences!.put(key, value);
      await this.preferences!.flush();
      console.info(`Saved number: ${key} = ${value}`);
    } catch (err) {
      console.error(`Failed to save number for key ${key}:`, JSON.stringify(err));
      throw new Error(`Failed to save number for key ${key}`);
    }
  }

  /**
   * 获取数字数据
   */
  public async getNumber(key: string, defaultValue: number = 0): Promise<number> {
    this.checkInitialized();
    try {
      const value = await this.preferences!.get(key, defaultValue);
      return value as number;
    } catch (err) {
      console.error(`Failed to get number for key ${key}:`, JSON.stringify(err));
      return defaultValue;
    }
  }

  /**
   * 保存对象数据（JSON序列化）
   */
  public async setObject<T>(key: string, value: T): Promise<void> {
    this.checkInitialized();
    try {
      const jsonString = JSON.stringify(value as object);
      await this.preferences!.put(key, jsonString);
      await this.preferences!.flush();
      console.info(`Saved object: ${key}`);
    } catch (err) {
      console.error(`Failed to save object for key ${key}:`, JSON.stringify(err));
      throw new Error(`Failed to save object for key ${key}`);
    }
  }

  /**
   * 获取对象数据（JSON反序列化）
   */
  public async getObject<T>(key: string, defaultValue: T): Promise<T> {
    this.checkInitialized();
    try {
      const jsonString = await this.preferences!.get(key, JSON.stringify(defaultValue as object)) as string;
      return JSON.parse(jsonString) as T;
    } catch (err) {
      console.error(`Failed to get object for key ${key}:`, JSON.stringify(err));
      return defaultValue;
    }
  }

  /**
   * 删除指定键的数据
   */
  public async remove(key: string): Promise<void> {
    this.checkInitialized();
    try {
      await this.preferences!.delete(key);
      await this.preferences!.flush();
      console.info(`Removed key: ${key}`);
    } catch (err) {
      console.error(`Failed to remove key ${key}:`, JSON.stringify(err));
      throw new Error(`Failed to remove key ${key}`);
    }
  }

  /**
   * 清空所有数据
   */
  public async clear(): Promise<void> {
    this.checkInitialized();
    try {
      await this.preferences!.clear();
      await this.preferences!.flush();
      console.info('Cleared all storage data');
    } catch (err) {
      console.error('Failed to clear storage:', JSON.stringify(err));
      throw new Error('Failed to clear storage');
    }
  }

  /**
   * 保存用户认证token
   */
  public async saveAuthToken(token: string): Promise<void> {
    await this.setString(StorageKeys.AUTH_TOKEN, token);
    await this.setBoolean(StorageKeys.IS_LOGGED_IN, true);
  }

  /**
   * 获取用户认证token
   */
  public async getAuthToken(): Promise<string> {
    return await this.getString(StorageKeys.AUTH_TOKEN, '');
  }

  /**
   * 清除用户认证信息
   */
  public async clearAuth(): Promise<void> {
    await this.remove(StorageKeys.AUTH_TOKEN);
    await this.remove(StorageKeys.USER_INFO);
    await this.setBoolean(StorageKeys.IS_LOGGED_IN, false);
  }

  /**
   * 检查用户是否已登录
   */
  public async isLoggedIn(): Promise<boolean> {
    const token = await this.getAuthToken();
    const isLoggedIn = await this.getBoolean(StorageKeys.IS_LOGGED_IN, false);
    return token !== '' && isLoggedIn;
  }

  /**
   * 保存用户信息
   */
  public async saveUserInfo(userInfo: UserInfo): Promise<void> {
    await this.setObject(StorageKeys.USER_INFO, userInfo);
  }

  /**
   * 获取用户信息
   */
  public async getUserInfo(): Promise<UserInfo | null> {
    const defaultUserInfo: UserInfo = { id: 0, username: '' };
    const userInfo = await this.getObject<UserInfo>(StorageKeys.USER_INFO, defaultUserInfo);
    return userInfo.id !== 0 ? userInfo : null;
  }

  /**
   * 检查是否是首次启动
   */
  public async isFirstLaunch(): Promise<boolean> {
    return await this.getBoolean(StorageKeys.FIRST_LAUNCH, true);
  }

  /**
   * 标记已非首次启动
   */
  public async markFirstLaunchCompleted(): Promise<void> {
    await this.setBoolean(StorageKeys.FIRST_LAUNCH, false);
  }

  /**
   * 销毁存储实例
   */
  public async destroy(): Promise<void> {
    if (this.preferences) {
      try {
        await this.preferences.flush();
        this.preferences = null;
        this.context = null;
        console.info('StorageService destroyed');
      } catch (err) {
        console.error('Failed to destroy StorageService:', JSON.stringify(err));
      }
    }
  }
}

// 全局存储服务实例
let storageServiceInstance: StorageService | null = null;

/**
 * 获取存储服务实例（简化版，适用于页面组件）
 */
export async function getStorageService(): Promise<StorageService> {
  // 使用StorageService的单例实例
  const instance = StorageService.instance;
  if (!instance) {
    throw new Error('StorageService尚未初始化，请确保在EntryAbility中调用initializeStorageService()');
  }
  
  // 检查实例是否已初始化
  if (!instance.isInitialized()) {
    throw new Error('StorageService实例已存在但未正确初始化');
  }
  
  return instance;
}