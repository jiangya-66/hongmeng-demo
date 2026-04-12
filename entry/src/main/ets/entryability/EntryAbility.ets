import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { StorageService } from '../services/StorageService';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  private storageService: StorageService | null = null;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
    
    // 销毁存储服务
    if (this.storageService) {
      this.storageService.destroy();
      this.storageService = null;
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    // 初始化存储服务
    this.initializeStorageService();

    windowStage.loadContent('pages/Splash', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }

  /**
   * 初始化存储服务
   */
  private async initializeStorageService(): Promise<void> {
    try {
      this.storageService = await StorageService.getInstance(this.context);
      hilog.info(DOMAIN, 'testTag', 'StorageService initialized successfully');
      
      // 检查是否是首次启动
      const isFirstLaunch = await this.storageService.isFirstLaunch();
      if (isFirstLaunch) {
        hilog.info(DOMAIN, 'testTag', 'First launch detected');
        await this.storageService.markFirstLaunchCompleted();
      }
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', 'Failed to initialize StorageService: %{public}s', JSON.stringify(error));
    }
  }

  /**
   * 获取存储服务实例
   */
  public getStorageService(): StorageService | null {
    return this.storageService;
  }
}