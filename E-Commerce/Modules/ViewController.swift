//
//  ViewController.swift
//  E-Commerce
//
//  Created by Barış Dilekçi on 14.06.2025.
//

import UIKit

enum HomeViewBuilder {
    static func generate() -> UIViewController {
          let viewModel = HomeViewModel(networkService: NetworkService.shared)
          let viewController = ViewController(viewModel: viewModel)
          return viewController
      }
}
class ViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        viewModel.viewDidLoad()
   
    }
    
   



}

