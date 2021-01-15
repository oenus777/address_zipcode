module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :zipad, AdzipType, null: true do
      argument :zipcode, String, '郵便番号で検索', required: true
    end
    
    #郵便番号を引数として与えテーブルを参照
    def zipad(zipcode:)
      if zipcode.length > 8
        raise GraphQL::ExecutionError.new('８文字以下で入力してください。（ハイフン含まない場合は７文字以下）', extensions: {zipcode: "与えられた文字数が多すぎます。"})
      end
      zipcode = zipcode.tr('零一二三四五六七八九',  '0123456789')   #漢数字から数字へ変換
      zipcode = zipcode.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z')   #全角から半角へ変換
      if zipcode.include?('-')   #ハイフン表記ある場合、表記なしへ変換
        zipcode = zipcode.gsub('-','')
      elsif zipcode.length < 7   #前０を省略した場合、前０を足りない分だけ追加
        zipcode = "0" * (7 - zipcode.length) + zipcode
      end
      result = Adzip.find_by(zipcode: zipcode)
      if result.nil?
        raise GraphQL::ExecutionError.new('引数に正しい郵便番号を入力してください。', extensions: {zipcode: "該当する郵便番号がありません。"})
      else
        result
      end
    end
    
    field :adzip, [AdzipType], null: true do
      argument :address, String, '住所で検索', required: true
    end
    
    #住所を引数として与えテーブルを参照
    def adzip(address:)
      separates = []
      #市区町村を区切り位置として字（あざ）を抽出し参照するキーとする
      for i in ["市","区","町","村"] do
        if address.include?(i)
          separates = address.split(i,2)
        end
      end
      #市区町村が含まれていない場合、都道府県を区切り位置として抽出
      if separates.blank?
        for j in ["都","道","府","県"] do
          if address.include?(j)
            separates = address.split(j,2)
          end
        end
      end
      #上記で抽出できない場合、引数をキーとする
      separates = Array.new(2,address) if separates.blank?
      #抽出したキーを部分一致で参照する
      result = Adzip.where('address3 like ?',"%#{separates[1]}%")
      if result.nil?
        raise GraphQL::ExecutionError.new('引数に正しい住所を入力してください。', extensions: {address: "該当する住所がございません。"})
      else
        result
      end
    end
    
  end
end
