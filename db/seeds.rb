['Admin', 'Manager', 'Owner', 'Client'].each do |role|
  Role.find_or_create_by(name: role)
end

Admin = User.create(email: 'bytheair@gmail.com',
            password: '123456',
            password_confirmation: '123456')

Admin_role = Role.find_by(name: 'Admin')

Admin.roles << Admin_role
