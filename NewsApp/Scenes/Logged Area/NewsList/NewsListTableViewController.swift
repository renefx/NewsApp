//
//  NewsListTableViewController.swift
//  NewsApp
//
//  Created by Renê Xavier on 27/01/21.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class NewsListTableViewController: UITableViewController, ViewModelBased {
    var viewModel: NewsListViewModel!
    let loadServerData = PublishSubject<Void>()
    let barButton = UIBarButtonItem(title: "Sair", style: .plain, target: nil, action: nil)
    
    weak var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        self.title = "News App"
        self.navigationItem.rightBarButtonItem  = barButton
        viewModel.fetchNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getInputsViewModel() -> NewsListInputs {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        
        return NewsListInputs(tapLogout:
                                barButton.rx
                                .tap.asObservable(),
                            tapNavigateScreenDetail:
                                tableView
                                    .rx
                                    .modelSelected(NewsListElement.self)
                                    .asObservable(),
                              loadServerData: .just(()),
                              reloadServerData:
                                refreshControl!
                                    .rx
                                    .controlEvent(.valueChanged)
                                    .asObservable())
    }
    
    func bindUI() {
        viewModel.output.loading
            .drive (onNext: { [weak self] (showLoading) in
                if showLoading {
                    self?.tableView.refreshControl?.beginRefreshing()
                } else {
                    self?.tableView.refreshControl?.endRefreshing()
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.reloadTableViewWith
            .drive(tableView.rx.items(cellIdentifier: "newsTableViewCell",
                                      cellType: NewsTableViewCell.self))
            { (index, cellViewModel, cell) in
                if cellViewModel.mock {
                    cell.showSkeleton()
                    return
                }
                cell.hideSkeleton()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                    cell.configure(cellViewModel)
                }
            }.disposed(by: disposeBag)
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension NewsListTableViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "newsTableViewCell"
    }
}
