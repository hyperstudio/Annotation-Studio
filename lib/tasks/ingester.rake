require 'uri'
require 'nokogiri'

namespace :ingest do

  desc "Ingest all users from COVE"
  task :users => :environment do
    
    # get all documents
    users = ApiRequester::UserIngester.get_users

    Apartment::Tenant.switch(ENV["TENANT"])

    # For each document
    users.each do |user|

      as_user = User.find_or_initialize_by(cove_id: user["uid"])

      as_user.skip_confirmation!
      as_user.skip_reconfirmation!

      as_user.full_name = user["name"]

      if user["name"].split(" ")[1].present?
        as_user.firstname = user["name"].split(" ")[0]
        as_user.lastname = user["name"].split(" ")[1]
      else
        as_user.firstname = user["name"]
        as_user.lastname = user["name"]
      end

      as_user.cove_id = user["uid"]
      if !as_user.email.present?
        as_user.email = "#{as_user.cove_id}@example.com"
      end
      as_user.password = "changeme"
      as_user.agreement = true

      as_user.save!
      puts as_user.to_json
    end
  end

  desc "Ingest all documents from COVE"
  task :documents => :environment do
    
    # get all documents
    documents = ApiRequester::DocumentIngester.get_documents
    
    Apartment::Tenant.switch(ENV["TENANT"])

    # For each document
    documents.each do |document|
      # - Look up or create the owner user, by email address
      # - Include: email address, cove_id, full name
      puts "=========="
      puts "Incoming document:"
      puts document

      owner = User.find_by(cove_id: document["uid"])

      # owner.skip_confirmation!
      # owner.skip_reconfirmation!

      # owner.full_name = document["user"]
      # owner.email = document["mail"]
      # owner.agreement = true

      # if owner.full_name.split(" ")[1].present?
      #   owner.firstname = owner.full_name.split(" ")[0]
      #   owner.lastname = owner.full_name.split(" ")[1]
      # else
      #   owner.firstname = owner.full_name
      #   owner.lastname = owner.full_name
      # end

      # owner.save
      puts owner.to_json

      # - Create the document
      new_doc = Document.find_or_initialize_by(cove_uri: document["uri"])

      # - Assign to the user
      new_doc.user_id = owner.id
      new_doc.title = document["title"]
      new_doc.origin = "cove"
      
      # TODO: Deal with images
      body = Nokogiri::HTML.fragment(document["body"])

      body.css("img").each do |image|
        image.attributes["src"].value = "#{ENV["IMG_HOST"]}#{image.attributes["src"].value}"
      end

      new_doc.text = body.to_s

      new_doc.state = "annotatable"

      # Update friendly id
      # new_doc.slug = nil

      new_doc.save
      puts new_doc.to_json
      puts "=========="
    end
  end

  desc "Ingest all annotations from COVE"
  task :annotations => :environment do
    
    # Get all annotations from COVE
    # - Receive an array of JSON objects, each one an annotation
    cove_annotations = ApiRequester::AnnotationIngester.get_annotations
    
    Apartment::Tenant.switch(ENV["TENANT"])

    # For each annotation

    count = 0
    skipped = 0

    @token = JWT.encode(
      {
        'consumerKey' => ENV["API_CONSUMER"],
        'userId' => "jamie@performantsoftware.com",
        'issuedAt' => @now,
        'ttl' => 86400
      },
      ENV["API_SECRET"]
    )

    @document_host = ENV["DOCUMENT_HOST"]

    cove_annotations.each do |cove_annotation|

      as_annotation = {}
      #   - Look up user from AS by COVE ID
      #   - Insert user email from AS user object into annotation
      #   - Flatten user object to email
      owner = User.find_or_initialize_by(email: cove_annotation["mail"])
      as_annotation["user"] = owner.email

      #   - Look up AS document by COVE URI
      #   - Rewrite value of uri from nested object to string JF

      if cove_annotation["uri"].present?
        cove_id = URI(cove_annotation["uri"]).path.split('/').last
      else
        skipped = skipped + 1
        next
      end

      document = Document.where('cove_uri LIKE ?', "%/#{cove_id}").first

      if document.present? && document.archived?
        as_annotation["uri"] = "#{@document_host}/documents/#{document.slug}"
      else 
        skipped = skipped + 1
        next
      end

      # - Map categories values to COVE Studio id values
      #   - Harvest all category strings, look up or create each in AS
      #   - Replace text in the annotation JSON with id values from AS JF
      # category = cove_annotation["category"][0]
      # - Quote: cove_annotation["quote"]["value"]

      # Get the string

      as_annotation["ranges"] = []

      ranges = JSON.parse(cove_annotation["ranges"]["value"])

      ranges.each do |range|
        if range.present?
          # puts "Range: #{range}"
          as_annotation["ranges"] << range
        else
          puts "Range not present"
        end
      end


      ['quote','text'].each do |field|
        if cove_annotation[field]["value"].present?
          as_annotation[field] = cove_annotation[field]["value"]
        end
      end

      # TODO: Deal with images
      html = Nokogiri::HTML.fragment(as_annotation["text"])

      html.css("img").each do |image|
        image.attributes["src"].value = "#{ENV["IMAGE_HOST"]}#{image.attributes["src"].value}"
      end

      as_annotation["text"] = html.to_s

      # Some fields are arrays of strings
      # Groups, subgroups, 
      ['tags'].each do |field|
        if cove_annotation[field].present?
          as_annotation[field] = cove_annotation[field]
        end
      end

      # TODO: change, so this looks up the id of existing categories,
      #       and creates ones that don't exist
      # if cove_annotation["category"].present?
      #   as_annotation["annotation_categories"] = cove_annotation["category"]
      # end

      # - Timestamps: don't exist; set defaults
      #   - as_annotation["created"] = cove_annotation["quote"]["value"]

      # - Permissions: don't exist; set defaults
      #   - Group-visible
      as_annotation["permissions"] = {
        read: "",
        update: owner.email,
        delete: owner.email,
        admin: owner.email,
      }

      as_annotation["groups"] = owner.rep_group_list
      as_annotation["uuid"] = cove_annotation['nid']
      as_annotation["annotation_categories"] = []

      cove_annotation["category"].each do |cove_cat|
        new_cat = AnnotationCategory.find_or_initialize_by(name: cove_cat)
        new_cat.save
        as_annotation["annotation_categories"] << new_cat.id
      end

      result = ApiRequester.create(as_annotation.to_json, @token)

      # - Save the annotation
      puts "== COVE =="
      puts cove_annotation.to_json
      puts "\n\n"
      count = count + 1 
      puts "=== AS ==="
      puts as_annotation.to_json
      puts "\n\n"
    end

    puts "=========="
    puts "=========="
    puts "count: #{count}"
    puts "skipped: #{skipped}"
  end
end