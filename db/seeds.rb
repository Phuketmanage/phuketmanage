Role.create!(
  [
    { name: "Admin" },
    { name: "Manager" },
    { name: "Owner" },
    { name: "Client" }
  ]
)

# Jobs
JobType.create!(
  [
    { name: "For management", code: "M", color: "red", for_house_only: false },
    { name: "Cleaning", code: "C", color: "#391FDE", for_house_only: false },
    {
      name: "Cleaning and linen",
      code: "X",
      color: "#1FDE99",
      for_house_only: false
    }
  ]
)

# Fake data for development and test
return if Rails.env.production?

Role
  .find_by(name: "Admin")
  .users
  .create!(
    email: "admin@test.com",
    password: "qweasd",
    password_confirmation: "qweasd",
    reset_password_token: nil,
    reset_password_sent_at: nil,
    remember_created_at: nil,
    invitation_token: nil,
    invitation_created_at: nil,
    invitation_sent_at: nil,
    invitation_accepted_at: nil,
    invitation_limit: nil,
    invited_by_type: nil,
    invited_by_id: nil,
    invitations_count: 0,
    name: "Admin",
    surname: "Test",
    locale: "en",
    comment: "",
    code: "",
    tax_no: "",
    show_comm: false
  )
Role
  .find_by(name: "Manager")
  .users
  .create!(
    email: "manager@test.com",
    password: "qweasd",
    password_confirmation: "qweasd",
    reset_password_token: nil,
    reset_password_sent_at: nil,
    remember_created_at: nil,
    invitation_token: nil,
    invitation_created_at: nil,
    invitation_sent_at: nil,
    invitation_accepted_at: nil,
    invitation_limit: nil,
    invited_by_type: nil,
    invited_by_id: nil,
    invitations_count: 0,
    name: "Manager",
    surname: "Test",
    locale: "en",
    comment: "",
    code: "",
    tax_no: "",
    show_comm: false
  )
Role
  .find_by(name: "Owner")
  .users
  .create!(
    [
      {
        email: "owner1@test.com",
        password: "qweasd",
        password_confirmation: "qweasd",
        reset_password_token: nil,
        reset_password_sent_at: nil,
        remember_created_at: nil,
        invitation_token: nil,
        invitation_created_at: nil,
        invitation_sent_at: nil,
        invitation_accepted_at: nil,
        invitation_limit: nil,
        invited_by_type: nil,
        invited_by_id: nil,
        invitations_count: 0,
        name: "Owner1",
        surname: "Test",
        locale: "en",
        comment: nil,
        code: "OW1",
        tax_no: nil,
        show_comm: false
      },
      {
        email: "owner2@test.com",
        password: "qweasd",
        password_confirmation: "qweasd",
        reset_password_token: nil,
        reset_password_sent_at: nil,
        remember_created_at: nil,
        invitation_token: nil,
        invitation_created_at: nil,
        invitation_sent_at: nil,
        invitation_accepted_at: nil,
        invitation_limit: nil,
        invited_by_type: nil,
        invited_by_id: nil,
        invitations_count: 0,
        name: "Owner2",
        surname: "Test",
        locale: "ru",
        comment: "",
        code: "OW2",
        tax_no: "",
        show_comm: true
      }
    ]
  )
Role
  .find_by(name: "Client")
  .users
  .create!(
    email: "client@test.com",
    password: "qweasd",
    password_confirmation: "qweasd",
    reset_password_token: nil,
    reset_password_sent_at: nil,
    remember_created_at: nil,
    invitation_token: nil,
    invitation_created_at: nil,
    invitation_sent_at: nil,
    invitation_accepted_at: nil,
    invitation_limit: nil,
    invited_by_type: nil,
    invited_by_id: nil,
    invitations_count: 0,
    name: "Manager",
    surname: "Test",
    locale: "en",
    comment: "",
    code: "",
    tax_no: "",
    show_comm: false
  )

Setting.create!(
  [
    { var: "dtnb", value: "1", description: "How many days till next booking" },
    {
      var: "tranfer_supplier_email",
      value: "bytheair@gmail.com",
      description: "tranfer supplier email"
    },
    { var: "usd_rate", value: "33", description: "usd rate" }
  ]
)

# Locations in Phuket
Location.create!(
  name_en: "Kamala",
  name_ru: "Камала",
  descr_en: "Test description of the Kamala location",
  descr_ru: "Тестовое описание локации Камала"
)
Location.create!(
  name_en: "Surin",
  name_ru: "Сурин",
  descr_en: "Test description of the Surin location",
  descr_ru: "Тестовое описание локации Сурин"
)
Location.create!(
  name_en: "Bangtao",
  name_ru: "Бангтао",
  descr_en: "Test description of the Bangtao location",
  descr_ru: "Тестовое описание локации Бангтао"
)

