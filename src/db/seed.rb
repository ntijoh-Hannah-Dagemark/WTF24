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
        db.execute('DROP TABLE IF EXISTS forum')
    end

    def self.create_tables

        db.execute_batch('CREATE TABLE forum(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
        ); CREATE TABLE thread(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            post INTEGER NOT NULL
        ); CREATE TABLE user(
            id INTEGER PRIMARY KEY AUTOINCREMENT
            mail TEXT NOT NULL
            username TEXT NOT NULL
            password TEXT NOT NULL
            status TEXT
        ); CREATE TABLE post(
            id INTEGER PRIMARY KEY AUTOINCREMENT
            authorId INTEGER NOT NULL
            title TEXT NOT NULL
            content TEXT NOT NULL
            threadId INTEGER
        )')

    end

    def self.seed_tables
        names = [
            {name: 'Andrew', gender: 'm'},
            {name: 'George', gender: 'm'},
            {name: 'David', gender: 'm'},
            {name: 'Geoffrey', gender: 'm'},
            {name: 'Adam', gender: 'm'},
            {name: 'Vincent', gender: 'm'},
            {name: 'Kent', gender: 'm'},
            {name: 'Bob', gender: 'm'},
            {name: 'Bartholomew', gender: 'm'},
            {name: 'Jens', gender: 'm'},
            
            {name: 'Jeniffer', gender: 'f'},
            {name: 'Sarah', gender: 'f'},
            {name: 'Clarah', gender: 'f'},
            {name: 'Selma', gender: 'f'},
            {name: 'Olivia', gender: 'f'},
            {name: 'Cassandra', gender: 'f'},
            {name: 'Indigo', gender: 'f'},
            {name: 'Felicia', gender: 'f'},
            {name: 'Rebecca', gender: 'f'},
            {name: 'Elsa', gender: 'f'},
            
            {name: 'Alex', gender: 'a'},
            {name: 'Kim', gender: 'a'},
            {name: 'Charlie', gender: 'a'},
            {name: 'Kris', gender: 'a'}
        ]

        names.shuffle.each do |name|
            db.execute('INSERT INTO people (name, gender, age) VALUES (?,?,?)', name[:name], name[:gender], rand(0..100))
        end
    end
end

Seeder.seed!