FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "testuser#{n}" }
    email { "#{username}@example.com.xx" }
    password "00secret"
    locale 'en-US'
    name { "#{username} Codeberg" }

    # Child of :user factory, since it's in the `factory :user` block
    factory :admin do
      admin true
    end

    factory :teacher do
      user_type User::TYPE_TEACHER
    end
  end

  factory :section do
    sequence(:name) { |n| "Section #{n}"}
    user
  end

  factory :game do
    sequence(:name) { |n| "game#{n}.com"}
  end

  factory :level do
    sequence(:name) { |n| "Level #{n}" }
    #level_url "http://espn.com"
    level_num 3
    game
  end

  factory :activity do
    level
    user
  end

  factory :concept do
    sequence(:name) { |n| "Algorithm #{n}" }
  end

  factory :video do
    sequence(:key) { |n| "concept_#{n}" }
    youtube_code 'Bogus text'
  end

  factory :prize do
    prize_provider
    sequence(:code) { |n| "prize_code_#{n}" }
  end

  factory :prize_provider do
  end
end