# Options example
Option.create!(zindex: "0", title_en: "Internet", title_ru: "Интернет")
Option.create!(zindex: "1", title_en: "Laundry", title_ru: "Прачечная")

HouseGroup.create!([{ name: "North" }, { name: "South" }])
HouseType.create!(
  [
    { name_en: "Villa", name_ru: "Вилла", comm: 20 },
    { name_en: "Townhouse", name_ru: "Таунхаус", comm: 20 },
    { name_en: "Apartment", name_ru: "Апартаменты", comm: 30 }
  ]
)

owner1 = User.find_by(name:"Owner1")
owner2 = User.find_by(name:"Owner2")
owner1.houses.create!(
  [
    {
      title_en: "House1",
      title_ru: "Дом1",
      description_en:
        "Villa is located at one of the newest projects of 2016 Laguna Park, part of the posh resort Laguna Phuket. Laguna has been named the most successful hotel project on Phuket for several years in the row. It is renowned all around the world.",
      description_ru:
        "Villa  находится в одном из новых проектов 2016 года “Laguna Park”, входящий в состав фешенебельного курорта «Laguna Phuket». Вот уже на протяжении нескольких лет «Лагуна» признается самым успешным отельным проектом на Пхукете и является авторитетом для тысяч туристов со всего мира. ",
      # owner_id: owner1.id,
      type_id: 1,
      code: "HS1",
      size: nil,
      plot_size: nil,
      rooms: 3,
      bathrooms: 3,
      pool: true,
      pool_size: "",
      communal_pool: false,
      parking: false,
      parking_size: nil,
      unavailable: false,
      number: "631",
      secret: "c8e80db49eaaab62e6a514fb58e176e8",
      rental: true,
      maintenance: true,
      outsource_cleaning: false,
      outsource_linen: false,
      address: "Address1",
      google_map: "",
      image: nil,
      capacity: 8,
      seaview: false,
      kingBed: 3,
      queenBed: 1,
      singleBed: nil,
      priceInclude_en:
        "Included: internet, cleaning 1 times a week and linen change 1 time a week, water, electricity (limit 60 kWh/day, extra 7 B/Unit).",
      priceInclude_ru:
        "Включено: интернет, уборка 1 раза в неделю и смена белья 1 раз в неделю, вода, электричество (лимит 60 кВт/день, свыше 7 бат/кВт).",
      cancellationPolicy_en: "",
      cancellationPolicy_ru: "",
      rules_en: "- Take off your shoes before entering the apartment;",
      rules_ru: "- Снимайте обувь перед входом в помещение;",
      other_ru:
        "По закону Таиланда все приезжие должны регистрироваться в иммиграционной службе. Мы можем помочь сделать регистрацию, дайте знать если вам это необходимо. ",
      other_en:
        "According to Thai law all guests need to register in Immigration office after arrival. We can assist you with registration, please let us know if you need help.",
      details: "",
      house_group_id: 1,
      water_meters: 1,
      water_reading: false,
      balance_closed: true,
      hide_in_timeline: false
    },
    {
      title_en: "House3",
      title_ru: "Дом3",
      description_en:
        "Villa located on the hill of Kamala Beach. Luxury villa near all facilities that you need, Private pool with a beautiful garden in the house for you to relax with privacy, 3 bedrooms and huge living room with kichen near private pool. Kamala Beach is just 10 minute drive from the villa.",
      description_ru:
        "Вилла, расположенная на холме пляжа Камала. Роскошная вилла рядом со всеми необходимыми удобствами. Частный бассейн с красивым садом в доме для отдыха в уединении, 3 спальни и огромная гостиная с кухней рядом с частным бассейном. Пляж Камала находится всего в 10 минутах езды от виллы.",
      # owner_id: owner1.id,
      type_id: 1,
      code: "HS3",
      size: nil,
      plot_size: nil,
      rooms: 1,
      bathrooms: 1,
      pool: true,
      pool_size: "",
      communal_pool: true,
      parking: true,
      parking_size: nil,
      unavailable: false,
      number: "92",
      secret: "d633d3a89e2869b94115bb390fdf7772",
      rental: true,
      maintenance: true,
      outsource_cleaning: false,
      outsource_linen: false,
      address: "Address3",
      google_map: "",
      image: nil,
      capacity: 4,
      seaview: true,
      kingBed: 1,
      queenBed: 1,
      singleBed: nil,
      priceInclude_en:
        "Included: internet, cleaning 1 times a week and linen change 1 time a week, water, electricity (limit 60 kWh/day, extra 7 B/Unit).",
      priceInclude_ru:
        "Включено: интернет, уборка 1 раза в неделю и смена белья 1 раз в неделю, вода, электричество (лимит 60 кВт/день, свыше 7 бат/кВт).",
      cancellationPolicy_en: "",
      cancellationPolicy_ru: "",
      rules_en: "- Take off your shoes before entering the apartment;",
      rules_ru: "- Снимайте обувь перед входом в помещение;",
      other_ru:
        "По закону Таиланда все приезжие должны регистрироваться в иммиграционной службе. Мы можем помочь сделать регистрацию, дайте знать если вам это необходимо. ",
      other_en:
        "According to Thai law all guests need to register in Immigration office after arrival. We can assist you with registration, please let us know if you need help.",
      details: "qwe",
      house_group_id: 1,
      water_meters: 1,
      water_reading: true,
      balance_closed: false,
      hide_in_timeline: false
    },
    {
      title_en: "House4",
      title_ru: "Дом4",
      description_en:
        "Villa is an ideal place for a private perfectly relaxing holiday. The villa is furnished with an interesting design, handwoven rugs, solid teak wood furniture and all imaginary amenities.",
      description_ru:
        "Идеальное место для совершенно спокойного приватного отдыха. Вилла оформлена интересными дизайнерскими решениями, коврами ручной работы, обставлена мебелью из массива тикового дерева, и всеми мыслимыми дополнительными удобствами. В доме 3 спальни и каждая из них  оборудованна отдельным сейфом,  смарт ТВ, кондиционером, потолочным феном и отдельным санузлом",
      # owner_id: owner1.id,
      type_id: 1,
      code: "HS4",
      size: nil,
      plot_size: nil,
      rooms: 3,
      bathrooms: 4,
      pool: false,
      pool_size: "",
      communal_pool: false,
      parking: false,
      parking_size: nil,
      unavailable: false,
      number: "541",
      secret: "421833bc2e82a5901dae3adf50c4b293",
      rental: true,
      maintenance: true,
      outsource_cleaning: false,
      outsource_linen: false,
      address: "Address4",
      google_map: "",
      image: nil,
      capacity: 10,
      seaview: false,
      kingBed: 3,
      queenBed: nil,
      singleBed: 2,
      priceInclude_en:
        "Included: internet, cleaning 2 times a week and linen change 1 time a week, water, electricity (limit 75 kWh/day, extra 7 B/Unit).",
      priceInclude_ru:
        "Включено: интернет, уборка 2 раза в неделю и смена белья 1 раз в неделю, вода, электричество (лимит 75 кВт/день, свыше 7 бат/кВт).",
      cancellationPolicy_en: "",
      cancellationPolicy_ru: "",
      rules_en: "- Take off your shoes before entering the apartment;",
      rules_ru: "- Снимайте обувь перед входом в помещение;",
      other_ru:
        "По закону Таиланда все приезжие должны регистрироваться в иммиграционной службе. Мы можем помочь сделать регистрацию, дайте знать если вам это необходимо. ",
      other_en:
        "According to Thai law all guests need to register in Immigration office after arrival. We can assist you with registration, please let us know if you need help.",
      details: "",
      house_group_id: 2,
      water_meters: 1,
      water_reading: true,
      balance_closed: false,
      hide_in_timeline: false
    }
  ]
)
house1 = owner1.houses.find_by(code: 'HS1')
house3 = owner1.houses.find_by(code: 'HS3')
house4 = owner1.houses.find_by(code: 'HS4')

