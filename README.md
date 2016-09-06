# 概要
Swiftプログラマー向けの開発サポートキット

以下のことが行えます。
* JSONのデータモデルの自動生成
* `UIColor`/`NSColor`のプロパティにアプリ用の定義を追加したExtensionの自動生成

# Swift version
`swift-DEVELOPMENT-SNAPSHOT-2016-08-23-a`

# ビルド方法
```
git clone https://github.com/nhamada/DevHelperToolkit.git
swift build
```

# 使い方
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

## Color
```
DevHelperToolkit color [-o output_directory] [-p {ios, osx}] input_file
```

`input_file`で指定されたJSONファイルに対応する`UIColor`/`NSColor`のExtensionのswiftファイルを`output_directory`に指定されたディレクトリに出力します。
`output_directory`が未指定の場合は、カレントディレクトリに作成します。
`-p ios`で、iOS用 (=`UIColor`)のExtensionを作成します。
`-p osx`で、macOS用 (=`NSColor`)のExtensionを作成します。
`-p`オプションが未指定の場合は、iOS用にExtensionを作成します。

### 例
以下のようなJSONファイル(`./Resources/test_color.json`)に対して、Extensionを作成するとします。

```
{
    "theme_white": "000000",
    "theme_black": "ffffff",
    "theme_clear": "00000000",
    "theme_gray": 180,
    "theme_black_over": 300,
    "web-safe-1": "FF6699",
    "theme_gray2": 0.8
}
```

このファイルに対し、以下のコマンドを実行します。

```
DevHelperToolkit color ./Resources/test_userdata.json
```

コマンド実行後、カレントディレクトリに`UIColor+Extension.swift`というファイルが作成されます。
このファイルをプロジェクトに追加すると、`UIColor.###`でJSONファイルで指定した色を取得できます。

### JSONでの色の指定方法
* 文字列で指定する場合
  * 16進数の文字列でRGB、もしくは、RGBAの順番で指定してください。
* 数値で指定する場合
  * 数値で指定する場合は、グレースケールとなります。
  したがって、100を指定した場合は、R=100, G=100, B=100の色を指定した場合と同じになります。

### 制限
色の名前の指定でチェックを行っていないため、`white`などの定義済みの名前を指定するとビルド時にエラーになります。
