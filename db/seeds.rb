require 'csv'


def load_csv(filename)
  CSV.read Rails.root.join('db', 'fixtures', filename)
end

load_csv('prefecture.csv').each do |row|
  Prefecture.find_or_create_by(name: row[0], name_kana: row[1], name_en: row[2])
end

if Industry.count.zero?
  csv = load_csv('industry.csv')
  parents = csv.map(&:first).uniq.map do |name|
    [name, Industry.create(name: name)]
  end.to_h

  csv.each do |row|
    parents[row[0]].children.create(name: row[1])
  end
end

if Occupation.count.zero?
  csv = load_csv('occupation.csv')
  parents = csv.map(&:first).uniq.map do |name|
    [name, Occupation.create(name: name)]
  end.to_h

  csv.each do |row|
    parents[row[0]].children.create(name: row[1])
  end
end

if Plan.count.zero?
  [
    {
      name: 'ライト',
      price: 1000,
      list_capacity: 50,
      status: :published
    },
    {
      name: 'スタンダード',
      price: 3000,
      list_capacity: 500,
      status: :published
    },
    {
      name: 'スペシャル',
      price: 5000,
      list_capacity: 1000,
      status: :published
    }
  ].each do |t|
    Plan.create(t)
  end


  if Rails.env.development?
    Notification.create(text: 'プランをアップグレードしよう!', url: 'http://localhost:3000/plans')

    [
      ['兎田ぺこら', '兎田建設'],
      ['湊アクア', 'あくきん建設'],
      ['桐生ココ', '桐生会'],
      ['不知火フレア', '不知火組'],
      ['大空スバル', '大空建設'],
      ['兵頭辰弥', 'BC'],
    ].each do |name, business_name|
      user = User.create(name: name, email: 'test@test.com')
      UserPlan.create(user: user, plan: Plan.first)
      user.business.name = business_name
      user.business.title = "#{business_name}で#{%w[働ける幸せ スーパービジネスマンになる 勝ち組になろう].sample}"
      user.business.detail = '続々と応募者が集まるエモい言葉 ブラックだけどね' * (10 * (rand(2) + 1))
      user.business.status = :published
      user.business.save
    end
    User.last.friends << User.first
    MessageRoom.create.users = [User.last, User.first]
    User.last.friends << User.second
    MessageRoom.create.users = [User.last, User.second]
    puts "TEST LOGIN URL"
    puts "http://localhost:3000/login?test=1&code=#{User.last.code}"
  end
end
