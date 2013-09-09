beforeEach ->

  @fixtures =

    Thread:
      valid:
        "created_at":"2010-07-20T12:20:00Z"
        "updated_at":"2010-09-10T10:20:00Z"
        "source_locale":"en"
        "title":
          "en": "Co-working spaces in Tokyo"
        "summary":
          "en": "I'm collecting blog posts on co-working spaces in Tokyo."
        "user":
          "name":"csasaki"
          "fullname":"Cojiro Sasaki"
        'participants':
          [
              'name': 'alice'
              'fullname': 'Alice in Wonderland'
            ,
              'name': 'bob'
              'fullname': 'Bob the Builder'
          ]
      valid_in_ja:
        "created_at":"2010-07-20T12:20:00Z"
        "updated_at":"2010-09-10T10:20:00Z"
        "source_locale":"ja"
        "title":
          ja: "東京のコワーキングスペース"
        "summary":
          ja: "東京のコワーキングスペースについてブログを書こうかと思います。"
        "user":
          "name":"csasaki"
          "fullname":"Cojiro Sasaki"

    Threads:
      valid: [
        {
          id: 1
          created_at: "2012-06-08T12:20:00Z"
          updated_at: "2012-09-10T10:20:00Z"
          source_locale: "en"
          title:
            en: "Co-working spaces in Tokyo"
          summary:
            en: "I'm collecting blog posts on co-working spaces in Tokyo."
          user:
            name: "csasaki"
            fullname: "Cojiro Sasaki"
        },
        {
          id: 2
          created_at: "2012-07-08T12:20:00Z"
          updated_at: "2012-11-01T10:20:00Z"
          source_locale: "en"
          title:
            en: "Geisha bloggers"
          summary:
            en: "Anyone know any geisha bloggers?"
          user:
            name: "csasaki"
            fullname: "Cojiro Sasaki"
        }
      ]

    User:
      valid:
        name: "csasaki"
        fullname: "Cojiro Sasaki"
        location: "Tokyo"
        profile: "I like dicing blue chickens."
        avatar_url: "http://www.example.com/csasaki.png"
        avatar_mini_url: "http://www.example.com/csasaki_mini.png"

    Link:
      valid:
        "source_locale":"en"
        "url": "http://youtu.be/tzD9BkXGJ1M"
        "title":
          "en": "What is CrossFit?"
        "summary":
          "en": "CrossFit is an effective way to get fit. Anyone can do it."
        "user":
          "name":"csasaki"
          "fullname":"Cojiro Sasaki"
