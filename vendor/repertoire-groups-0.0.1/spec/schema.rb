ActiveRecord::Schema.define(:version => 0) do
  create_table :users, :force => true do |t|
    t.string  :firstname
    t.string  :lastname
    t.string  :email
    t.string  :password
  end

  create_table :roles, :force => true do |t|
    t.string   :name
    t.string   :description
  end

  create_table :assignments, :force => true do |t|
    t.integer       :user_id
    t.integer       :role_id
    t.timestamps
  end

  create_table :test_models, :force => true do |t|
    t.integer :user_id
    t.integer :id
    t.text    :content
    t.timestamps
  end

  # Acts-As-Taggable-On Migration
  create_table :tags, :force => true do |t|
    t.string :name
  end

  create_table :taggings, :force => true do |t|
    t.references :tag

    # You should make sure that the column created is
    # long enough to store the required class names.
    t.references :taggable, :polymorphic => true
    t.references :tagger, :polymorphic => true

    t.string :context

    t.datetime :created_at
  end

  add_index :taggings, :tag_id
  add_index :taggings, [:taggable_id, :taggable_type, :context]
  # End Acts-As-Taggable-On Migration

end
