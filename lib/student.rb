class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end 

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


  def save
    # In order to INSERT data into our songs table, we need to craft a SQL INSERT statment(lines 45 & 46).
    sql = <<-SQL
    INSERT INTO students (name, grade) 
    Values (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn] 
  end    

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end 
  
end
