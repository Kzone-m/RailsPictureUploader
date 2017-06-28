# 画像投稿機能

## 作り方

## 1: rails appの作成
$ rails new PictureUploaderApp<br>
$ ls<br>
=> PictureUploaderApp<br>
$ cd PictureUploaderApp<br>

<strong>./Gemfile(デフォルトのGemファイルに必要な物を追加する)</strong><br>
<pre>
gem 'jquery-rails'
gem 'bootstrap-sass', '3.3.6'
gem 'faker',          '1.6.6'
gem 'will_paginate',          '3.1.0'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'carrierwave',             '0.11.2'
gem 'mini_magick',             '4.5.1'
gem 'fog',                     '1.38.0'
</pre>

$ bundle install --without production --path vendor/bundle<br>


## 2: コントローラーの作成
$ rails g controller posts index new edit show

### ./config/routes.rb
<pre>
Rails.application.routes.draw do
    <strong>resources :posts</strong>
end
</pre>

### ./app/controllers/posts/post_controller.rb
<pre>
class PostsController < ApplicationController<br>
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
</pre>


## 3: モデルとPictureUploaderの作成
$ rails g uploader Picture<br>
$ rails g model Post content:text picture:string<br>
$ rails db:migrate<br>

### ./app/models/post.rb
<pre>
class Post < ApplicationRecord
  mount_uploader :picture, PictureUploader
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private<br>
    def picture_size
      if picture.size > 5.megabytes
        erros.add(:picture, "5メガバイト以下のファイルを送信してください")
      end
    end
end<
</pre>

### ./app/uploaders/picture_uploader.rb
追加するもの1:<br>
&nbsp;  <strong>include CarrierWave::MiniMagick</strong><br>
追加するもの2:<br>
&nbsp;  <strong>process resize_to_limit: [400, 400]</strong><br>
追加するもの3:<br>
<strong>
    &nbsp;  def extension_white_list<br>
    &nbsp; &nbsp;     %w(jpg jpeg gif png)<br>
    &nbsp;  end<br>
</strong>
