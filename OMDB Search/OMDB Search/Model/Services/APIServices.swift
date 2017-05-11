//
//  APIServices.swift
//  OMDB Search
//
//  Created by Richard Jose David Gonzalez on 10-05-17.
//  Copyright © 2017 Ing. Richard David. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct APIServices {
    
    private let limitPage: Float = 10.0
    
    func get_mix_movie_serie(
        text: String,
        type: String,
        page: Int,
        success: @escaping (AnyObject) -> Void,
        failure: @escaping (String) -> Void) -> Void {
        
        let parameters: Parameters = [
            EnumServiceParameter.MixMovieSerie.string: text,
            EnumServiceParameter.MixMovieSerie.type: type,
            EnumServiceParameter.Global.formatResponse: EnumFormatResponse.json,
            EnumServiceParameter.Global.page: page]
        
        Alamofire.request(
            EnumAPIConstants.URL_BASE,
            method: HTTPMethod.post,
            parameters: parameters,
            encoding: URLEncoding.queryString,
            headers: nil).responseJSON { (response) in
            
                guard response.result.isSuccess else {
                    return failure(EnumLocalizableString.RESPONSE_ERROR.localized)
                }
                
                let json: JSON = JSON(response.result.value!)

                guard json[EnumServiceResponse.Global.response].boolValue else {
                    return success(EnumLocalizableString.RESPONSE_NOT_FOUND.localized as AnyObject)
                }
                
                let search: String = EnumServiceResponse.Global.search
    
                guard json[search].array!.count > 0 else {
                    return success(EnumLocalizableString.RESPONSE_NOT_FOUND.localized as AnyObject)
                }
                
                let nextPage: Int = Double((Float(json[EnumServiceResponse.Global.totalResults].intValue) / self.limitPage)).roundTo(places: 1) > Double(page) ? page + 1 : page
                
                var entityMixMovieSerie: [EntityMixMovieSerie] = [EntityMixMovieSerie]()
                
                for index in 1...json[search].array!.count {
                    entityMixMovieSerie.append(EntityMixMovieSerie(
                        poster: json[search].array![index - 1][EnumServiceResponse.MixMovieSerie.poster].string,
                        title: json[search].array![index - 1][EnumServiceResponse.MixMovieSerie.title].string,
                        type: json[search].array![index - 1][EnumServiceResponse.MixMovieSerie.type].string,
                        year: Int(json[search].array![index - 1][EnumServiceResponse.MixMovieSerie.year].string!),
                        imdbID: json[search].array![index - 1][EnumServiceResponse.MixMovieSerie.imdbID].string,
                        page: nextPage,
                        totalResults: json[EnumServiceResponse.Global.totalResults].intValue))
                }
            
                success(entityMixMovieSerie as AnyObject)
            
        }
        
    }
    
}
