# Soulverse MVP 需求文件

## 簡介

Soulverse 是一個心理健康和情緒管理的 iOS 應用程式，旨在幫助使用者透過多種方式記錄、分析和管理他們的情緒狀態。應用程式結合了情緒追蹤、藝術治療、心理工具和個人成長追蹤功能。

## 需求

### 需求 1: 使用者註冊和初始設定

**使用者故事:** 作為新使用者，我希望能夠快速註冊並完成基本設定，以便開始使用應用程式的核心功能。

#### 驗收標準

1. WHEN 使用者首次啟動應用程式 THEN 系統 SHALL 顯示啟動畫面和註冊 CTA 按鈕
2. WHEN 使用者點擊註冊按鈕 THEN 系統 SHALL 提供 Google 和 Apple 身份驗證選項
3. WHEN 使用者完成身份驗證 THEN 系統 SHALL 導向基本資料設定流程
4. WHEN 使用者進入基本資料設定 THEN 系統 SHALL 依序要求填寫生日、性別、星球命名、情緒寵物命名和主題選擇
5. WHEN 使用者完成所有基本設定 THEN 系統 SHALL 將使用者導向主應用程式介面

### 需求 2: 情緒檢查流程 (Mood Check-in)

**使用者故事:** 作為使用者，我希望能夠透過結構化的流程記錄我的情緒狀態，以便更好地了解和管理我的心理健康。

#### 驗收標準

1. WHEN 使用者首次進入主畫面且未完成過情緒檢查 THEN 系統 SHALL 自動開啟情緒檢查流程
2. WHEN 進入 Sensing 階段 THEN 系統 SHALL 允許使用者選擇顏色和顏色深度來代表心情
3. WHEN 進入 Naming 階段 THEN 系統 SHALL 讓使用者選擇情緒標籤來描述所選顏色
4. WHEN 進入 Shaping 階段 THEN 系統 SHALL 提供文字輸入讓使用者詳細描述情緒
5. WHEN 進入 Attributing 階段 THEN 系統 SHALL 讓使用者分類造成情緒的原因類別
6. WHEN 進入 Evaluating 階段 THEN 系統 SHALL 讓使用者選擇面對情緒的方式
7. WHEN 進入 Acting 階段 THEN 系統 SHALL 讓使用者選擇記錄情緒的方式
8. WHEN 完成所有階段 THEN 系統 SHALL 儲存情緒記錄並返回主畫面

### 需求 3: 主要導航和標籤頁

**使用者故事:** 作為使用者，我希望能夠輕鬆在應用程式的不同功能區域之間導航，以便存取各種心理健康工具。

#### 驗收標準

1. WHEN 使用者完成初始設定 THEN 系統 SHALL 顯示包含五個標籤的主介面
2. WHEN 顯示標籤欄 THEN 系統 SHALL 依序顯示 Inner Cosmo、Soul Insight、Canvas、Tools、Soul Quest 標籤
3. WHEN 使用者點擊任一標籤 THEN 系統 SHALL 切換到對應的功能頁面
4. WHEN 在任一頁面 THEN 系統 SHALL 保持標籤欄可見並標示當前頁面

### 需求 4: Inner Cosmo 頁面

**使用者故事:** 作為使用者，我希望能夠以視覺化的方式查看我的情緒歷史，以便了解我的情緒模式。

#### 驗收標準

1. WHEN 使用者進入 Inner Cosmo 頁面 THEN 系統 SHALL 顯示 3D 星球圖案代表情緒狀態
2. WHEN 顯示星球 THEN 系統 SHALL 根據之前的情緒檢查記錄調整星球外觀
3. WHEN 有最新情緒記錄 THEN 系統 SHALL 顯示最新情緒和時間戳記
4. WHEN 使用者點擊 "Mood check-in" 按鈕 THEN 系統 SHALL 啟動情緒檢查流程
5. WHEN 顯示變化階段提示 THEN 系統 SHALL 根據使用者選擇的主題提供個人化建議

### 需求 5: Soul Insight 儀表板

**使用者故事:** 作為使用者，我希望能夠查看我的情緒數據分析，以便了解我的整體心理健康趨勢。

#### 驗收標準

