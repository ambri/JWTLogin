//
// Created by Ati on 2019-05-17.
// Copyright (c) 2019 Ati. All rights reserved.
//

import Moya

enum AuthApi {
    case refreshToken(data: RefreshTokenData)
}

extension AuthApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://example.vividmindsoft.com/idp/api/v1")!
    }

    var path: String {
        switch self {
        case .refreshToken:
            return "/token"
        }
    }

    var method: Method {
        switch self {
        case .refreshToken:
            return .post
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .refreshToken(data):
            return .requestParameters(parameters: [
                "refresh_token": data.refreshToken,
                "grant_type": data.grantType,
                "client_id": data.clientId
            ], encoding: URLEncoding.httpBody)
        }
    }

    var headers: [String: String]? {
        return nil
    }


}
