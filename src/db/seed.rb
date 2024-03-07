require 'sqlite3'
class Seeder

    def self.seed!
        puts "Seeding the DB"
        drop_tables
        create_tables
        seed_tables
        puts "Seed complete"
    end

    private 

        
    def self.db
        if @db == nil
            @db = SQLite3::Database.new('./db/db.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    def self.drop_tables
        db.execute_batch('DROP TABLE IF EXISTS forum; DROP TABLE IF EXISTS thread; DROP TABLE IF EXISTS user; DROP TABLE IF EXISTS post')
    end

    def self.create_tables

        db.execute_batch('CREATE TABLE forum(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
        ); CREATE TABLE thread(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT NOT NULL,
            postId INTEGER NOT NULL
        ); CREATE TABLE user(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mail TEXT NOT NULL,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            status TEXT
        ); CREATE TABLE post(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            authorId INTEGER NOT NULL,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            threadId INTEGER
        )')

    end

    def self.seed_tables
        db.execute('INSERT INTO user (mail, username, password, status) VALUES ("admin@admin.com", "Admin", "supremeaccess", "Admin")')
        db.execute_batch('INSERT INTO post (authorID, title, content) VALUES (1, "Air Main Thread", "Welcome to the Aircraft Discussions");
            INSERT INTO post (authorId, title, content) VALUES (1, "Naval Main Thread", "Welcome to Ocean Vessel Discussions");
            INSERT INTO post (authorID, title, content) VALUES (1, "Railroad Main Thread", "Welcome to the Railroading Discussions")')
        db.execute_batch('INSERT INTO thread (postId, category) VALUES (1, "air");INSERT INTO thread (postId, category) VALUES (2, "sea");INSERT INTO thread (postId, category) VALUES (3, "rail")')
    end
end