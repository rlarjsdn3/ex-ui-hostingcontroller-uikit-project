//
//  UsingSwiftUIWithUIKitViewController.swift
//  UIHostingController
//
//  Created by 김건우 on 11/13/23.
//

import UIKit
import SwiftUI

// An enum representing the sections of this collection view.
private enum HealthSection: Int, CaseIterable {
    case heartRate
    case healthCategories
    case sleep
    case steps
}

// A struct that stores the static data used in this example.
private struct StaticData {
    lazy var heartRateItems = HeartRateData.generateRandomData(quantity: 3)
    lazy var healthCategories = HealthCategory.allCases
    lazy var sleepItems = SleepData.generateRandomData(quantity: 4)
    lazy var stepItems = StepData.generateRandomData(days: 7)
}

class UsingSwiftUIWithUIKitViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var data = StaticData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ⭐️ 설정 앱에서 텍스트 크기를 'extraExtraExtraLarge'까지 설정할 수 있음.
        view.maximumContentSizeCategory = .extraExtraExtraLarge
        
        configureLayout()
    }
    
    func configureLayout() {
        let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, layoutEnvironment in
            switch HealthSection(rawValue: sectionIndex)! {
            case .heartRate:
                return createOrthogonalScrollingSection()
            case .healthCategories:
                return createListSection(layoutEnvironment)
            case .sleep:
                return createGridSection()
            case .steps:
                return createListSection(layoutEnvironment)
            }
        }
        
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = UIColor.systemGroupedBackground
        collectionView.allowsSelection = false
    }
    
    private struct LayoutMetrics {
        static let horizontalMargin = 16.0
        static let sectionSpacing = 10.0
        static let cornerRadius = 10.0
    }
    
    // ⭐️ 수평 스크롤이 가능한 섹션을 반환하는 메서드
    private func createOrthogonalScrollingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .zero
        group.contentInsets.leading = LayoutMetrics.horizontalMargin
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .zero
        section.contentInsets.trailing = LayoutMetrics.horizontalMargin
        section.contentInsets.bottom = LayoutMetrics.sectionSpacing
        return section
    }
    
    // ⭐️ 그리드로 구성된 섹션을 반환하는 메서드
    private func createGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(120)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .zero
        section.contentInsets.leading = LayoutMetrics.horizontalMargin
        section.contentInsets.trailing = LayoutMetrics.horizontalMargin
        section.contentInsets.bottom = LayoutMetrics.sectionSpacing
        return section
    }
    
    // ⭐️ 리스트로 구성된 섹션을 반환하는 메서드
    private func createListSection(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        section.contentInsets = .zero
        section.contentInsets.leading = LayoutMetrics.horizontalMargin
        section.contentInsets.trailing = LayoutMetrics.horizontalMargin
        section.contentInsets.bottom = LayoutMetrics.sectionSpacing
        return section
    }
    
    private var heartRateCellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, HeartRateData> = {
        let cell = UICollectionView.CellRegistration<UICollectionViewCell, HeartRateData> { cell, indexPath, item in
            cell.contentConfiguration = UIHostingConfiguration {
                HeartRateCellView(data: item)
            }
            .margins(.horizontal, LayoutMetrics.horizontalMargin)
            .background {
                RoundedRectangle(cornerRadius: LayoutMetrics.cornerRadius, style: .continuous)
                    .fill(Color(uiColor: UIColor.secondarySystemGroupedBackground))
            }
        }
        return cell
    }()
    
    private var healthCategoryCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, HealthCategory> = {
        let cell = UICollectionView.CellRegistration<UICollectionViewListCell, HealthCategory> { cell, indexPath, item in
            cell.contentConfiguration = UIHostingConfiguration {
                HealthCategoryCellView(healthCategory: item)
            }
        }
        return cell
    }()
    
    private var sleepCellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, SleepData> = {
        let cell = UICollectionView.CellRegistration<UICollectionViewCell, SleepData> { cell, indexPath, item in
            cell.contentConfiguration = UIHostingConfiguration {
                SleepCellView(data: item)
            }
            .margins(.horizontal, LayoutMetrics.horizontalMargin)
            .background {
                RoundedRectangle(cornerRadius: LayoutMetrics.cornerRadius, style: .continuous)
                    .fill(Color(uiColor: UIColor.secondarySystemGroupedBackground))
            }
        }
        return cell
    }()
    
    private var stepCounterCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, StepData> = {
        let cell = UICollectionView.CellRegistration<UICollectionViewListCell, StepData> { cell, indexPath, item in
            cell.contentConfiguration = UIHostingConfiguration {
                StepCountCellView(data: item)
            }
            
        }
        return cell
    }()

}

extension UsingSwiftUIWithUIKitViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HealthSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch HealthSection(rawValue: section)! {
        case .heartRate:
            return data.heartRateItems.count
        case .healthCategories:
            return data.healthCategories.count
        case .sleep:
            return data.sleepItems.count
        case .steps:
            return data.stepItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch HealthSection(rawValue: indexPath.section)! {
        case .heartRate:
            let item = data.heartRateItems[indexPath.item]
            return collectionView.dequeueConfiguredReusableCell(using: heartRateCellRegistration, for: indexPath, item: item)
        case .healthCategories:
            let item = data.healthCategories[indexPath.item]
            return collectionView.dequeueConfiguredReusableCell(using: healthCategoryCellRegistration, for: indexPath, item: item)
        case .sleep:
            let item = data.sleepItems[indexPath.item]
            return collectionView.dequeueConfiguredReusableCell(using: sleepCellRegistration, for: indexPath, item: item)
        case .steps:
            let item = data.stepItems[indexPath.item]
            return collectionView.dequeueConfiguredReusableCell(using: stepCounterCellRegistration, for: indexPath, item: item)
        }
    }
    
}
