class BooksController < ApplicationController

  before_filter :authorize, only: [:new, :edit, :update, :create, :destroy]

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.find_or_initialize_by_isbn(params[:book])
    @book.libraries << current_user
    if @book.save
      redirect_to @book, notice:'Book was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @book = Book.find(params[:id])

    if @book.update_attributes(params[:book])
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy

    redirect_to books_url
  end

  def isbn_lookup
    @book = Book.get_open_library_data(params[:isbn])
    render json: @book
  end

  def search_with_tags
    @tags = params[:tags]
    @books = Book.tagged_with(params[:tags], any: true)
    respond_to do |format|
      format.html
      format.json { render json: @books }
    end
  end

end
