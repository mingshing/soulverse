# Soulverse MVP 設計文件

## 概述

Soulverse MVP 是一個基於 iOS 的心理健康應用程式，採用 MVP (Model-View-Presenter) 架構模式。應用程式整合了情緒追蹤、藝術治療、心理工具和個人成長功能，提供全面的心理健康支援體驗。

## 架構

### 整體架構模式

應用程式採用 MVP (Model-View-Presenter) 架構，結合以下設計模式：

- **MVP Pattern**: 每個功能模組包含 Model、View、Presenter 三層
- **Coordinator Pattern**: 用於導航和流程控制
- **Repository Pattern**: 統一資料存取介面
- **Factory Pattern**: 用於建立服務實例
- **Observer Pattern**: 用於狀態變更通知

### 專案結構 (基於現有架構)

```
Soulverse/
├── 現有結構保持不變:
│   ├── AppDelegate.swift ✓
│   ├── SceneDelegate.swift ✓
│   ├── Constants.swift ✓
│   ├── Shared/ ✓
│   │   ├── Service/ ✓ (重用現有 APIService, Auth, UserService)
│   │   ├── Manager/ ✓
│   │   ├── ViewComponent/ ✓
│   │   ├── Analytics/ ✓
│   │   └── Utility.swift ✓
│   ├── Extensions/ ✓
│   └── Resources/
│       ├── Assets.xcassets/ ✓
│       └── APIMockResponse/ ✓ (重用現有 Mock 架構)
├── 新增功能模組:
│   ├── Authentication/ (擴展現有 Auth)
│   ├── Onboarding/
│   ├── MoodCheckIn/
│   ├── InnerCosmo/
│   ├── SoulInsight/
│   ├── Canvas/
│   ├── Tools/
│   └── SoulQuest/
└── 新增 Mock 資料:
    └── Resources/APIMockResponse/
        ├── MoodResponse.json
        ├── UserProfileResponse.json
        └── AnalyticsResponse.json
```

## 元件和介面

### 1. 核心服務層

#### AuthenticationService
```swift
protocol AuthenticationServiceProtocol {
    func signInWithGoogle() -> Promise<User>
    func signInWithApple() -> Promise<User>
    func signOut() -> Promise<Void>
    func getCurrentUser() -> User?
}
```

#### MoodDataService
```swift
protocol MoodDataServiceProtocol {
    func saveMoodEntry(_ entry: MoodEntry) -> Promise<Void>
    func getMoodHistory(timeRange: TimeRange) -> Promise<[MoodEntry]>
    func getMoodAnalytics() -> Promise<MoodAnalytics>
}
```

#### UserProfileService
```swift
protocol UserProfileServiceProtocol {
    func saveUserProfile(_ profile: UserProfile) -> Promise<Void>
    func getUserProfile() -> Promise<UserProfile>
    func updateUserProgress(_ progress: UserProgress) -> Promise<Void>
}
```

### 2. 共用 UI 元件

#### SoulverseNavigationBar
- 統一的導航欄設計
- 支援標題、左右按鈕自訂
- 整合通知和設定按鈕

#### SoulverseTabBar
- 五個主要標籤的自訂標籤欄
- 支援圖示和標題
- 動畫效果和狀態指示

#### SoulverseButton
- 主要和次要按鈕樣式
- 載入狀態和禁用狀態
- 一致的圓角和陰影效果

#### MoodColorPicker
- 顏色選擇器元件
- 支援顏色深度調整
- 即時預覽功能

#### EmotionTagView
- 情緒標籤顯示元件
- 支援多選和單選模式
- 動畫效果

### 3. 資料模型

#### User Model
```swift
struct User: Codable {
    let id: String
    let email: String
    let name: String
    let birthday: Date
    let gender: Gender
    let planetName: String
    let emoPetName: String
    let selectedTopics: [Topic]
    let createdAt: Date
}
```

#### MoodEntry Model
```swift
struct MoodEntry: Codable {
    let id: String
    let userId: String
    let color: MoodColor
    let intensity: Double
    let emotionTags: [EmotionTag]
    let description: String
    let attribution: AttributionCategory
    let copingStrategy: CopingStrategy
    let recordingMethod: RecordingMethod
    let timestamp: Date
}
```

#### UserProgress Model
```swift
struct UserProgress: Codable {
    let userId: String
    let dimensions: [ProgressDimension]
    let currentStage: TransformationStage
    let completedTasks: [String]
    let activeThemes: [Theme]
}
```

## 資料模型

### 漸進式資料模型定義

資料模型將在實作過程中逐步定義和完善，初期專注於核心功能所需的基本結構：

