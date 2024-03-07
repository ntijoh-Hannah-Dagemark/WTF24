require_relative 'db/seed'

class App < Sinatra::Base

    enable :sessions

    def db
        if @db == nil
            @db = SQLite3::Database.new('./db/db.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    get '/' do
        if session[:user_id] == nil
            redirect "/login/login"
        else
            erb :front
        end
    end

    get '/login/:mode' do |mode|
        @mode = mode
        erb :login
    end

    post '/login/login' do 
        mail = params['mail']
        cleartext_password = params['password']
        user = db.execute('SELECT * FROM user WHERE mail = ?', mail).first

        if user == nil
            p "No user found"
            redirect "/login/login"
        end

        password_from_db = BCrypt::Password.new(user['password'])

        if password_from_db == cleartext_password
            session[:user_id] = user['id']
            redirect "/"
        else
            p "Failed login"
            redirect "/login/login"
        end
    end

    post '/login/signup' do
        username = params['username']
        mail = params['mail']
        cleartext_password = params['password']
        status = params['status']
        hashed_password = BCrypt::Password.create(cleartext_password)

        user = db.execute('INSERT INTO user (username, mail, password, status) VALUES(?,?,?,?) RETURNING *', username, mail, hashed_password, status).first

        redirect "/login/login"
    end

    get '/user' do
        @user_profile = db.execute('SELECT * FROM user WHERE id = ?', session[:user_id]).first
        @user_posts = db.execute('SELECT * FROM post WHERE authorId = ?', session[:user_id])
        erb :profile
    end

    get '/threads/:section' do |section|
        @section = section
        @threads = db.execute('SELECT * FROM thread WHERE category = ?', section)
        @lPosts = []
        for thread in @threads do
            @lPosts += db.execute('SELECT * FROM post WHERE id = ?', thread["postId"])
        end
        erb :threads
    end

    post '/threads/:section' do |section|
        authorId = session[:user_id]
        title = params["title"]
        content = params["content"]
        id = db.execute('INSERT INTO post (authorId, title, content) VALUES(?,?,?) RETURNING *', authorId, title, content).first
        db.execute('INSERT INTO thread (category, postId) VALUES (?,?)', section, id["id"])
        redirect "/threads/#{section}"
    end

end