namespace :ingest do
  desc "Ingest all documents from COVE"
  task :documents => :environment do
    
    # get all documents
    documents = ApiRequester::DocumentIngester.get_documents
    
    # For each document
    documents.each do |document|
      # - Look up or create the owner user, by email address
      # - Include: email address, cove_id, full name
      owner = User.find_or_initialize_by(email: document["mail"])
      owner.full_name = document["user"]
      owner.cove_id = document["uid"]
      owner.agreement = true
      puts owner.to_json
      # owner.save

      # - Create the document
      document = Document.find_or_initialize_by(cove_uri: document["uri"])

      # - Assign to the user
      document.user_id = owner.id
      document.title = document["title"]
      document.text = document["body"]

      # document.cove_uri = document["uri"]
      # - Save the document, including: title, body, user_id, cove_uri
      puts document.to_json
      # document.save
      puts "=========="
    end
  end

  desc "Ingest all annotations from COVE"
  task :annotations => :environment do
    
    # Get all annotations from COVE
    # - Receive an array of JSON objects, each one an annotation
    annotations = ApiRequester::AnnotationIngester.get_annotations
    
    # For each annotation
    # - Map categories values to COVE Studio id values
    #   - Harvest all category strings, look up or create each in AS
    #   - Replace text in the annotation JSON with id values from AS JF
    # - Flatten URI field
    #   - Get COVE URI value from nested object
    #   - Look up AS document by COVE URI
    #   - Rewrite value of uri from nested object to string JF
    # - Change annotation_tags to tags
    #   - Change key name
    #   - Replace nested tag object with array of strings
    # - POST annotation to MIT API
    annotations.each do |annotation|
      #   - Look up user from AS by COVE ID
      #   - Insert user email from AS user object into annotation
      #   - Flatten user object to email
      owner = User.find_or_initialize_by(email: annotation["mail"])
      owner.cove_id = annotation["uid"]
      owner.agreement = true
      puts owner.to_json
      # owner.save

      # - Create the document
      document = Document.find_or_initialize_by(cove_uri: annotation["uri"])

      # - Assign to the user
      document.user_id = owner.id
      document.title = annotation["title"]
      document.text = annotation["body"]

      # document.cove_uri = annotation["uri"]
      # - Save the document, including: title, body, user_id, cove_uri
      puts document.to_json
      # document.save
      puts "=========="
    end
  end
end