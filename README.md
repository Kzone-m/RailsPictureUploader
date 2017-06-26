# 画像投稿機能

## 作り方

## 1: rails appの作成
$ rails new PictureUploaderApp<br>
$ ls<br>
=> PictureUploaderApp<br>
$ cd PictureUploaderApp<br>


###./Gemfile(デフォルトのGemファイルに必要な物を追加する)
gem 'jquery-rails'
gem 'bootstrap-sass', '3.3.6'
gem 'faker',          '1.6.6'
gem 'will_paginate',          '3.1.0'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'carrierwave',             '0.11.2'
gem 'mini_magick',             '4.5.1'
gem 'fog',                     '1.38.0'

$ bundle install --without production --path vendor/bundle


## 2: コントローラーの作成
$ rails g controller posts index new edit show

### ./config/routes.rb
Rails.application.routes.draw do
    <strong>resources :posts</strong>
end

### ./app/controllers/posts/post_controller.rb
class PostsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end


## 3: モデルとPictureUploaderの作成
$ rails g uploader Picture
$ rails g model Post content:text picture:string
$ rails db:migrate

### ./app/models/post.rb
class Post < ApplicationRecord
  mount_uploader :picture, PictureUploader
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private
    def picture_size
      if picture.size > 5.megabytes
        erros.add(:picture, "5メガバイト以下のファイルを送信してください")
      end
    end
end

### ./app/uploaders/picture_uploader.rb
追加するもの1:
  <strong>include CarrierWave::MiniMagick</strong>
追加するもの2:
  <strong>process resize_to_limit: [400, 400]</strong>
追加するもの3:
  <strong>
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  </strong>
