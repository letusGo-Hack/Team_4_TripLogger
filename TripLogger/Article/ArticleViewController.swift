//
//  ArticleViewController.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import UIKit

import PanModal
import SnapKit

protocol ArticleViewControllerDelegate: AnyObject {
    func addPin(location: Location)
}

final class ArticleViewController: UIViewController {
    private var location: Location
    private var repository: ArticleRepository
    
    private let contentView = ArticleView()
    
    weak var delegate: ArticleViewControllerDelegate?
    
    init(location: Location, repository: ArticleRepository) {
        self.location = location
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    private func configure() {
        guard let article = try? repository.articles()?
            .first (where: { $0.longitude == location.longitude && $0.latitude == location.latitude }),
        let imageData = article.imageData,
        let image = UIImage(data: imageData) else {
                return
            }
        let viewModel = ArticleView.ViewModel(weather: nil, image: image, content: article.content)
        configure(viewModel: viewModel)
    }
    
    
    private func configure(viewModel: ArticleView.ViewModel) {
        contentView.configure(
            viewModel: viewModel
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let article = contentView.article
        article.longitude = location.longitude
        article.latitude = location.latitude
        repository.insertArticle(article)
        delegate?.addPin(location: location)
    }
}

extension ArticleViewController: PanModalPresentable {
    var panScrollable: UIScrollView? { contentView.scrollView }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
}
