Faker::Config.locale = "pt-BR"

AVATAR_IMAGES = Dir.glob(Rails.root.join("app/assets/images/user/*.jpg")).sort.freeze
USERS_COUNT = 10
POSTS_PER_USER = 10
DEFAULT_PASSWORD = "12345678"

INITIAL_USERS = [
  { email: "user@example.com", password: "123456", full_name: "Usuário Demo" },
  { email: "admin@example.com", password: "123456", full_name: "Usuário Demo 2" }
].freeze

ADMIN_ROLE = :admin
USER_ROLE = :user

def unique_cpf(used_cpfs)
  loop do
    cpf = Faker::IdNumber.brazilian_citizen_number(formatted: false)
    next if used_cpfs.include?(cpf)

    used_cpfs << cpf
    return cpf
  end
end

def create_user_with_profile!(email:, password:, used_cpfs:, avatar_index:, full_name: nil)
  user = User.create!(
    email: email,
    password: password,
    password_confirmation: password,
    confirmed_at: Time.current
  )

  state = Profile::BRAZILIAN_STATES.sample
  ddd = Faker::Number.between(from: 11, to: 99).to_s
  profile = user.create_profile!(
    full_name: full_name || Faker::Name.name,
    cpf: unique_cpf(used_cpfs),
    rg: Faker::Number.number(digits: 9).to_s,
    rg_issuer: "SSP/#{state}",
    birth_date: Faker::Date.birthday(min_age: 18, max_age: 70),
    gender: Profile.genders.keys.sample,
    marital_status: Profile.marital_statuses.keys.sample,
    phone: "#{ddd}#{Faker::Number.number(digits: 8)}",
    mobile_phone: "#{ddd}9#{Faker::Number.number(digits: 8)}",
    mother_name: "#{Faker::Name.female_first_name} #{Faker::Name.last_name}",
    nationality: "Brasileira",
    cep: Faker::Address.zip_code.gsub(/\D/, ""),
    street: Faker::Address.street_name,
    number: Faker::Address.building_number,
    complement: [ Faker::Address.secondary_address, nil ].sample,
    neighborhood: Faker::Address.community,
    city: Faker::Address.city,
    state: state
  )

  avatar_path = AVATAR_IMAGES[avatar_index % AVATAR_IMAGES.size]
  profile.avatar.attach(
    io: File.open(avatar_path),
    filename: File.basename(avatar_path),
    content_type: "image/jpeg"
  )

  POSTS_PER_USER.times do
    user.posts.create!(
      title: Faker::Lorem.sentence(word_count: 4),
      body: Faker::Lorem.paragraph(sentence_count: 3)
    )
  end

  user
end

used_cpfs = Set.new
avatar_index = 0

puts "Limpando dados existentes..."
Post.destroy_all
Profile.find_each { |profile| profile.avatar.purge if profile.avatar.attached? }
Profile.destroy_all
User.destroy_all
Role.destroy_all

puts "Criando usuários de acesso inicial..."

INITIAL_USERS.each do |initial_user|
  user = create_user_with_profile!(
    email: initial_user[:email],
    password: initial_user[:password],
    full_name: initial_user[:full_name],
    used_cpfs: used_cpfs,
    avatar_index: avatar_index
  )
  user.promote_to_admin!
  avatar_index += 1
  puts "Usuário criado: #{user.email} (#{user.profile.full_name}) [admin]"
end

puts "Criando #{USERS_COUNT} usuários com perfil completo (Faker)..."

USERS_COUNT.times do
  user = create_user_with_profile!(
    email: Faker::Internet.unique.email,
    password: DEFAULT_PASSWORD,
    used_cpfs: used_cpfs,
    avatar_index: avatar_index
  )
  avatar_index += 1
  puts "Usuário criado: #{user.email} (#{user.profile.full_name}) [user]"
end

puts ""
puts "Resumo:"
puts "  Usuários: #{User.count}"
puts "  Perfis: #{Profile.count}"
puts "  Avatares: #{ActiveStorage::Attachment.where(record_type: 'Profile', name: 'avatar').count}"
puts "  Posts: #{Post.count}"
puts "  Admins: #{User.with_role(ADMIN_ROLE).count}"
puts "  Usuários comuns: #{User.with_role(USER_ROLE).count}"
puts ""
puts "Como fazer login (dados do seed)"
puts "Após rodar rails db:seed, use uma das credenciais abaixo na tela de login do Devise:"
puts ""
INITIAL_USERS.each do |initial_user|
  puts "  Email: #{initial_user[:email]} | Senha: #{initial_user[:password]}"
end
puts ""
puts "API JWT (mesmas credenciais do seed)"
puts "  POST   /api/v1/login   — body: { user: { email, password } }"
puts "  GET    /api/v1/me      — header: Authorization: Bearer <token>"
puts "  DELETE /api/v1/logout  — header: Authorization: Bearer <token>"
puts ""
puts "Exemplo com curl:"
puts '  curl -X POST http://localhost:3000/api/v1/login -H "Content-Type: application/json" -d \'{"user":{"email":"user@example.com","password":"123456"}}\''