#### 第一階段 - 基礎模型 (MVP 必需)
- **基本使用者資料**: 註冊和登入所需
- **簡化情緒記錄**: 顏色、標籤、時間戳記
- **導航狀態**: 頁面和流程狀態

#### 第二階段 - 擴展模型 (功能完善)
- **詳細情緒分析**: 完整的情緒檢查資料
- **使用者偏好**: 個人化設定
- **進度追蹤**: 成長和任務資料

#### 第三階段 - 進階模型 (優化和分析)
- **分析和洞察**: 趨勢和模式資料
- **社交功能**: 分享和互動資料
- **個人化推薦**: AI 驅動的建議

### 資料持久化策略

#### 本地儲存 (重用現有架構)
- **UserDefaults**: 使用者偏好和基本設定
- **Keychain**: 敏感資料儲存 (重用現有 KeychainAccess)
- **本地快取**: 離線功能支援

#### 遠端同步 (利用現有 Firebase 整合)
- **Firebase Auth**: 身份驗證 (已整合)
- **Firebase Firestore**: 雲端資料同步
- **Firebase Storage**: 圖片和檔案儲存

## 錯誤處理

### 錯誤類型定義

```swift
enum SoulverseError: Error {
    case authenticationFailed
    case networkUnavailable
    case dataCorrupted
    case userNotFound
    case invalidInput
    case serviceUnavailable
}
```

### 錯誤處理策略

1. **網路錯誤**: 自動重試機制，離線模式支援
2. **驗證錯誤**: 使用者友善的錯誤訊息
3. **資料錯誤**: 資料驗證和修復機制
4. **服務錯誤**: 降級服務和備用方案

### 使用者體驗

- 統一的錯誤提示 UI
- 非阻塞式錯誤處理
- 自動恢復機制
- 離線功能支援

## 測試策略

### 單元測試

#### 測試覆蓋範圍
- **Models**: 資料模型驗證和轉換
- **Services**: API 呼叫和資料處理
- **Presenters**: 業務邏輯和狀態管理
- **Utilities**: 工具函數和擴展

#### 測試工具
- **XCTest**: 基本單元測試框架
- **Quick/Nimble**: BDD 風格測試
- **Mockingbird**: Mock 物件生成

### 整合測試

#### API 測試 (重用現有 Mock 架構)
- **網路層測試**: 利用現有 APIMockResponse 結構
- **Mock 資料測試**: 擴展現有 JSON Mock 檔案
- **錯誤情境測試**: 網路中斷和服務異常

### 效能測試

#### 記憶體管理
- **記憶體洩漏檢測**: Instruments 工具
- **記憶體使用優化**: 圖片和資料快取 (利用現有 Kingfisher)

#### 響應時間
- **啟動時間優化**: 冷啟動和熱啟動
- **頁面載入時間**: 資料載入和 UI 渲染
- **動畫效能**: 60fps 流暢度保證

## 技術實作細節

### 依賴管理 (重用現有設定)
- **CocoaPods**: 第三方函式庫管理 ✓
- **現有依賴重用**: 
  - Alamofire (網路請求) ✓
  - Kingfisher (圖片載入) ✓
  - SnapKit (Auto Layout) ✓
  - Firebase SDK (後端服務) ✓
  - IQKeyboardManagerSwift ✓
  - SwiftMessages (Toast 訊息) ✓
- **新增依賴** (如需要):
  - 3D 渲染函式庫 (用於星球視覺化)
  - 繪畫功能函式庫 (用於 Canvas)

### 設計系統
- **顏色系統**: 主題色彩和語意色彩
- **字型系統**: 層級化字型規範
- **間距系統**: 一致的邊距和間距
- **元件庫**: 可重用的 UI 元件

### 本地化支援
- **多語言支援**: 繁體中文、英文
- **文字外部化**: Localizable.strings
- **圖片本地化**: 地區特定資源
- **日期和數字格式**: 地區化格式

### 無障礙設計
- **VoiceOver 支援**: 螢幕閱讀器相容
- **動態字型**: 支援系統字型大小調整
- **高對比度**: 視覺障礙友善設計
- **觸控目標**: 最小 44pt 觸控區域

### 效能優化
- **圖片優化**: 適當的解析度和壓縮
- **資料快取**: 智慧快取策略
- **懶載入**: 按需載入內容
- **記憶體管理**: ARC 和手動記憶體管理

### 安全性考量
- **資料加密**: 敏感資料加密儲存
- **網路安全**: HTTPS 和憑證固定
- **身份驗證**: OAuth 2.0 和 JWT
- **隱私保護**: 最小權限原則