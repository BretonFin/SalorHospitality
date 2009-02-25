desc 'Convert german Latin 1 umlauts to utf8 and leave already existing german utf8 umlauts untouched'

task :iconv do
  from_to = {
              '�' => '\xc3\xa4',
              '�' => '\xc3\xb6',
              '�' => '\xc3\xbc',
              '�' => '\xc3\x9f',
              '�' => '\xc3\x84',
              '�' => '\xc3\x96',
              '�' => '\xc3\x9c'
            }
  from_to.each do |c|
     `sed -i 's/#{ c[0] }/#{ c[1] }/' config/locales/de.yml`
  end

end
