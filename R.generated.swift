//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 1 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func accentColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.accentColor.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.nib` struct is generated, and contains static references to 5 nibs.
  struct nib {
    /// Nib `LoadingCell`.
    static let loadingCell = _R.nib._LoadingCell()
    /// Nib `MovieDetailViewController`.
    static let movieDetailViewController = _R.nib._MovieDetailViewController()
    /// Nib `MovieListCell`.
    static let movieListCell = _R.nib._MovieListCell()
    /// Nib `MoviesViewController`.
    static let moviesViewController = _R.nib._MoviesViewController()
    /// Nib `NoResultsCell`.
    static let noResultsCell = _R.nib._NoResultsCell()

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "LoadingCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.loadingCell) instead")
    static func loadingCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.loadingCell)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "MovieDetailViewController", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.movieDetailViewController) instead")
    static func movieDetailViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.movieDetailViewController)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "MovieListCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.movieListCell) instead")
    static func movieListCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.movieListCell)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "MoviesViewController", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.moviesViewController) instead")
    static func moviesViewController(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.moviesViewController)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "NoResultsCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.noResultsCell) instead")
    static func noResultsCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.noResultsCell)
    }
    #endif

    static func loadingCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> LoadingCell? {
      return R.nib.loadingCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? LoadingCell
    }

    static func movieDetailViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.movieDetailViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }

    static func movieListCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> MovieListCell? {
      return R.nib.movieListCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? MovieListCell
    }

    static func moviesViewController(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
      return R.nib.moviesViewController.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
    }

    static func noResultsCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> NoResultsCell? {
      return R.nib.noResultsCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? NoResultsCell
    }

    fileprivate init() {}
  }

  /// This `R.reuseIdentifier` struct is generated, and contains static references to 3 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `LoadingCell`.
    static let loadingCell: Rswift.ReuseIdentifier<LoadingCell> = Rswift.ReuseIdentifier(identifier: "LoadingCell")
    /// Reuse identifier `MovieListCell`.
    static let movieListCell: Rswift.ReuseIdentifier<MovieListCell> = Rswift.ReuseIdentifier(identifier: "MovieListCell")
    /// Reuse identifier `NoResultsCell`.
    static let noResultsCell: Rswift.ReuseIdentifier<NoResultsCell> = Rswift.ReuseIdentifier(identifier: "NoResultsCell")

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct nib {
    struct _LoadingCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = LoadingCell

      let bundle = R.hostingBundle
      let identifier = "LoadingCell"
      let name = "LoadingCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> LoadingCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? LoadingCell
      }

      fileprivate init() {}
    }

    struct _MovieDetailViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "MovieDetailViewController"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }

      fileprivate init() {}
    }

    struct _MovieListCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = MovieListCell

      let bundle = R.hostingBundle
      let identifier = "MovieListCell"
      let name = "MovieListCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> MovieListCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? MovieListCell
      }

      fileprivate init() {}
    }

    struct _MoviesViewController: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "MoviesViewController"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UIKit.UIView? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UIKit.UIView
      }

      fileprivate init() {}
    }

    struct _NoResultsCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
      typealias ReusableType = NoResultsCell

      let bundle = R.hostingBundle
      let identifier = "NoResultsCell"
      let name = "NoResultsCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> NoResultsCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? NoResultsCell
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