owner2.houses.create!(
  title_en: "House2",
  title_ru: "Дом2",
  description_en:
    "Secure housing development, pool, roof terrace, 3 bedrooms / 3 bathrooms, not far from Bangtao Beach. There is a restaurant in development where you can have breakfast of eat during the day. Easy to go anywhere around with rented car - beautiful beaches, attractions, shopping, restaurants etc.",
  description_ru:
    "Вилла в очень необычном аутентичном стиле с высокими потолками. Абсолютно закрытая от посторонних глаз зеленая территория, личный бассейн и терраса на крыше, где по утрам можно пить кофе. В доме  3 спальни с отдельными санузлами, 2 из низ с выходят прямо на бассейн, а третий на 2 этаже. В доме полностью оборудованная кухня, но если вы не хотите готовить сами, то на территории комплекса есть очень милый ресторанчик, где можно позавтракать или перекусить в течении дня. Есть бесплатная парковка.",
  # owner_id: owner2.id,
  type_id: 1,
  code: "HS2",
  size: nil,
  plot_size: nil,
  rooms: 2,
  bathrooms: 2,
  pool: false,
  pool_size: "",
  communal_pool: false,
  parking: true,
  parking_size: nil,
  unavailable: false,
  number: "47",
  secret: "ab0d9d820b873e6e7090f210e729d5ac",
  rental: true,
  maintenance: true,
  outsource_cleaning: false,
  outsource_linen: false,
  address: "Address2",
  google_map: "",
  image: nil,
  capacity: 6,
  seaview: false,
  kingBed: 3,
  queenBed: nil,
  singleBed: nil,
  priceInclude_en:
    "Included: internet, cleaning 2 times a week and linen change 1 time a week, water, electricity (limit 75 kWh/day, extra 7 B/Unit).",
  priceInclude_ru:
    "Включено: интернет, уборка 2 раза в неделю и смена белья 1 раз в неделю, вода, электричество (лимит 75 кВт/день, свыше 7 бат/кВт).",
  cancellationPolicy_en: "",
  cancellationPolicy_ru: "",
  rules_en: "- Take off your shoes before entering the apartment;",
  rules_ru: "- Снимайте обувь перед входом в помещение;",
  other_ru:
    "По закону Таиланда все приезжие должны регистрироваться в иммиграционной службе. Мы можем помочь сделать регистрацию, дайте знать если вам это необходимо. ",
  other_en:
    "According to Thai law all guests need to register in Immigration office after arrival. We can assist you with registration, please let us know if you need help.",
  details: "",
  house_group_id: 1,
  water_meters: 1,
  water_reading: true,
  balance_closed: false,
  hide_in_timeline: true
)
house2 = owner2.houses.find_by(code: 'HS2')

