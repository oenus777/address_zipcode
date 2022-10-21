# address_zipcode  
  
  RailsベースのGraphQL API方式を用いたWeb APIです。  
  具体的な機能は下記の２つです。  
  ・郵便番号から住所を取得  
  ・住所から郵便番号を取得  
  ※下記URLから全国一括データ （2020年12月28日更新分）のCSV形式データを基に構築しています。  
  http://zipcloud.ibsnet.co.jp/  
  
## リクエスト方法
  
  ①下記URLのテストクライアントにアクセスしクエリをリクエストする。  
  localhost:3000  
    
  ②下記エンドポイントへPOSTリクエストをクエリと共にリクエストする。  
  localhost:3000/graphql  
    
  例  
  ```
  curl -XPOST -d 'query=query { zipad(zipcode: "9550056") { address1 address2 address3 } }  localhost:3000/graphql  
  ```
  
  
## クエリについて  
  
  ・郵便番号から住所を取得する場合  
   "XXXXXXX"に検索したい郵便番号を入力して下さい。  
   ※ハイフンありなし、全角半角、漢数字にも対応しています。  
    ９文字以上の場合、該当する郵便番号が存在しない場合、エラーメッセージを返します。  
    
    ```
    query {   
      zipad(zipcode: "XXXXXXX") {  
        address1  
        address2  
        address3  
      }
    }
    ```
      
  ・住所から郵便番号を取得する場合  
   "XXXXXX"に検索したい住所を入力して下さい。  
   ※都道府県から始まる入力、市区町村から始まる入力、字（あざ）のみの入力にも対応しています。  
    また字の部分一致での取得にも対応していますので不確かな記憶でも該当の郵便番号が取得できるかもしれません。  
    都道府県のみ、市区町村のみ、該当する住所が存在しない場合、エラーメッセージを返します。  
    
    ```
    query {  
      adzip(address: "XXXXXX") {  
        zipcode  
        address1  
        address2  
        address3  
      }
    }
    ```
    
## Typesの各Field  
   ※適宜、取得したいFieldにて調整してください。  
  
  id:　固有id  
  zipcode: 郵便番号  
  kana1: 住所の都道府県（カナ)  
  kana2: 住所の市区町村（カナ）  
  kana3: 住所の字（カナ）  
  address1: 住所の都道府県（漢字、ひらがな）  
  address2: 住所の市区町村（漢字、ひらがな）  
  address3: 住所の字（漢字、ひらがな)  
    
## 開発者へ  
  
  Typesの定義はapp/graphql/adzip_types.rb  
  Resolverの定義はapp/graphql/query_types.rb  
  上記で実装しています。  
  またgraphql-rubyの基本的な使い方に沿って実装。  
  ですので基本的な使い方が分かればメンテナンスしやすくアレンジ可能です。  
  参考URL:https://qiita.com/k-penguin-sato/items/07fef2f26fd6339e0e69  
  
  
  
    
    
