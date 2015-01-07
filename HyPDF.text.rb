File.open('public/down-the-rabbit-hole.txt', 'w:UTF-8') {|f| f.write(@hypdf = HyPDF.pdftotext(
      Rails.root + 'public/down-the-rabbit-hole.pdf',
      first_page: 1,
      last_page: 5,
    )
  ) 
}