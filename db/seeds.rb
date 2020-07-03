# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Authors
stephen_king = Author.create(id: 1, first_name: 'Stephen', last_name: 'King', yob: 1947, is_alive: true)
rr_martin     = Author.create(id: 2, first_name: 'George R.', last_name: 'R. Martin', yob: 1948-10-20.year, is_alive: true)

# Categories
horror = Category.create(id: 1, name: 'Horror')
fiction = Category.create(id: 2, name: 'Fiction')
thriller = Category.create(id: 3, name: 'Thriller')
fantasy = Category.create(id: 4, name: 'Fantasy')

# Books
stephen_king.books.create(id: 1, title: 'Carrie', yop: 1974, category: horror)
stephen_king.books.create(id: 2, title: '\'Salem\'s Lot', yop: 1975, category: horror)
stephen_king.books.create(id: 3, title: 'Rage', yop: 1977, category: thriller)
stephen_king.books.create(id: 4, title: 'The Stand', yop: 1978, category: fantasy)

rr_martin.books.create(id: 5, title: 'A Song for Lya', yop: 1974, category: fiction)
rr_martin.books.create(id: 6, title: 'The Ice Dragon', yop: 1980, category: fiction)
rr_martin.books.create(id: 7, title: 'The World of Ice & Fire', yop: 2014, category: fantasy)
rr_martin.books.create(id: 8, title: 'A Knight of the Seven Kingdoms', yop: 2015, category: fantasy)

User.create! first_name: 'Admin', last_name: 'Admin', email: 'admin@admin.com', password: 'test1234', password_confirmation: 'test1234', role: :admin
