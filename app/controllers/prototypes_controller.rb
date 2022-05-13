class PrototypesController < ApplicationController
  before_action :authenticate_user!, only:[:new, :edit, :destroy]
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]
  before_action :move_to_index, only: [:edit, :destroy, :update]


  def index
    @prototypes=Prototype.includes(:user)
  end

  def new
    @prototype=Prototype.new  #空の値
  end  

  def create
    @prototype = Prototype.new(prototype_params)  #入力した値が保持される
    if @prototype.save
      redirect_to root_path
    else                      #すべての項目に入力されていない場合
      render :new             #ストロングパラメーターを保持した状態でnewへ呼び出される
    end
  end
       # バリデーションによって保存ができず投稿ページへ戻ってきた場合でも、入力済みの項目（画像以外）は消えない

  def show
    @prototype=Prototype.find(params[:id])
    @comment=Comment.new
    @comments=@prototype.comments
  end  

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  def edit
    
  end  

  def update
    @prototype=Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end  
  end  




  private

  def prototype_params
    params.require(:prototype).permit( :image, :title, :catch_copy, :concept).merge(user_id: current_user.id)
  end

  def move_to_index
    redirect_to root_path unless current_user == @prototype.user 
  end  

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end  

end
