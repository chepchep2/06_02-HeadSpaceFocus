//
//  FocusViewController.swift
//  HeadSpaceFocus
//
//  Created by 조상우 on 2022/11/02.
//

import UIKit

class FocusViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    var curated: Bool = false
    
    var items: [Focus] = Focus.list
    
    typealias Item = Focus
    enum Section {
        case main
    }
    
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButton.layer.cornerRadius = 10
        
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FocusCell", for: indexPath) as? FocusCell else {
                return nil
            }
            cell.configure(item)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        datasource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        
        updateButtonTitle()
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        // estimated(50)
        // 기본적으로는 50인데 컨텐츠에 따라서 변경이 될수 있다라는 뜻
        // 50을 하든 1을 하든 크게 상관이 없음
        // 동적으로 만들어주는 요소
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        // width(1)
        // 예를들어 핸드폰의 넓이가 390이면 390을 다 쓰겠다
        // width(0.5)이면 390의 0.5만큼 쓰겠다라는 뜻
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func updateButtonTitle() {
        let title = curated ? "See All" : "See Recommendation"
        refreshButton.setTitle(title, for: .normal)
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        curated.toggle()
        // toggle을 하면 true는 false 로
        // false는 true로 바뀜
        self.items = curated ? Focus.recommendations : Focus.list
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        datasource.apply(snapshot)
        
        updateButtonTitle()
    }
}