Duration.create!(
  [
    { start: 7, finish: 13, house_id: 1 }, #1
    { start: 14, finish: 27, house_id: 1 }, #2
    { start: 28, finish: 180, house_id: 1 }, #3
    { start: 7, finish: 13, house_id: 2 }, #4
    { start: 14, finish: 27, house_id: 2 }, #5
    { start: 28, finish: 180, house_id: 2 }, #6
    { start: 7, finish: 13, house_id: 3 }, #7
    { start: 14, finish: 27, house_id: 3 }, #8
    { start: 28, finish: 180, house_id: 3 }, #9
    { start: 7, finish: 13, house_id: 4 }, #10
    { start: 14, finish: 27, house_id: 4 }, #11
    { start: 28, finish: 180, house_id: 4 } #12
  ]
)
Season.create!(
  [
    { ssd: 15, ssm: 4, sfd: 1, sfm: 11, house_id: 1 }, #1
    { ssd: 1, ssm: 11, sfd: 1, sfm: 12, house_id: 1 }, #2
    { ssd: 1, ssm: 12, sfd: 15, sfm: 12, house_id: 1 }, #3
    { ssd: 15, ssm: 12, sfd: 15, sfm: 1, house_id: 1 }, #4
    { ssd: 15, ssm: 1, sfd: 1, sfm: 3, house_id: 1 }, #5
    { ssd: 1, ssm: 3, sfd: 15, sfm: 4, house_id: 1 }, #6
    { ssd: 15, ssm: 4, sfd: 1, sfm: 11, house_id: 2 }, #7
    { ssd: 1, ssm: 11, sfd: 1, sfm: 12, house_id: 2 }, #8
    { ssd: 1, ssm: 12, sfd: 15, sfm: 12, house_id: 2 }, #9
    { ssd: 15, ssm: 12, sfd: 15, sfm: 1, house_id: 2 }, #10
    { ssd: 15, ssm: 1, sfd: 1, sfm: 3, house_id: 2 }, #11
    { ssd: 1, ssm: 3, sfd: 15, sfm: 4, house_id: 2 }, #12
    { ssd: 15, ssm: 4, sfd: 1, sfm: 11, house_id: 3 }, #13
    { ssd: 1, ssm: 11, sfd: 1, sfm: 12, house_id: 3 }, #14
    { ssd: 1, ssm: 12, sfd: 15, sfm: 12, house_id: 3 }, #15
    { ssd: 15, ssm: 12, sfd: 15, sfm: 1, house_id: 3 }, #16
    { ssd: 15, ssm: 1, sfd: 1, sfm: 3, house_id: 3 }, #17
    { ssd: 1, ssm: 3, sfd: 15, sfm: 4, house_id: 3 }, #18
    { ssd: 15, ssm: 4, sfd: 1, sfm: 11, house_id: 4 }, #19
    { ssd: 1, ssm: 11, sfd: 1, sfm: 12, house_id: 4 }, #20
    { ssd: 1, ssm: 12, sfd: 15, sfm: 12, house_id: 4 }, #21
    { ssd: 15, ssm: 12, sfd: 15, sfm: 1, house_id: 4 }, #22
    { ssd: 15, ssm: 1, sfd: 1, sfm: 3, house_id: 4 }, #23
    { ssd: 1, ssm: 3, sfd: 15, sfm: 4, house_id: 4 } #24
  ]
)
z = 0
House.all.each do |h|
  i = 0
  x = 0
  h.seasons.all.each do |s|
    price = 5000 + x + z
    y = 1
    h.durations.all.each do |d|
      h.prices.create!(season_id: s.id, duration_id: d.id, amount: price * y)
      y -= 0.15
    end
    i += 1
    i <= 3 ? x += 1000 : x -= 1000
  end
  z += 1000
