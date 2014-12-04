class AddDocumentMedia < ActiveRecord::Migration
  def change
    create_table :knw_document_media_files, force: true do |t|
      t.string    :media
      t.integer   :media_file_size
      t.string    :media_content_type
      t.string    :category
      t.integer   :document_id
      t.datetime  :created_at
      t.datetime  :updated_at
      t.integer   :account_id
    end

    create_table :knw_document_media_file_translations, force: true do |t|
      t.integer   :knw_document_media_file_id
      t.string    :locale
      t.string    :title
      t.string    :description
      t.datetime  :created_at
      t.datetime  :updated_at
    end
  end
end
