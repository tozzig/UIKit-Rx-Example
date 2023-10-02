
# Small application that displays movies list from The Movie DB. When user selects a movie from list, the Movie Detail screen should be displayed.

## The first build

You don't have to run any scripts to build the project

## The stack

RxSwift frameworks family is used all across the app(MVVM bindings, Networking, Coordination).

Kingfisher for image caching.

Alamofire for networking.

R.swift for generation of resources.

## The app architecture

The application is designed with MVVM+Coordinators architecture pattern.

RxSwift frameworks family is used all across the app(MVVM bindings, Networking, Coordination).

Models are presented as immutable structures.

The movies in the list are loaded by pages. When the movies list is about to reach bottom, the viewmodel makes a request for the next page. Using PrefetchDataSource helps load data before the lis reaches bottom. It makes scrolling smoother.

## User interface

The UI is written in UIKit + autolayout(XIB) for app screens.

The table cell in the list of movies is based on XIB.

## Task :

Create an IOS application that displays the list of trending movies, when we select one movie it shows more details about it.

As a data provider, use the following REST API endpoints:

List of trending movies
```
https://api.themoviedb.org/3/discover/movie https://developers.themoviedb.org/3/discover/movie-discover
```
Details of a movie
```
https://developers.themoviedb.org/3/movies/{movie_id} https://developers.themoviedb.org/3/movies/get-movie-details
```


```
● Follow this documentation to get the full poster image path of a movie :
https://developers.themoviedb.org/3/getting-started/images
```
