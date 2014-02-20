require 'active_record'
 
ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3', 
    :database => 'blog.db'
)
 
ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.column :titulo, :string
    t.column :texto, :string
    t.column :autor, :string
  end
end
