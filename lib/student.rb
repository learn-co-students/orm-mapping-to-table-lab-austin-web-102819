class Student

  attr_reader :id
  attr_accessor :name, :grade

  def initialize(name, grade, id: nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    sql = 
    <<-SQL
    insert into students (name, grade) values (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create_table
    sql = 
    <<-SQL
    create table students (id integer primary key, name text, grade text)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = 
    <<-SQL
    drop table students
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(hash)
    new_student = Student.new(hash[:name], hash[:grade])
    new_student.save
    new_student
  end

end