end
Source.create!([{ name: "Airbnb", syncable: false }])
Booking.create!(
  [
    {
      start: "2022-05-15",
      finish: "2022-06-05",
      house_id: house2.id,
      tenant_id: nil,
      status: "confirmed",
      number: "LJ9KPDO",
      ical_UID: "d1373597b758e353547b8c9ef94769ce@phuketmanage.com",
      source_id: nil,
      comment: "",
      sale: 21_000,
      agent: 0,
      comm: 4200,
      nett: 16_800,
      synced: false,
      allotment: false,
      transfer_in: false,
      transfer_out: false,
      client_details: "Test",
      comment_gr: "",
      no_check_in: false,
      no_check_out: false,
      check_in: nil,
      check_out: nil,
      comment_owner: "",
      ignore_warnings: false
    },
    {
      start: "2022-06-22",
      finish: "2022-07-02",
      house_id: house2.id,
      tenant_id: nil,
      status: "confirmed",
      number: "ZOVAYDS",
      ical_UID: "d51180c36dce3f15062de31de7483a42@phuketmanage.com",
      source_id: nil,
      comment: "",
      sale: 10_000,
      agent: 0,
      comm: 2000,
      nett: 8000,
      synced: false,
      allotment: false,
      transfer_in: false,
      transfer_out: false,
      client_details: "Test2",
      comment_gr: "",
      no_check_in: false,
      no_check_out: false,
      check_in: nil,
      check_out: nil,
      comment_owner: "",
      ignore_warnings: false
    },
    {
      start: "2022-08-01",
      finish: "2022-08-31",
      house_id: house1.id,
      tenant_id: nil,
      status: "pending",
      number: "CJP5ISM",
      ical_UID: "a56b28c86d0eacc20827a545c283bf3f@phuketmanage.com",
      source_id: nil,
      comment: "",
      sale: 27_000,
      agent: 0,
      comm: 5400,
      nett: 21_600,
      synced: false,
      allotment: false,
      transfer_in: false,
      transfer_out: false,
      client_details: "Test",
      comment_gr: "",
      no_check_in: false,
      no_check_out: false,
      check_in: nil,
      check_out: nil,
      comment_owner: "",
      ignore_warnings: false
    },
    {
      start: "2022-07-05",
      finish: "2022-07-28",
      house_id: house2.id,
      tenant_id: nil,
      status: "temporary",
      number: "AUKPLYJ",
      ical_UID: "c75c5a58a70588707b21f1afe7cadf58@phuketmanage.com",
      source_id: 1,
      comment: "",
      sale: 23_000,
      agent: 0,
      comm: 4600,
      nett: 18_400,
      synced: false,
      allotment: false,
      transfer_in: false,
      transfer_out: false,
      client_details: "Test",
      comment_gr: "",
      no_check_in: false,
      no_check_out: false,
      check_in: nil,
      check_out: nil,
      comment_owner: "",
      ignore_warnings: false
    },
    {
      start: "2022-12-14",
      finish: "2022-12-21",
      house_id: house2.id,
      tenant_id: nil,
      status: "confirmed",
      number: "GEJXUMD",
      ical_UID: "e8bec28f65333c89e3443a99ea66f9a9@phuketmanage.com",
      source_id: nil,
      comment: "",
      sale: 0,
      agent: 0,
      comm: 0,
      nett: 0,
      synced: false,
      allotment: false,
      transfer_in: false,
      transfer_out: false,
      client_details: "Ivanov",
      comment_gr: "12334",
      no_check_in: false,
      no_check_out: false,
      check_in: nil,
      check_out: nil,
      comment_owner: "",
      ignore_warnings: false
    }
  ]
)
TransactionType.create!(
  [
    {
      name_en: "Improvements",
      name_ru: "Улучшения",
      debit_company: true,
      credit_company: true,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Rental",
      name_ru: "Аренда",
      debit_company: true,
      credit_company: false,
      debit_owner: true,
      credit_owner: false,
      admin_only: false
    },
    {
      name_en: "Maintenance",
      name_ru: "Обслуживание",
      debit_company: true,
      credit_company: false,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Top up",
      name_ru: "Пополнение баланса",
      debit_company: false,
      credit_company: false,
      debit_owner: true,
      credit_owner: false,
      admin_only: false
    },
    {
      name_en: "Repair",
      name_ru: "Ремонт",
      debit_company: true,
      credit_company: true,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Laundry",
      name_ru: "Стирка",
      debit_company: true,
      credit_company: false,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Utilities",
      name_ru: "Ком платежи",
      debit_company: false,
      credit_company: true,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Insurance",
      name_ru: "Страховка",
      debit_company: false,
      credit_company: false,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Purchases",
      name_ru: "Покупки",
      debit_company: true,
      credit_company: true,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Salary",
      name_ru: "Зарплата",
      debit_company: false,
      credit_company: true,
      debit_owner: false,
      credit_owner: false,
      admin_only: true
    },
    {
      name_en: "Office",
      name_ru: "Офис",
      debit_company: false,
      credit_company: true,
      debit_owner: false,
      credit_owner: false,
      admin_only: false
    },
    {
      name_en: "Suppliers",
      name_ru: "Подрядчики",
      debit_company: false,
      credit_company: true,
      debit_owner: false,
      credit_owner: false,
      admin_only: false
    },
    {
      name_en: "From guests",
      name_ru: "Платежи с гостей",
      debit_company: false,
      credit_company: false,
      debit_owner: true,
      credit_owner: false,
      admin_only: false
    },
    {
      name_en: "To owner",
      name_ru: "Владельцу",
      debit_company: false,
      credit_company: false,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Common area",
      name_ru: "Общая территория",
      debit_company: false,
      credit_company: false,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Eqp & Cons",
      name_ru: "Оборудование и расходники",
      debit_company: false,
      credit_company: true,
      debit_owner: false,
      credit_owner: false,
      admin_only: false
    },
    {
      name_en: "Transfer",
      name_ru: "Перевод",
      debit_company: false,
      credit_company: false,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Gasoline",
      name_ru: "Бензин",
      debit_company: false,
      credit_company: true,
      debit_owner: false,
      credit_owner: false,
      admin_only: false
    },
    {
      name_en: "Consumables",
      name_ru: "Расходники",
      debit_company: true,
      credit_company: true,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Yearly contracts",
      name_ru: "Годовые контракты",
      debit_company: false,
      credit_company: false,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Materials",
      name_ru: "Материалы",
      debit_company: false,
      credit_company: true,
      debit_owner: false,
      credit_owner: false,
      admin_only: false
    },
    {
      name_en: "Eqp maintenance",
      name_ru: "Обслуживание техники",
      debit_company: false,
      credit_company: true,
      debit_owner: false,
      credit_owner: false,
      admin_only: false
    },
    {
      name_en: "Taxes & Accounting",
      name_ru: "Налоги и бухгалтерия",
      debit_company: false,
      credit_company: true,
      debit_owner: false,
      credit_owner: false,
      admin_only: false
    },
    {
      name_en: "Taxes & Accounting",
      name_ru: "Налоги и бухгалтерия",
      debit_company: true,
      credit_company: true,
      debit_owner: true,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Pest control",
      name_ru: "Обработка от вредеилей",
      debit_company: false,
      credit_company: true,
      debit_owner: false,
      credit_owner: true,
      admin_only: false
    },
    {
      name_en: "Other",
      name_ru: "Other",
      debit_company: true,
      credit_company: true,
      debit_owner: true,
      credit_owner: true,
      admin_only: false
    }
  ]
)

