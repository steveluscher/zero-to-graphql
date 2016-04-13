# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
me = Person.create(first_name: 'Steven', last_name: 'Luscher', email: 'steveluscher@fb.com', username: 'steveluscher')
dhh = Person.create(first_name: 'David', last_name: 'Heinemeier Hansson', email: 'dhh@37signals.com', username: 'dhh')
ezra = Person.create(first_name: 'Ezra', last_name: 'Zygmuntowicz', email: 'ezra@merbivore.com', username: 'ezra')
matz = Person.create(first_name: 'Yukihiro', last_name: 'Matsumoto', email: 'matz@heroku.com', username: 'matz')
me.friends << [matz]
dhh.friends << [ezra, matz]
ezra.friends << [dhh, matz]
matz.friends << [me, ezra, dhh]