1. WHEN 使用者進入 Soul Insight 頁面 THEN 系統 SHALL 顯示情緒寵物和使用者姓名
2. WHEN 顯示情緒圖表 THEN 系統 SHALL 提供過去 7 天的情緒趨勢線圖
3. WHEN 顯示情緒標籤 THEN 系統 SHALL 以泡泡圖形式展示最近的情緒分布
4. WHEN 使用者點擊 "Draw on Canvas" THEN 系統 SHALL 導向 Canvas 頁面
5. WHEN 顯示圖表 THEN 系統 SHALL 提供日、週、月的時間範圍選項

### 需求 6: Canvas 藝術治療

**使用者故事:** 作為使用者，我希望能夠透過繪畫來表達和記錄我的情緒，以便進行藝術治療。

#### 驗收標準

1. WHEN 使用者進入 Canvas 頁面 THEN 系統 SHALL 顯示情緒提示選項
2. WHEN 顯示提示 THEN 系統 SHALL 提供 Joyful、Reflective、Energetic、Calm 等選項
3. WHEN 使用者選擇提示 THEN 系統 SHALL 顯示相關的引導問題
4. WHEN 使用者點擊 "Start draw" THEN 系統 SHALL 開啟繪畫介面
5. WHEN 在繪畫模式 THEN 系統 SHALL 提供基本繪畫工具和顏色選擇
6. WHEN 完成繪畫 THEN 系統 SHALL 允許儲存作品並關聯情緒記錄

### 需求 7: Tools 心理工具

**使用者故事:** 作為使用者，我希望能夠存取各種心理健康工具，以便在需要時獲得支援和指導。

#### 驗收標準

1. WHEN 使用者進入 Tools 頁面 THEN 系統 SHALL 顯示 "Healing" 標題和工具說明
2. WHEN 顯示工具 THEN 系統 SHALL 在 Favorite 區域展示常用工具
3. WHEN 顯示工具卡片 THEN 系統 SHALL 包含 Emotional Bundle、Self-Soothing Labyrinth、Cosmic drift bottle、Soulverse daily quote、Time Capsule、Events
4. WHEN 使用者點擊工具 THEN 系統 SHALL 開啟對應的工具介面
5. WHEN 使用工具 THEN 系統 SHALL 記錄使用歷史以供分析

### 需求 8: Soul Quest 成長追蹤

**使用者故事:** 作為使用者，我希望能夠追蹤我的心理成長進度，以便了解我在心理健康旅程中的位置。

#### 驗收標準

1. WHEN 使用者進入 Soul Quest 頁面 THEN 系統 SHALL 顯示 "Your Transformation Hub" 標題
2. WHEN 顯示成長輪盤 THEN 系統 SHALL 展示包含 Intellectual、Emotion、Physical、Social、Environment、Spiritual、Goals、Finance 的八個維度
3. WHEN 顯示當前階段 THEN 系統 SHALL 標示使用者在情緒維度的當前進度
4. WHEN 顯示任務 THEN 系統 SHALL 在 Precontemplation 區域列出 Task 1-4
5. WHEN 顯示主題進度 THEN 系統 SHALL 展示 Self Discovery (75%)、Emotional Intelligence (55%)、Mindfulness (25%) 的完成百分比
6. WHEN 使用者完成任務 THEN 系統 SHALL 更新相應的進度指標

### 需求 9: 共用元件和服務

**使用者故事:** 作為開發者，我希望有一致的 UI 元件和 API 服務架構，以便提高開發效率和使用者體驗一致性。

#### 驗收標準

1. WHEN 開發任何頁面 THEN 系統 SHALL 使用統一的導航欄設計
2. WHEN 需要 API 資料 THEN 系統 SHALL 透過統一的服務層處理請求
3. WHEN 後端未完成 THEN 系統 SHALL 能夠使用本地 JSON 模擬資料
4. WHEN 顯示載入狀態 THEN 系統 SHALL 使用一致的載入指示器
5. WHEN 處理錯誤 THEN 系統 SHALL 提供統一的錯誤處理和使用者提示
6. WHEN 使用顏色和字體 THEN 系統 SHALL 遵循統一的設計系統規範