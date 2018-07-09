class FixLicenceColumnName < ActiveRecord::Migration[5.2]
  def change
      rename_column :repositories, :licence, :license
      rename_column :repositories, :licence_url, :license_url
  end
end
