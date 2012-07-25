beforeEach ->

  @fixtures =

    Thread:
      valid:
        "created_at":"2010-07-20T12:20:00Z"
        "id":5
        "source_locale":"en"
        "title":"Co-working spaces in Tokyo"
        "summary":"I'm collecting blog posts on co-working spaces in Tokyo."
        "user":
          "name":"csasaki"
          "fullname":"Cojiro Sasaki"

    Threads:
      valid: [
        {
          id: 1
          created_at: "2012-06-08T12:20:00Z"
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
          source_locale: "en"
          title: "Geisha bloggers"
          summary: "Anyone know any geisha bloggers?"
          user:
            name: "csasaki"
            fullname: "Cojiro Sasaki"
        }
      ]
