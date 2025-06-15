//
//  SummitNavigationView.swift
//  KonoSummit
//
//  Created by mingshing on 2021/9/19.
//

import UIKit

protocol NavigationViewDelegate: AnyObject {
    
    func navigationViewDidTapBack (_ SummitNavigationView: SummitNavigationView)

}

class SummitNavigationView: UIView {
    
    weak var delegate: NavigationViewDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(named: "naviconBack")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.textColor = .primaryWhite
        return label
    }()
    
    private let title: String
    
    init(title: String = "") {
        self.title = title
        super.init(frame: .zero)
        clipsToBounds = true
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
    
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.left.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        addSubview(navigationTitle)
        navigationTitle.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(backButton.snp.right)
            make.right.equalToSuperview().inset(48)
        }
        navigationTitle.text = title
        
    }
    @objc private func didTapBack() {
        
        delegate?.navigationViewDidTapBack(self)
    }
    
}
