//
//  CanvasViewController.swift
//

import UIKit
import PencilKit
import PhotosUI

class CanvasViewController: UIViewController {
    
    struct LaoutConstant {
        static let toolPickerHeight: CGFloat = 100
    }
    
    // MARK: - UI Elements
    private lazy var navigationView: SoulverseNavigationView = {
        let view = SoulverseNavigationView(title: NSLocalizedString("canvas", comment: ""))
        return view
    }()
    
    private var canvasView: PKCanvasView!
    private var toolbarStackView: UIStackView!
    
    // MARK: - Properties
    private var toolPicker: PKToolPicker?
    private var backgroundImageView: UIImageView?
    
    // MARK: - Recording Properties
    private var drawingSteps: [PKDrawing] = []
    private var isRecording = true
    private var isReplaying = false
    private var replayTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCanvas()
        setupToolPicker()
        setupToolbar()
        setupBackgroundImage()
        startRecording()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupToolPickerPosition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 隱藏工具選擇器避免影響其他頁面
        toolPicker?.setVisible(false, forFirstResponder: canvasView)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add navigation view
        view.addSubview(navigationView)
        
        // 創建畫布
        canvasView = PKCanvasView()
        canvasView.isRulerActive = false
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvasView)
        
        toolbarStackView = UIStackView()
        toolbarStackView.axis = .horizontal
        toolbarStackView.distribution = .fillEqually
        toolbarStackView.spacing = 10
        toolbarStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbarStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        toolbarStackView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
        canvasView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(toolbarStackView.snp.top).offset(16)
        }
    }
    
    private func setupCanvas() {
        // 設置畫布屬性
        canvasView.delegate = self
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = UIColor.white
        
        // 允許縮放和平移
        canvasView.minimumZoomScale = 0.5
        canvasView.maximumZoomScale = 3.0
        canvasView.bouncesZoom = true
    }
    
    private func setupToolPicker() {
        // 初始化工具選擇器
        toolPicker = PKToolPicker()
        toolPicker?.colorUserInterfaceStyle = .light
        toolPicker?.showsDrawingPolicyControls = false
    }
    
    private func setupToolPickerPosition() {
        guard let toolPicker = toolPicker else { return }
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        
        if let tabBarHeight = tabBarController?.tabBar.frame.height {
            DispatchQueue.main.async {
                self.adjustCanvasInsets(tabBarHeight: tabBarHeight)
            }
        }
    }
    
    
    private func adjustCanvasInsets(tabBarHeight: CGFloat) {
        
        canvasView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: LaoutConstant.toolPickerHeight + 10,
            right: 0
        )
        
        canvasView.scrollIndicatorInsets = canvasView.contentInset
    }
    
    private func setupToolbar() {
        // 創建工具欄按鈕
        let undoButton = createToolbarButton(title: "復原", action: #selector(undoAction))
        let redoButton = createToolbarButton(title: "重做", action: #selector(redoAction))
        let clearButton = createToolbarButton(title: "清除", action: #selector(clearCanvas))
        let addImageButton = createToolbarButton(title: "添加圖片", action: #selector(addBackgroundImage))
        let saveButton = createToolbarButton(title: "保存", action: #selector(startReplay))
        
        // 添加到 StackView
        [undoButton, redoButton, clearButton, addImageButton, saveButton].forEach {
            toolbarStackView.addArrangedSubview($0)
        }
    }
    
    private func setupBackgroundImage() {
        // 創建背景圖片視圖
        backgroundImageView = UIImageView()
        backgroundImageView?.contentMode = .scaleAspectFit
        backgroundImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        // 將背景圖片添加到畫布後面
        canvasView.insertSubview(backgroundImageView!, at: 0)
        
        // 設置約束
        backgroundImageView?.snp.makeConstraints { make in
            make.edges.equalTo(canvasView)
        }
        
        // 設置默認背景圖片（如果有的話）
        if let defaultImage = UIImage(named: "default_background") {
            backgroundImageView?.image = defaultImage
        }
    }
    
    private func createToolbarButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        return button
    }
    
    // MARK: - Actions
    
    @objc private func undoAction() {
        canvasView.undoManager?.undo()
    }
    
    @objc private func redoAction() {
        canvasView.undoManager?.redo()
    }
    
    @objc private func clearCanvas() {
        let alert = UIAlertController(title: "清除畫布", message: "確定要清除所有繪畫內容嗎？", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "確定", style: .destructive) { _ in
            self.canvasView.drawing = PKDrawing()
        })
        
        present(alert, animated: true)
    }
    
    @objc private func addBackgroundImage() {
        let alert = UIAlertController(title: "選擇圖片", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "從相片選擇", style: .default) { _ in
            self.presentImagePicker()
        })
        
        alert.addAction(UIAlertAction(title: "使用默認圖片", style: .default) { _ in
            self.setDefaultBackgroundImage()
        })
        
        alert.addAction(UIAlertAction(title: "移除背景", style: .destructive) { _ in
            self.backgroundImageView?.image = nil
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func saveDrawing() {
        //toolPicker?.setVisible(false, forFirstResponder: canvasView)
        //let image = renderDrawingAsImage()
        //UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // MARK: - Helper Methods
    
    private func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func setDefaultBackgroundImage() {
        // 創建一個示例的默認圖片（你可以替換成你的圖片）
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 600))
        let defaultImage = renderer.image { context in
            // 繪製漸層背景
            let colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: nil)!
            context.cgContext.drawLinearGradient(gradient,
                                               start: CGPoint(x: 0, y: 0),
                                               end: CGPoint(x: 400, y: 600),
                                               options: [])
        }
        backgroundImageView?.image = defaultImage
    }
    
    private func renderDrawingAsImage() -> UIImage {
        let bounds = canvasView.bounds
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image { context in
            // 先繪製背景色
            UIColor.white.setFill()
            context.fill(bounds)
            
            // 繪製背景圖片
            if let backgroundImage = backgroundImageView?.image {
                backgroundImage.draw(in: bounds)
            }
            
            // 繪製畫布內容
            canvasView.drawing.image(from: bounds, scale: UIScreen.main.scale).draw(in: bounds)
        }
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(
            title: error == nil ? "保存成功" : "保存失敗",
            message: error?.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }

}

// MARK: - Recording Methods
extension CanvasViewController {
    
    private func startRecording() {
        drawingSteps = []
        isRecording = true
        // 記錄初始空白狀態
        drawingSteps.append(PKDrawing())
    }
    
    private func recordDrawingStep() {
        guard isRecording && !isReplaying else { return }
        
        // 深度複製當前繪畫狀態
        let currentDrawing = canvasView.drawing
        drawingSteps.append(currentDrawing)
        
        print("記錄步驟: \(drawingSteps.count)")
    }
    
    @objc private func startReplay() {
        guard !drawingSteps.isEmpty else { return }
        
        isReplaying = true
        
        // 清空畫布，開始重播
        canvasView.drawing = PKDrawing()
        
        var stepIndex = 0
        replayTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] timer in
            guard let self = self, stepIndex < self.drawingSteps.count else {
                self?.finishReplay()
                timer.invalidate()
                return
            }
            
            // 顯示當前步驟
            self.canvasView.drawing = self.drawingSteps[stepIndex]
            
            stepIndex += 1
        }
    }
    
    private func finishReplay() {
        isReplaying = false
        replayTimer?.invalidate()
        replayTimer = nil
    }
}

extension CanvasViewController: CanvasViewPresenterDelegate {
    func didUpdate(viewModel: CanvasViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            
        }
    }
    func didUpdateSection(at index: IndexSet) {
        DispatchQueue.main.async { [weak self] in
            
        }
    }
}

extension CanvasViewController: PKCanvasViewDelegate {
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        // 繪畫內容改變時的回調
        
        recordDrawingStep()
    }
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        // 開始使用工具時的回調
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        // 結束使用工具時的回調
        recordDrawingStep()
    }
}


extension CanvasViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            DispatchQueue.main.async {
                if let image = object as? UIImage {
                    self?.backgroundImageView?.image = image
                }
            }
        }
    }
}
