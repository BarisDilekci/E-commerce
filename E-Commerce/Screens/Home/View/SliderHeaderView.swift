//
//  SliderHeaderView.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 9.08.2025.
//

import UIKit

final class SliderHeaderView: UICollectionReusableView {
    static let identifier = "SliderHeaderView"
    
    private var sliderImages: [String] = []
    
    private let sliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPageIndicatorTintColor = Theme.Colors.tint
        pc.pageIndicatorTintColor = .lightGray
        pc.hidesForSinglePage = true
        return pc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Theme.Colors.background
        
        addSubview(sliderCollectionView)
        addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            sliderCollectionView.topAnchor.constraint(equalTo: topAnchor),
            sliderCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sliderCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sliderCollectionView.heightAnchor.constraint(equalToConstant: UIConstants.Layout.sliderHeight),
            
            pageControl.topAnchor.constraint(equalTo: sliderCollectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
        
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        
        sliderCollectionView.register(SliderCell.self, forCellWithReuseIdentifier: SliderCell.identifier)
    }
    
    func configure(with images: [String]) {
        self.sliderImages = images
        pageControl.numberOfPages = images.count
        sliderCollectionView.reloadData()
    }
}

extension SliderHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sliderImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCell.identifier, for: indexPath) as! SliderCell
        cell.configure(with: sliderImages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: UIConstants.Layout.sliderHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Slider item \(indexPath.item) tapped")
    }
}

