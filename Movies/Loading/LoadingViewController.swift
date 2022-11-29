//
//  LoadingViewController.swift
//  Movies
//
//  Created by onton on 27.11.2022.
//

import UIKit

final class LoadingViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!

    func showError(_ errorText: String) {
        activityIndicator.stopAnimating()
        errorLabel.isHidden = false
        errorLabel.text = errorText
    }
}
