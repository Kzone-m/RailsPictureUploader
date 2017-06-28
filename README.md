# 画像投稿機能

## 作り方

## 1: rails appの作成
$ rails new PictureUploaderApp<br>
$ ls<br>
=> PictureUploaderApp<br>
$ cd PictureUploaderApp<br>

<strong>./Gemfile(デフォルトのGemファイルに必要な物を追加する)</strong><br>

gem 'jquery-rails'<br>
gem 'bootstrap-sass', '3.3.6'<br>
gem 'faker',          '1.6.6'<br>
gem 'will_paginate',          '3.1.0'<br>
gem 'bootstrap-will_paginate', '0.0.10'<br>
gem 'carrierwave',             '0.11.2'<br>
gem 'mini_magick',             '4.5.1'<br>
gem 'fog',                     '1.38.0'<br>

$ bundle install --without production --path vendor/bundle<br>


## 2: コントローラーの作成
$ rails g controller posts index new edit show

### ./config/routes.rb
Rails.application.routes.draw do<br>
    <strong>resources :posts</strong><br>
end<br>

### ./app/controllers/posts/post_controller.rb
class PostsController < ApplicationController<br>
  def index<br>
  end<br>

  def show<br>
  end<br>

  def new<br>
  end<br>

  def create<br>
  end<br>

  def edit<br>
  end<br>

  def update<br>
  end<br>

  def destroy<br>
  end<br>
end<br>


## 3: モデルとPictureUploaderの作成
$ rails g uploader Picture<br>
$ rails g model Post content:text picture:string<br>
$ rails db:migrate<br>

### ./app/models/post.rb
<pre>
class Post < ApplicationRecord<br>
  mount_uploader :picture, PictureUploader<br>
  validates :content, presence: true, length: {maximum: 140}<br>
  validate :picture_size<br>

  private<br>
    def picture_size<br>
      if picture.size > 5.megabytes<br>
        erros.add(:picture, "5メガバイト以下のファイルを送信してください")<br>
      end<br>
    end<br>
end<br>
</pre>

### ./app/uploaders/picture_uploader.rb
追加するもの1:<br>
  <strong>include CarrierWave::MiniMagick</strong><br>
追加するもの2:<br>
  <strong>process resize_to_limit: [400, 400]</strong><br>
追加するもの3:<br>
  <strong>
  def extension_white_list<br>
    %w(jpg jpeg gif png)<br>
  end<br>
  </strong>
