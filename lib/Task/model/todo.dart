class Todo {
  var id;
  var title;
  var description;
  var date;
  var priority;

  Todo({this.title, this.priority, this.date, this.description});

  Todo.withId({this.id, this.title, this.priority, this.date, this.description});

  Map<String, dynamic> toMap() {
    //  var map = Map<String, dynamic>();
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map["title"] = title;
    map["description"] = description;
    map["priority"] = priority;
    map["date"] = date;
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Todo.fromObject(dynamic o) {
    this.id = o["id"];
    this.title = o["title"];
    this.description = o["description"];
    this.date = o["date"];
    this.priority = o["priority"];
  }
}
