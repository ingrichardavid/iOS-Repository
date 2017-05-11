//
//  MixMovieSerieEntity.swift
//  OMDB Search
//
//  Created by Richard Jose David Gonzalez on 10-05-17.
//  Copyright © 2017 Ing. Richard David. All rights reserved.
//

struct EntityMixMovieSerie {
    
    var poster: String?
    var title: String!
    var type: String!
    var year: Int!
    var imdbID: String!
    var page: Int!
    var totalResults: Int!
    
    init(){}
    
    init(poster: String?, title: String!, type: String!, year: Int!, imdbID: String!, page: Int!, totalResults: Int!) {
        self.poster = poster
        self.title = title
        self.type = type
        self.year = year
        self.imdbID = imdbID
        self.page = page
        self.totalResults = totalResults
    }
    
}