#Transactions
#1
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house2.id,
      type_id: 1,
      user_id: house2.owner.id,
      comment_en: "New wall",
      comment_ru: "Новая стена",
      comment_inner: "",
      date: "2022-05-17",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "1000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "200.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "200.0", credit: "0.0", ref_no: nil }]
)
#2
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house2.id,
      type_id: 3,
      user_id: house2.owner.id,
      comment_en: "Maintenance copy",
      comment_ru: "Обслуживание copy",
      comment_inner: "",
      date: "2022-05-18",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "10000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "10000.0", credit: nil, ref_no: nil }]
)
#3
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house2.id,
      type_id: 1,
      user_id: house2.owner.id,
      comment_en: "New wall copy",
      comment_ru: "Новая стена copy",
      comment_inner: "",
      date: "2022-05-18",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "1000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "200.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "200.0", credit: "0.0", ref_no: nil }]
)
#4
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: nil,
      type_id: 3,
      user_id: owner1.id,
      comment_en: "Maintenance ",
      comment_ru: "Обслуживание ",
      comment_inner: "",
      date: "2022-04-28",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "10000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "10000.0", credit: nil, ref_no: nil }]
)
#5
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house2.id,
      type_id: 2,
      user_id: house2.owner.id,
      comment_en: "Rental 15.5.2022 - 5.6.2022",
      comment_ru: "Аренда 15.5.2022 - 5.6.2022",
      comment_inner: "",
      date: "2022-04-28",
      booking_id: 3,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "100000.0",
      credit: "0.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "20000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "20000.0", credit: "0.0", ref_no: nil }]
)
#6
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house2.id,
      type_id: 2,
      user_id: house2.owner.id,
      comment_en: "Rental 15.5.2022 - 5.6.2022",
      comment_ru: "Аренда 15.5.2022 - 5.6.2022",
      comment_inner: "",
      date: "2022-04-26",
      booking_id: 3,
      hidden: true,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "10000.0",
      credit: "0.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "2000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "2000.0", credit: "0.0", ref_no: nil }]
)
#7
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house1.id,
      type_id: 3,
      user_id: house1.owner.id,
      comment_en: "Maintenance ",
      comment_ru: "Обслуживание ",
      comment_inner: "",
      date: "2022-05-16",
      booking_id: nil,
      hidden: true,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "10000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "10000.0", credit: nil, ref_no: nil }]
)
#8
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house2.id,
      type_id: 2,
      user_id: house2.owner.id,
      comment_en: "Rental 15.5.2022 - 5.6.2022",
      comment_ru: "Аренда 15.5.2022 - 5.6.2022",
      comment_inner: "",
      date: "2022-05-10",
      booking_id: 3,
      hidden: false,
      for_acc: true,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "20000.0",
      credit: "0.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "4000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "4000.0", credit: "0.0", ref_no: nil }]
)
#9
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house2.id,
      type_id: 1,
      user_id: house2.owner.id,
      comment_en: "New search",
      comment_ru: "Новый поиск",
      comment_inner: "",
      date: "2022-05-25",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "1000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "150.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "150.0", credit: "0.0", ref_no: nil }]
)
#10
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: nil,
      type_id: 3,
      user_id: owner1.id,
      comment_en: "Maintenance ",
      comment_ru: "Обслуживание ",
      comment_inner: "",
      date: "2022-05-25",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "1000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "150.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "150.0", credit: "0.0", ref_no: nil }]
)
#11
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house1.id,
      type_id: 1,
      user_id: owner1.id,
      comment_en: "Test",
      comment_ru: "Test",
      comment_inner: "",
      date: "2022-05-25",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "5000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
