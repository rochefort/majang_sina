require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'lib/majang'
require 'json'

helpers do
  include Rack::Utils; alias_method :h, :escape_html

  def mati(tehai)
    return ["数字以外が入力されています"] unless tehai == tehai.to_i.to_s
    return ["少牌"] if tehai.size < 13
    return ["多牌"] if tehai.size > 13
    tenpai = Majang.new.mati(tehai)
    tenpai.nil?? ["ノーテン"] : tenpai.map{|t| "#{t}\n"}
  end
end

get '/' do
  @tehai = "1112224588899"
  @tenpai = mati(@tehai)
  haml :index
end

post '/' do
  @tehai = params[:tehai]
  @tenpai = mati(@tehai)
  haml :index
end

post '/ajax.json' do
  tehai = params[:tehai]
  tenpai = mati(tehai)
  content_type :json
  JSON.unparse(tenpai)
end

get '/base.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :base
end
