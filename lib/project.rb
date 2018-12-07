class Project
attr_accessor :title, :id

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end

  def self.all
    return_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    return_projects.each() do |project|
      title = project.fetch("title")
      id = project.fetch("id").to_i()
      projects.push(Project.new({:title => title, :id => id}))
  end
    projects
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def ==(another_project)
    self.title().==(another_project.title()).&(self.id().==(another_project.id()))
  end

end