#12
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: nil,
      type_id: 3,
      user_id: owner1.id,
      comment_en: "Maintenance ",
      comment_ru: "Обслуживание ",
      comment_inner: "",
      date: "2022-05-25",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "10000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "10000.0", credit: nil, ref_no: nil }]
)
#13
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house1.id,
      type_id: 1,
      user_id: owner1.id,
      comment_en: "Fix toilet",
      comment_ru: "Ремонт туалета",
      comment_inner: "",
      date: "2022-07-20",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "2000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "400.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "400.0", credit: "0.0", ref_no: nil }]
)
#14
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house2.id,
      type_id: 1,
      user_id: house2.owner.id,
      comment_en: "Remove wall",
      comment_ru: "Удаление стены",
      comment_inner: "",
      date: "2022-08-08",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "1000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "200.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "200.0", credit: "0.0", ref_no: nil }]
)
#15
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house1.id,
      type_id: 1,
      user_id: owner1.id,
      comment_en: "Fix door",
      comment_ru: "Ремонт двери",
      comment_inner: "",
      date: "2022-10-10",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "2000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "400.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "400.0", credit: "0.0", ref_no: nil }]
)
#16
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house1.id,
      type_id: 4,
      user_id: owner1.id,
      comment_en: "Balance top up",
      comment_ru: "Пополнение баланса",
      comment_inner: "",
      date: "2022-10-10",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "100000.0",
      credit: "0.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
