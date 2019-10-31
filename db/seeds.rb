['Admin', 'Manager', 'Owner', 'Client'].each do |role|
  Role.find_or_create_by(name: role)
end

admin = Role.find_by(name: 'Admin').users.create!(
                                    email:'bytheair@gmail.com',
                                    password: 'qweasd',
                                    password_confirmation: 'qweasd')

manager = Role.find_by(name: 'Manager').users.create!(
                                    email:'manager@test.com',
                                    password: '123456',
                                    password_confirmation: '123456')

