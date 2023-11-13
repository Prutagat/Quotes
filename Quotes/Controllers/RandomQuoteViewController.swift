//
//  RandomQuoteViewController.swift
//  Quotes
//
//  Created by Алексей Голованов on 12.11.2023.
//

import UIKit
import SnapKit

final class RandomQuoteViewController: UIViewController {
    let coordinator: AppCoordinator
    let quotesService = QuotesService.shared
    
    private lazy var getQuoteButton = CustomButton(title: "Получить случайную цитату") { [weak self] in
        self?.quotesService.getRandomQuote { quote in
            self?.quoteLable.text = quote.text
        }
    }
    
    private var quoteLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.title = "Случайная цитата"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(getQuoteButton)
        view.addSubview(quoteLable)
        getQuoteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-150)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        quoteLable.snp.makeConstraints { make in
            make.bottom.equalTo(getQuoteButton.snp.top).offset(16)
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
