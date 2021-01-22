//
//  CatsCollectionViewController.swift
//  StatefulViewController
//
//  Created by Hussein Work on 21/01/2021.
//

import UIKit
import Kingfisher

class CatsCollectionViewController: StatefulViewController<HTTPCats> {
    
    enum CatError: String, Error, LocalizedError {
        case notFound
        
        var errorDescription: String? {
            "Couldn't find the source of the file, meow meow!"
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var codeLabel: UILabel!
    
    
    /**
     We change this twice so we simulate failure on the first time then success.
     */
    var fileName = ""
    
    var cats: HTTPCats {
        state.content ?? []
    }
    
    override func setupViewsBeforeTransitioning() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = makeCollectionViewLayout()
        collectionView.register(cellNib: HTTPCatCollectionViewCell.self)
        
        codeLabel.font = .monospacedSystemFont(ofSize: 14, weight: .bold)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoadingItems()
    }
    
    func startLoadingItems(){
        transition(to: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            do {
                guard let file = Bundle.main.url(forResource: self.fileName, withExtension: "json") else {
                    throw CatError.notFound
                }
                
                let data = try Data(contentsOf: file)
                let cats = try JSONDecoder().decode(HTTPCats.self, from: data)
                
                self.transition(to: .hasContent(cats))
            } catch {
                self.transition(to: .failure(error))
            }
        }
    }
    
    override func retry() {
        fileName = "httpcats"
        self.startLoadingItems()
    }
    
    override func didTransitionToContentState(with result: HTTPCats) {
        collectionView.reloadData()
    }
    
    override func didTransitionToFailureState(with error: Error) {
        failureStateView.titleLabel.text = error.localizedDescription
        failureStateView.subtitleLabel.text = "This is a fake error, tap retry to load the list!"
        failureStateView.imageView.image = UIImage(named: "Not Found")
    }
}

extension CatsCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueCell(cellClass: HTTPCatCollectionViewCell.self, for: indexPath)
        let item = cats[indexPath.item]
        
        cell.titleLabel.text = "\(item.code)"
        cell.subtitleLabel.text = item.message
        cell.imageView.kf.setImage(with: URL(string: "https://http.cat/\(item.code)"))
        
        return cell
    }
}

extension CatsCollectionViewController {
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemHeightDimension: NSCollectionLayoutDimension = .absolute(150)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: itemHeightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: itemHeightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }
}



