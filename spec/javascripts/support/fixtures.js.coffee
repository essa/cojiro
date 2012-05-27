beforeEach ->

  @fixtures =

    Thread:
      valid:
        "created_at":"2012-04-20T00:52:29Z"
        "id":5
        "source_language":"en"
        "title":"Co-working spaces in Tokyo"
        "summary":"I'm collecting blog posts on co-working spaces in Tokyo."
        "user":
          "name":"csasaki"
          "fullname":"Cojiro Sasaki"

    Threads:
      valid: [
        {
          id: 1
          created_at: "2012-04-20T00:52:29Z"
          source_language: "en"
          title: "Co-working spaces in Tokyo"
          summary: "I'm collecting blog posts on co-working spaces in Tokyo."
          user:
            name: "csasaki"
            fullname: "Cojiro Sasaki"
        },
        {
          id: 2
          created_at: "2012-04-20T00:52:29Z"
          source_language: "en"
          title: "Geisha bloggers"
          summary: "Anyone know any geisha bloggers?"
          user:
            name: "csasaki"
            fullname: "Cojiro Sasaki"
        }
      ]
