FactoryBot.define do
  factory :adzip do
    id { 1 }
    zipcode { "0392874" }
    kana1 { "" }
    kana2 { "" }
    kana3 { "" }
    address1 { "青森県" }
    address2 { "上北郡七戸町" }
    address3 { "坪川原" }
    
    trait :niigata do
        id { 2 }
        zipcode { "9550056" }
        address1 { "新潟県" }
        address2 { "三条市" }
        address3 { "嘉坪川" }
    end
    
    trait :toyama do
        id { 3 }
        zipcode { "9360018" }
        address1 { "富山県" }
        address2 { "滑川市" }
        address3 { "坪川新" }
    end
    
    trait :ishikawa do
        id { 4 }
        zipcode { "9291805" }
        address1 { "石川県" }
        address2 { "鹿島郡中能登町" }
        address3 { "坪川" }
    end
  end
end