# 概要
Swiftプログラマー向けの開発サポートキット

# Swift version
`swift-DEVELOPMENT-SNAPSHOT-2016-08-23-a`

# ビルド方法
```
git clone https://github.com/nhamada/DevHelperToolkit.git
swift build
```

# 使い方
現在、JSONのデータモデルの自動生成のみ行えます。

## JSON
```
DevHelperToolkit json [-o output_directory] input_file
```

`input_file`で指定されたJSONファイルに対応するデータモデルのswiftファイルを`output_directory`に指定されたディレクトリに出力します。
`output_directory`が未指定の場合は、カレントディレクトリに作成します。

### 例
以下のようなJSONファイル(`./Resources/test_userdata.json`)に対して、データモデルを作成するとします。

```
{
    "user_data": {
        "id": 1,
        "name": "Test User",
        "follow_ids": [
            10, 15, 20
        ],
        "follower_ids": [
            2, 3, 4, 5
        ],
    }
}
```

このファイルに対し、以下のコマンドを実行します。

```
DevHelperToolkit json ./Resources/test_userdata.json
```

このJSONファイルから、以下のファイルが作成されます。

* `JSONDecodable.swift`
  * JSON Objectから読み込みを行うためのプロトコルを定義したファイル
* `TestUserdata.swift`
  * JSONのトップオブジェクトに対応したデータモデル
* `UserData.swift`
  * JSONの`"user_data"`で表されるオブジェクトのデータモデル

上記のファイルをプロジェクトに追加後、以下のようなコードを実行することで、データモデルとしてJSONを読み込めます。

```
let url = URL(fileURLWithPath: "./Resources/test_userdata.json")
let data = Data(contentsOf: url)
guard let dic = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
    abort()
}
let testUserData = TestUserdata.decode(dic)
```

### 制限
現状、`null`のデータがある場合には、データモデルの生成が行えません。
`null`は、無視して、データモデルを生成します。
