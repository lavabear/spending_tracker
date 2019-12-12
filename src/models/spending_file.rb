class SpendingFile
  attr_reader :filename
  attr_reader :contents

  def initialize(filename, contents)
    @filename = filename
    @contents = contents
  end

  def analyze

  end
end