//
//  EnumServiceResponse.swift
//  OMDB Search
//
//  Created by Richard Jose David Gonzalez on 10-05-17.
//  Copyright © 2017 Ing. Richard David. All rights reserved.
//

enum EnumServiceResponse {
    
    enum Global {
        static let search: String = "Search"
        static let totalResults: String = "totalResults"
        static let response: String = "Response"
        static let error: String = "Error"
    }
    
    enum MixMovieSerie {
        static let poster: String = "Poster"
        static let title: String = "Title"
        static let type: String = "Type"
        static let year: String = "Year"
        static let imdbID: String = "imdbID"
    }
    
}
