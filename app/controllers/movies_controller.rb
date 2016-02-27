class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @ratings = params[:ratings] || {'G' => 1, 'PG' => 1, 'PG-13' => 1, 'R' => 1, 'NC-17' => 1}
    sort_category=params[:sort_by]
    flash[:notice]="#{@ratings['G']}"
    
    # @movies = Movie.all
    
    if params[:sort_by]=='title'
      @title_tohilite='hilite'
    elsif params[:sort_by]=='release_date'
      @release_tohilite='hilite'
    end
     if sort_category.nil?
        @movies = Movie.where(:rating => @ratings.keys).all
      else
        @movies = Movie.where(:rating => @ratings.keys).order(sort_category).all
      end
  end
  

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def updater
    x=params[:movie]
  end
  
  def updatermovie
    x=params[:movie]
    movi=Movie.find_by_title(params[:movie][:oldtitle])
    if (movi.nil?)
      flash[:notice]="Movie does not exist"
    else
      
      if(not ( (x[:newtitle]=="") || (x[:release_date]=="") || (x[:rating]=="") ) )
        movi.update_attribute(:title,params[:movie][:newtitle])      
        movi.update_attribute(:rating,params[:movie][:rating])
        movi.update_attribute(:release_date,params[:movie][:release_date])
        # @movie.update_attribute(params.require(:movie).permit(:rating))
        # @movie.update_attribute(params.require(:movie).permit(:release_date))
        flash[:notice]="Updated"
      else
        flash[:notice]="Fields improperly entered"  
      end
    
    end
    redirect_to movies_path
  end
  
  def deleter
  end
  
  def deletermovie
    parameters=params[:movie]
    if (parameters[:title]=="" && parameters[:rating]=="---")
      flash[:notice]="No parameters defined"
    else
      if(not(parameters[:title]==""))
        title=parameters[:title]
        movies=Movie.find_by_title(title)
        while(!movies.nil?)
          if (movies.nil?)
            flash[:notice]="Title not found!!!"
          else
            movies.destroy
            flash[:notice]="Title deleted!!!"
          end
          movies=Movie.find_by_title(title)
        end
      end
      if(not(parameters[:rating]=="---"))
        rating=parameters[:rating]
        movies=Movie.find_by_rating(rating)
        flash[:notice]="Here!!!"
        while(!movies.nil?)
          if (movies.nil?)
            flash[:notice]="Rating not found!!!"
          else
            movies.destroy
            flash[:notice]="Ratings deleted!!!"
          end
          movies=Movie.find_by_rating(rating)
        end
      
      end
    end
    redirect_to movies_path
  end

end

