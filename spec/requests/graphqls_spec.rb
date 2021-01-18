require 'rails_helper'

RSpec.describe Types::QueryType do
  before do
    create(:adzip)
    create(:adzip, :niigata)
    create(:adzip, :toyama)
    create(:adzip, :ishikawa)
  end
  
  describe "POST /graphql" do
    context "zipadリソーバーに郵便番号を引数として与えた時" do
      it "郵便番号から住所を正しく取得できる" do
        query_string = <<-GRAPHQL
        query($zipcode: String!) {
          zipad(zipcode: $zipcode) {
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { zipcode: "9550056" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["zipad"]["address1"]), "新潟県"
        assert_equal (result["data"]["zipad"]["address2"]), "三条市"
        assert_equal (result["data"]["zipad"]["address3"]), "嘉坪川"
      end
      
      it "郵便番号が該当しない場合、nilを返し、またエラーメッセージも返す" do
        query_string = <<-GRAPHQL
        query($zipcode: String!) {
          zipad(zipcode: $zipcode) {
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { zipcode: "0000001" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_nil (result["data"]["zipad"])
        assert_equal (result["errors"][0]["message"]), "引数に正しい郵便番号を入力してください。"
        assert_equal (result["errors"][0]["extensions"]["zipcode"]), "該当する郵便番号がありません。"
      end
      
      it "郵便番号が９文字以上の場合、nilを返し、またエラーメッセージも返す" do
        query_string = <<-GRAPHQL
        query($zipcode: String!) {
          zipad(zipcode: $zipcode) {
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { zipcode: "955005600" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_nil (result["data"]["zipad"])
        assert_equal (result["errors"][0]["message"]), "８文字以下で入力してください。（ハイフン含まない場合は７文字以下）"
        assert_equal (result["errors"][0]["extensions"]["zipcode"]), "与えられた文字数が多すぎます。"
      end
      
      it "郵便番号が漢数字の場合、正しい住所を返す" do
        query_string = <<-GRAPHQL
        query($zipcode: String!) {
          zipad(zipcode: $zipcode) {
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { zipcode: "九五五零零五六" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["zipad"]["address1"]), "新潟県"
        assert_equal (result["data"]["zipad"]["address2"]), "三条市"
        assert_equal (result["data"]["zipad"]["address3"]), "嘉坪川"
      end
      
      it "郵便番号が全角数字の場合、正しい住所を返す" do
        query_string = <<-GRAPHQL
        query($zipcode: String!) {
          zipad(zipcode: $zipcode) {
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { zipcode: "９５５００５６" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["zipad"]["address1"]), "新潟県"
        assert_equal (result["data"]["zipad"]["address2"]), "三条市"
        assert_equal (result["data"]["zipad"]["address3"]), "嘉坪川"
      end
      
      it "郵便番号に全角ハイフンが含まれている場合、正しい住所を返す" do
        query_string = <<-GRAPHQL
        query($zipcode: String!) {
          zipad(zipcode: $zipcode) {
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { zipcode: "955ー0056" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["zipad"]["address1"]), "新潟県"
        assert_equal (result["data"]["zipad"]["address2"]), "三条市"
        assert_equal (result["data"]["zipad"]["address3"]), "嘉坪川"
      end
      
      it "郵便番号に半角ハイフンが含まれている場合、正しい住所を返す" do
        query_string = <<-GRAPHQL
        query($zipcode: String!) {
          zipad(zipcode: $zipcode) {
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { zipcode: "955-0056" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["zipad"]["address1"]), "新潟県"
        assert_equal (result["data"]["zipad"]["address2"]), "三条市"
        assert_equal (result["data"]["zipad"]["address3"]), "嘉坪川"
      end
      
      it "郵便番号に前０を省略した場合、正しい住所を返す" do
        query_string = <<-GRAPHQL
        query($zipcode: String!) {
          zipad(zipcode: $zipcode) {
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { zipcode: "392874" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["zipad"]["address1"]), "青森県"
        assert_equal (result["data"]["zipad"]["address2"]), "上北郡七戸町"
        assert_equal (result["data"]["zipad"]["address3"]), "坪川原"
      end
    end
    
    context "adzipリソーバーに住所を引数として与えた時" do
      it "住所から郵便番号を正しく取得できる" do
        query_string = <<-GRAPHQL
        query($address: String!) {
          adzip(address: $address) {
            zipcode
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { address: "新潟県三条市嘉坪川" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["adzip"][0]["zipcode"]), "9550056"
        assert_equal (result["data"]["adzip"][0]["address1"]), "新潟県"
        assert_equal (result["data"]["adzip"][0]["address2"]), "三条市"
        assert_equal (result["data"]["adzip"][0]["address3"]), "嘉坪川"
      end
      
      it "住所の字（あざ）が部分一致でも該当しない場合、nilを返し、エラーメッセージも返す" do
        query_string = <<-GRAPHQL
        query($address: String!) {
          adzip(address: $address) {
            zipcode
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { address: "新潟県三条市宇宙" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_nil (result["data"]["adzip"])
        assert_equal (result["errors"][0]["message"]), "引数に正しい住所を入力してください。"
        assert_equal (result["errors"][0]["extensions"]["address"]), "該当する住所がございません。"
      end
      
      it "引数が都道府県のみの場合、nilを返し、エラーメッセージも返す" do
        query_string = <<-GRAPHQL
        query($address: String!) {
          adzip(address: $address) {
            zipcode
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { address: "新潟県" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_nil (result["data"]["adzip"])
        assert_equal (result["errors"][0]["message"]), "引数に字（あざ）を入力してください。"
        assert_equal (result["errors"][0]["extensions"]["address"]), "字（あざ）が存在しません。"
      end
      
      it "引数が市区町村のみの場合、nilを返し、エラーメッセージも返す" do
        query_string = <<-GRAPHQL
        query($address: String!) {
          adzip(address: $address) {
            zipcode
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { address: "三条市" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_nil (result["data"]["adzip"])
        assert_equal (result["errors"][0]["message"]), "引数に字（あざ）を入力してください。"
        assert_equal (result["errors"][0]["extensions"]["address"]), "字（あざ）が存在しません。"
      end
      
      it "住所が字（あざ）のみの場合、正しい郵便番号を返す" do
        query_string = <<-GRAPHQL
        query($address: String!) {
          adzip(address: $address) {
            zipcode
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { address: "嘉坪川" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["adzip"][0]["zipcode"]), "9550056"
        assert_equal (result["data"]["adzip"][0]["address1"]), "新潟県"
        assert_equal (result["data"]["adzip"][0]["address2"]), "三条市"
        assert_equal (result["data"]["adzip"][0]["address3"]), "嘉坪川"
      end
      
      it "都道府県が無い場合、正しい郵便番号を返す" do
        query_string = <<-GRAPHQL
        query($address: String!) {
          adzip(address: $address) {
            zipcode
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { address: "三条市嘉坪川" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["adzip"][0]["zipcode"]), "9550056"
        assert_equal (result["data"]["adzip"][0]["address1"]), "新潟県"
        assert_equal (result["data"]["adzip"][0]["address2"]), "三条市"
        assert_equal (result["data"]["adzip"][0]["address3"]), "嘉坪川"
      end
      
      it "市区町村が無い場合、正しい郵便番号を返す" do
        query_string = <<-GRAPHQL
        query($address: String!) {
          adzip(address: $address) {
            zipcode
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { address: "新潟県嘉坪川" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["adzip"][0]["zipcode"]), "9550056"
        assert_equal (result["data"]["adzip"][0]["address1"]), "新潟県"
        assert_equal (result["data"]["adzip"][0]["address2"]), "三条市"
        assert_equal (result["data"]["adzip"][0]["address3"]), "嘉坪川"
      end
      
      it "字（あざ）が部分一致している場合、複数の郵便番号を返す" do
        query_string = <<-GRAPHQL
        query($address: String!) {
          adzip(address: $address) {
            zipcode
            address1
            address2
            address3
          }
        }
        GRAPHQL
        variables = { address: "坪川" }
        result = AppSchema.execute(query_string, context: {}, variables: variables )
        assert_equal (result["data"]["adzip"].size), 4
      end
    end
  end
end