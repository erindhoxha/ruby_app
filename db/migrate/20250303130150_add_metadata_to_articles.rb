class AddMetadataToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :og_image, :string
    add_column :articles, :og_description, :text
    add_column :articles, :og_title, :string
  end
end