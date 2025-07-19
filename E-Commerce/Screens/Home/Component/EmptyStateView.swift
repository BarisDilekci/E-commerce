//
//  EmptyStateView.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 19.07.2025.
//

import UIKit

   let emptyStateView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.isHidden = true
      
      let imageView = UIImageView(image: UIImage(systemName: "bag"))
      imageView.tintColor = .systemGray3
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      
      let label = UILabel()
      label.text = "Ürün bulunamadı"
      label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
      label.textColor = .systemGray2
      label.textAlignment = .center
      label.translatesAutoresizingMaskIntoConstraints = false
      
      view.addSubview(imageView)
      view.addSubview(label)
      
      NSLayoutConstraint.activate([
          imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
          imageView.widthAnchor.constraint(equalToConstant: 60),
          imageView.heightAnchor.constraint(equalToConstant: 60),
          
          label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
          label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      return view
  }()
