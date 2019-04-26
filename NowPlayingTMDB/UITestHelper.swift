//
//  UITestHelper.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/26/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import Foundation
import OHHTTPStubs

class UITestHelper {
    func setUp() {
        setUpNowPlaying()
        setUpSimilar()
    }
    
    private func setUpNowPlaying() {
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/movie/now_playing")) { request in
            let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            let page = components?.queryItems?.first { $0.name == "page" }?.value

            if (page == "1") {
                return OHHTTPStubsResponse(
                    fileAtPath: OHPathForFile("NowPlaying1.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type":"application/json"]
                )
            } else {
                return OHHTTPStubsResponse(
                    fileAtPath: OHPathForFile("NowPlaying2.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type":"application/json"]
                )
            }
        }
    }

    private func setUpSimilar() {
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/movie/299537/similar")) { request in
            let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
            let page = components?.queryItems?.first { $0.name == "page" }?.value

            if (page == "1") {
                return OHHTTPStubsResponse(
                    fileAtPath: OHPathForFile("Similar1.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type":"application/json"]
                )
            } else {
                return OHHTTPStubsResponse(
                    fileAtPath: OHPathForFile("Similar2.json", type(of: self))!,
                    statusCode: 200,
                    headers: ["Content-Type":"application/json"]
                )
            }
        }
    }
}
