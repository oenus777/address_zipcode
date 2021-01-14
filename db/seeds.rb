CSV.foreach('db/zipcode.csv', headers: true) do |row|
  Adzip.create(
    zipcode: (("0" * (7 - row['zipcode'].length.to_i)) + row['zipcode']),
    kana1: row['kana1'],
    kana2: row['kana2'],
    kana3: row['kana3'],
    address1: row['address1'],
    address2: row['address2'],
    address3: row['address3']
  )
end