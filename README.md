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

$ bundle install --without production --path vendor/bundle
<br><br><br>


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
<br><br><br>


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
<br><br><br>


## 4: フォーム及び必要なviewの準備

・newとeditアクションで共通となるformをpartialとして作成する<br>
$ touch ./app/views/posts/_form.html.erb
### ./app/views/posts/_form.html.erb

```
<div class="col-sm-6 col-sm-offset-3">
  <%= form_for(@post, html:{multipart: true}) do |f| %>
  <!-- エラーメッセージを表示するpartial viewの読み込み -->
    <%= render 'shared/error_messages', object: f.object %>
  <!-- 投稿内容 -->  
    <%= f.text_area :content, placeholder: "コメントどうぞ", class: "form-control", value: @post.content%>
  <!-- 画像ファイル -->   
    <%= f.file_field :picture, accept: 'image/jpeg,image/gif,image/png', class: "form-control", value: @post.picture %>
  <!-- 送信 -->
    <%= f.submit yield(:submit_button), class: "btn btn-primary", id: "submit"%>
  <% end %>
</div>
<script type="text/javascript">
  $('#post_picture').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert('Maximum file size is 5MB. Please choose a smaller file.');
    }
  });
</script>
```

・エラーメッセージを表示するpartial viewを作成する<br>
$ touch ./app/views/shared/_error_messages.html.erb
### ./app/views/shared/_error_messages.html.erb

```
<% if object.errors.any? %>
  <div id="error-explanation">
    <div class="alert alert-danger">
      <p><%= object.errors.count %>個の入力情報が正しくありません。</p>
    </div>
    <ul id="error-messages">
      <% object.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
    </ul>
  </div>
<% end %>
```

・投稿用、編集用、詳細用、一覧表示用、呼び出し用のviewを準備する<br>
### ./app/views/layouts/application.html.erb

```
  <body>
    <div class="container">
      <% flash.each do |message_type, message| %>
        <div class="alert alert-<%= message_type %>"><%= message %></div>
      <% end %>
      <%= yield %>
    </div>
  </body>
```

### ./app/views/posts/index.html.erb

```
<% @posts.each do |post| %>
  <div class="container">
    <%= image_tag post.picture.url if post.picture? %>
    <div class="row">
      <div class="col-sm-3 col-sm-offset-3">
        <%= link_to "編集する", edit_post_path(post), class: "btn btn-warning"%>
      </div>
      <div class="col-sm-3">
        <%= link_to "削除する", post_path(post), method: :delete, class: "btn btn-danger"%>
      </div>
      <div class="col-sm-3">
        <p><%= post.content %></p>
      </div>
    </div>
  </div>
<% end %>
```

### ./app/views/posts/new.html.erb

```
<% provide(:submit_button, '投稿') %>
<%=render "form" %>
```

### ./app/views/posts/edit.html.erb

```
<% provide(:submit_button, '編集') %>
<%= render "form" %>
```

### ./app/views/posts/show.html.erb
```
<%= image_tag @post.picture.url if @post.picture? %>
```
<br><br><br>

## 5: Post Controllerの各actionを仕上げる

```
class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "投稿完了"
      redirect_to post_url(@post)
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "編集完了"
      redirect_to post_url(@post)
    else
      render 'index'
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = "削除完了"
    redirect_to posts_url
  end

  private
    def post_params
      params.require(:post).permit(:content, :picture)
    end
end
```
