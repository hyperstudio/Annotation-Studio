complete = Nokogiri::HTML(doc.text)
body = complete.css("body")
body_contents = complete.css("body").inner_html
body_contents.to_html
doc.text = body_contents
doc.save
