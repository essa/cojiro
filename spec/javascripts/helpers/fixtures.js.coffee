beforeEach ->

  @fixtures =

    Thread:
      valid:
        "created_at":"2010-07-20T12:20:00Z"
        "updated_at":"2010-09-10T10:20:00Z"
        "id":5
        "source_locale":"en"
        "title":"Co-working spaces in Tokyo"
        "title_in_source_locale":"Co-working spaces in Tokyo"
        "summary":"I'm collecting blog posts on co-working spaces in Tokyo."
        "summary_in_source_locale":"I'm collecting blog posts on co-working spaces in Tokyo."
        "user":
          "name":"csasaki"
          "fullname":"Cojiro Sasaki"
      valid_in_ja:
        "created_at":"2010-07-20T12:20:00Z"
        "updated_at":"2010-09-10T10:20:00Z"
        "id":5
        "source_locale":"ja"
        "title_in_source_locale":"東京のコワーキングスペース"
        "summary_in_source_locale":"東京のコワーキングスペースについてブログを書こうかと思います。"
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
          title: "Co-working spaces in Tokyo"
          summary: "I'm collecting blog posts on co-working spaces in Tokyo."
          user:
            name: "csasaki"
            fullname: "Cojiro Sasaki"
        },
        {
          id: 2
          created_at: "2012-07-08T12:20:00Z"
          updated_at: "2012-11-01T10:20:00Z"
          source_locale: "en"
          title: "Geisha bloggers"
          summary: "Anyone know any geisha bloggers?"
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
