require 'sinatra'
require 'active_record'

# modelo de datos
class Post < ActiveRecord::Base
end

# inicializacion conector activerecord
ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3', 
    :database => 'blog.db'
)
ActiveRecord::Base.include_root_in_json = false

# Configurar sinatra
after do
  ActiveRecord::Base.connection.close
end

set :public_folder, File.dirname(__FILE__)
set :views, File.dirname(__FILE__)

# API REST
get '/' do
  erb :index
end

get '/posts' do
  { :posts => Post.all }.to_json
end
 
get '/posts/:id' do
  Post.where(:id => params['id']).first.to_json
end
 
post '/posts' do
  data = JSON.parse(request.body.read)['post']
  nuevo = Post.new(
    :titulo => data['titulo'], 
    :texto => data['texto'], 
    :autor => data['autor']
  )
  nuevo.save
end
 
put '/posts/:id' do
  _post = Post.where(:id => params['id']).first
  data = JSON.parse(request.body.read)['post']
  if _post
    if data.has_key?('titulo')
      _post.titulo = data['titulo']
    end
    if data.has_key?('texto')
      _post.texto = data['texto']
    end
    if data.has_key?('autor')
      _post.autor = data['autor']
    end
    _post.save
  end
  _post
end
 
delete '/posts/:id' do
  Post.where(:id => params['id']).destroy_all
  "item eliminado"
end
