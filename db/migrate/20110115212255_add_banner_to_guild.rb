class AddBannerToGuild < ActiveRecord::Migration
  def self.up
    add_column :guilds, :banner_file_name, :string
  end

  def self.down
    remove_column :guilds, :banner_file_name
  end
end
