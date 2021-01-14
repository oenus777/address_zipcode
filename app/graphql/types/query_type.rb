module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :adzip, AdzipType, null: true do
      argument :zipcode, String, '郵便番号で検索', required: true
    end
    
    def adzip(zipcode:)
      zipcode.tr('０-９ａ-ｚＡ-Ｚ','0-9a-zA-Z')   #全角から半角へ変換
      if zipcode.include?('-')   #ハイフン表記ある場合、表記なしへ変換
        zipcode = zipcode.gsub('-','')
      elsif zipcode.length < 7   #前０を省略した場合、前０を足りない分だけ追加
        zipcode = "0" * (7 - zipcode.length) + zipcode
      end
      result = Adzip.find_by(zipcode: zipcode)
      if result.nil?
        raise GraphQL::ExecutionError.new('引数に正しい郵便番号を入力してください。', extensions: {code: "ERROR_CODE"})
      else
        result
      end
    end
    
  end
end
