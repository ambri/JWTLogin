//
//  FakeJsons.swift
//  JWTLoginTests
//
//  Created by Ati on 2019. 05. 16..
//  Copyright © 2019. Ati. All rights reserved.
//

enum FakeJsons: String {
    case token = """
                 {
                 "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZHA6dXNlcl9pZCI6IjUwYTdkYTFkLWZlMDctNGMxNC04YjFiLTAwNzczN2Y0Nzc2MyIsImlkcDp1c2VyX25hbWUiOiJqZG9lIiwiaWRwOmZ1bGxuYW1lIjoiSm9obiBEb2UiLCJyb2xlIjoiZWRpdG9yIiwiZXhwIjoxNTU2NDc2MjU1fQ.iqFmotBtfAYLplfpLVh_kPgvOIPyV7UMm-NZA06XA5I",
                 "token_type": "bearer",
                 "expires_in": 119,
                 "refresh_token": "NTBhN2RhMWQtZmUwNy00YzE0LThiMWItMDA3NzM3ZjQ3NzYzIyNkNmQ5OTViZS1jY2IxLTQ0MGUtODM4NS1lOTkwMTEwMzBhYzA="
                 }
                 """

    case wrongToken = """
                 {
                 "access_token": "this_is_a_wrong_access_token",
                 "token_type": "bearer",
                 "expires_in": 119,
                 "refresh_token": "NTBhN2RhMWQtZmUwNy00YzE0LThiMWItMDA3NzM3ZjQ3NzYzIyNkNmQ5OTViZS1jY2IxLTQ0MGUtODM4NS1lOTkwMTEwMzBhYzA="
                 }
                 """

    case user = """
                {
                "idp:user_id": "50a7da1d-fe07-4c14-8b1b-007737f47763",
                "idp:user_name": "jdoe",
                "idp:fullname": "John Doe",
                "role": "editor",
                "exp": 1556476255
                }
                """
}