#17
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house4.id,
      type_id: 1,
      user_id: house4.owner.id,
      comment_en: "Maintenance ",
      comment_ru: "Обслуживание ",
      comment_inner: "",
      date: "2022-12-13",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "1000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "100.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "100.0", credit: "0.0", ref_no: nil }]
)
#18
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house1.id,
      type_id: 1,
      user_id: owner1.id,
      comment_en: "Change light",
      comment_ru: "Change light",
      comment_inner: "",
      date: "2022-11-28",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "30000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "4500.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "4500.0", credit: "0.0", ref_no: nil }]
)
#19
Transaction.create!(
  [
    {
      ref_no: "",
      house_id: house1.id,
      type_id: 1,
      user_id: owner1.id,
      comment_en: "Change light",
      comment_ru: "Change light",
      comment_inner: "",
      date: "2022-12-22",
      booking_id: nil,
      hidden: false,
      for_acc: false,
      incomplite: false,
      cash: false,
      transfer: false
    }
  ]
)
Transaction.last.balance_outs.create!(
  [
    {
      debit: "0.0",
      credit: "1000.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    },
    {
      debit: "0.0",
      credit: "200.0",
      ref_no_iv: nil,
      ref_no_re: nil,
      ref_no: nil
    }
  ]
)
Transaction.last.balances.create!(
  [{ debit: "200.0", credit: "0.0", ref_no: nil }]
)

Job.create!(
  [
    {
      job_type_id: 2,
      booking_id: nil,
      house_id: 2,
      time: "9:00",
      comment: nil,
      user_id: nil,
      plan: "2022-05-16",
      closed: nil,
      job: "",
      creator_id: 1,
      employee_id: nil,
      collected: nil,
      sent: nil,
      rooms: nil,
      price: nil,
      before: nil,
      status: "inbox",
      urgent: false,
      paid_by_tenant: false
    },
    {
      job_type_id: 2,
      booking_id: nil,
      house_id: 2,
      time: "9:00",
      comment: nil,
      user_id: nil,
      plan: "2022-05-19",
      closed: nil,
      job: "",
      creator_id: 1,
      employee_id: nil,
      collected: nil,
      sent: nil,
      rooms: nil,
      price: nil,
      before: nil,
      status: "inbox",
      urgent: false,
      paid_by_tenant: false
    },
    {
      job_type_id: 2,
      booking_id: nil,
      house_id: 2,
      time: "9:00",
      comment: nil,
      user_id: nil,
      plan: "2022-05-20",
      closed: nil,
      job: "",
      creator_id: 1,
      employee_id: nil,
      collected: nil,
      sent: nil,
      rooms: nil,
      price: nil,
      before: nil,
      status: "inbox",
      urgent: false,
      paid_by_tenant: true
    },
    {
      job_type_id: 2,
      booking_id: nil,
      house_id: 1,
      time: "10:00",
      comment: nil,
      user_id: nil,
      plan: "2022-05-18",
      closed: nil,
      job: "",
      creator_id: 1,
      employee_id: nil,
      collected: nil,
      sent: nil,
      rooms: nil,
      price: nil,
      before: nil,
      status: "inbox",
      urgent: false,
      paid_by_tenant: true
    },
    {
      job_type_id: 2,
      booking_id: nil,
      house_id: 1,
      time: "12:00",
      comment: nil,
      user_id: nil,
      plan: "2022-05-17",
      closed: nil,
      job: "",
      creator_id: 1,
      employee_id: nil,
      collected: nil,
      sent: nil,
      rooms: nil,
      price: nil,
      before: nil,
      status: "inbox",
      urgent: false,
      paid_by_tenant: true
    },
    {
      job_type_id: 2,
      booking_id: 4,
      house_id: 2,
      time: "9:00",
      comment: nil,
      user_id: nil,
      plan: "2022-06-24",
      closed: nil,
      job: "",
      creator_id: 1,
      employee_id: nil,
      collected: nil,
      sent: nil,
      rooms: nil,
      price: nil,
      before: nil,
      status: "inbox",
      urgent: false,
      paid_by_tenant: false
    },
    {
      job_type_id: 2,
      booking_id: 4,
      house_id: 2,
      time: "09:00",
      comment: nil,
      user_id: nil,
      plan: "2022-06-25",
      closed: nil,
      job: "",
      creator_id: 1,
      employee_id: nil,
      collected: nil,
      sent: nil,
      rooms: nil,
      price: nil,
      before: nil,
      status: "inbox",
      urgent: false,
      paid_by_tenant: true
    }
  ]
)
JobMessage.create!(
  [
    {
      job_id: 1,
      sender_id: 1,
      message: "Job created",
      is_system: true,
      file: false
    },
    {
      job_id: 2,
      sender_id: 1,
      message: "Job created",
      is_system: true,
      file: false
    },
    {
      job_id: 3,
      sender_id: 1,
      message: "Job created",
      is_system: true,
      file: false
    },
    {
      job_id: 4,
      sender_id: 1,
      message: "Job created",
      is_system: true,
      file: false
    },
    {
      job_id: 5,
      sender_id: 1,
      message: "Job created",
      is_system: true,
      file: false
    },
    {
      job_id: 6,
      sender_id: 1,
      message: "Job created",
      is_system: true,
      file: false
    },
    {
      job_id: 7,
      sender_id: 1,
      message: "Job created",
      is_system: true,
      file: false
    }
  ]
)
WaterUsage.create!(
  [
    { house_id: 2, date: "2022-06-15", amount: 1, amount_2: nil, comment: nil },
    {
      house_id: 2,
      date: "2022-06-18",
      amount: 3,
      amount_2: nil,
      comment: "Close irrigation"
    }
  ]
)
Notification.create!(
  [
    {
      level: nil,
      text: "Water overusage: 50(03.08) - 3(18.06) = 47 in 46 days",
      house_id: 2
    }
  ]
)
