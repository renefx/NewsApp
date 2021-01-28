//
//  NewsDetailTableViewController.swift
//  NewsApp
//
//  Created by Renê Xavier on 27/01/21.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import WebKit

class NewsDetailTableViewController: UITableViewController, ViewModelBased {
    @IBOutlet weak var imageBig: UIImageView!
    @IBOutlet weak var authorImage: UILabel!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var authorText: UILabel!
    @IBOutlet weak var originText: UILabel!
    @IBOutlet weak var dateTimeNews: UILabel!
    @IBOutlet weak var linhaFina: UILabel!
    @IBOutlet weak var bodyWeb: WKWebView!
    
    
    var viewModel: NewsDetailViewModel!
    let barButton = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
    
    weak var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News App"
        self.navigationItem.rightBarButtonItem  = barButton
    }
    
    func getInputsViewModel() -> NewsDetailInputs {
        return NewsDetailInputs(tapShareNews:
                                    barButton.rx
                                    .tap.asObservable(),
                              loadServerData: .just(()),
                              reloadServerData:
                                refreshControl!.rx
                                    .controlEvent(.valueChanged)
                                    .asObservable())
    }
    
    func bindUI() {
        viewModel.output.loading
            .drive (onNext: { [weak self] (showLoading) in
                if showLoading {
                    self?.tableView.refreshControl?.beginRefreshing()
                    self?.showSkeleton()
                } else {
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.hideSkeleton()
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.apiCallResult
            .drive(onNext: { [weak self] (document) in
                self?.fillElements(document)
            }).disposed(by: disposeBag)
    }
    
    func fillElements(_ documento: Documento?) {
        guard let document = documento else {
            self.presentDefaultError(Constants.notFound) { [weak self] (_) in
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        self.title = document.editoria
        self.imageBig.kf.setImage(with: document.urlFormatted)
        self.authorImage.text = document.creditoImagemFormatted
        self.titleNews.text = document.titulo
        self.authorText.text = document.creditoFormatted
        self.originText.text = document.source
        self.dateTimeNews.text = document.dataFormatted
        self.linhaFina.text = document.linhafina
        self.bodyWeb.loadHTMLString(document.corpoformatado ?? "", baseURL: nil)
        
    }
    
    func showSkeleton() {
        self.imageBig.showAnimatedGradientSkeleton()
        self.authorImage.showAnimatedGradientSkeleton()
        self.titleNews.showAnimatedGradientSkeleton()
        self.authorText.showAnimatedGradientSkeleton()
        self.originText.showAnimatedGradientSkeleton()
        self.dateTimeNews.showAnimatedGradientSkeleton()
        self.linhaFina.showAnimatedGradientSkeleton()
        
    }
    
    func hideSkeleton() {
        self.imageBig.hideSkeleton()
        self.authorImage.hideSkeleton()
        self.titleNews.hideSkeleton()
        self.authorText.hideSkeleton()
        self.originText.hideSkeleton()
        self.dateTimeNews.hideSkeleton()
        self.linhaFina.hideSkeleton()
    }
}
