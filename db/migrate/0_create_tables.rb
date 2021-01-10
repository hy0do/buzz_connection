class CreateTables < ActiveRecord::Migration[6.1]
  def change
    create_table :prefectures do |t|
      t.string :name
      t.string :name_kana
      t.string :name_en
    end

    create_table :industries do |t|
      t.string :name
      t.string :ancestry
    end
    add_index :industries, :ancestry

    create_table :occupations do |t|
      t.string :name
      t.string :ancestry
    end
    add_index :occupations, :ancestry

    create_table :users do |t|
      t.string :code
      t.integer :status, default: 1
      t.string :name
      t.string :email
      t.integer :gender, default: 0
      t.date :birthday
      t.string :avatar_image
      t.string :cover_image
      t.text :detail
      t.timestamps
    end

    create_table :businesses do |t|
      t.string :name
      t.string :title
      t.integer :status, default: 0
      t.text :detail
      t.string :image
      t.string :hp_link
      t.string :code
      t.references :user, foreign_key: true
      t.references :prefecture, foreign_key: true
      t.timestamps
    end

    create_table :business_supply_elements do |t|
      t.references :business, foreign_key: true
      t.references :occupation, foreign_key: true
      t.references :industry, foreign_key: true
      t.string :title
      t.timestamps
    end

    create_table :business_demand_elements do |t|
      t.references :business, foreign_key: true
      t.references :occupation, foreign_key: true
      t.references :industry, foreign_key: true
      t.string :title
      t.timestamps
    end

    create_table :plans do |t|
      t.string :name
      t.string :price
      t.integer :list_capacity
      t.integer :status, default: 0
    end

    create_table :user_plans do |t|
      t.references :user, foreign_key: true
      t.references :plan, foreign_key: true
      t.date :start_at
      t.date :end_at
      t.timestamps
    end

    create_table :external_credentials do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid
      t.text :token
      t.string :expires_at
      t.timestamps
    end

    create_table :user_connections do |t|
      t.references :user, foreign_key: true
      t.references :friend, foreign_key: { to_table: :users }
      t.timestamps
    end

    create_table :connection_requests do |t|
      t.references :connector, foreign_key: { to_table: :users }
      t.references :from_user, foreign_key: { to_table: :users }
      t.references :to_user, foreign_key: { to_table: :users }
      t.integer :connection_type
      t.integer :status, default: 1
      t.string :code
      t.timestamps
    end

    create_table :user_scores do |t|
      t.integer :point, default: 0
      t.integer :all_rank
      t.integer :local_rank
      t.integer :latest_monthly_rank
      t.timestamps
    end

    create_table :point_log do |t|
      t.integer :point
      t.references :connector, foreign_key: { to_table: :users }
      t.references :from_user, foreign_key: { to_table: :users }
      t.references :to_user, foreign_key: { to_table: :users }
      t.timestamps
    end

    create_table :connection_notifications do |t|
      t.references :user
      t.references :connection_request
      t.integer :status, default: 1
      t.timestamps
    end

    create_table :notifications do |t|
      t.text :text
      t.text :url
      t.timestamps
    end

    create_table :message_rooms do |t|
      t.timestamps
    end

    create_table :messages do |t|
      t.references :message_room
      t.references :user
      t.text :text
      t.datetime :posted_at
    end

    create_table :message_room_users do |t|
      t.references :message_room
      t.references :user
      t.timestamps
    end
  end
end
