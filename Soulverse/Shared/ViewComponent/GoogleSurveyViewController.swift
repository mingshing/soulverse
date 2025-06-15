//
//  GoogleSurveyViewController.swift
//  KonoSummit
//
//  Created by mingshing on 2022/10/2.
//

import UIKit
import WebKit

class GoogleSurveyViewController: UIViewController {
    private var webView: WKWebView!
    private var surveyTitle: String
    private var surveyURLPath: String
    
    init(surveyTitle: String, surveyURL: String) {
        self.surveyTitle = surveyTitle
        self.surveyURLPath = surveyURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        let webConfigutration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect.zero, configuration: webConfigutration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let uid = User.instance.userId else { return }
        let urlPath = surveyURLPath + uid
        guard let readingReportURL = URL(string: urlPath) else { return }
        let myRequest = URLRequest(url: readingReportURL)
        webView.load(myRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = surveyTitle
    }
    
    func googleFormSubmitted() {
        dismiss(animated: true, completion: nil)
    }
}
extension GoogleSurveyViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        
        webView.load(navigationAction.request)
        return nil
    }
}
