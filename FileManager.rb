# Author::    Laendasill

# License::   MIT licence

# FileManager - module for folder and files operations app folder operations

module FileManager
  # FOLDER - array containig current files and folders for future use
  @@FOLDER = []

  # get_folders  function using Dir.glob * std function for populating FOLDER variable
  # first it clears FOLDER and then itertes over files in current folder.
  # if path is diffrent than default funcion will first use Dir.chdir to that directory

  def get_folders(path = ".")
    @@FOLDER.clear
    if File.absolute_path(path) == Dir.pwd
      populate_folders()
    elsif File.directory?(path)
      Dir.chdir path
      populate_folders()
    else
      return "Path is not a folder"
      raise IOError
    end

  end

  # display_folders function for displaying folders in FOLDER
  # using hash parameters for displaying folders, files, symbolic links ets.
  # hash params are all boolean
  # currently implemented:
  # * :folders - display only folders
  # * :files - display only files
  # * :fullpath - display absolute_path
  def display_folders(options = {} )

    @@FOLDER.each do |f|
      if options[:folders]

        next unless File.directory?(f)

      end
      if options[:files]
        next unless File.file?(f)
      end
      if options[:fullpath]
        puts File.absolute_path(f)
      else
        puts f
      end
    end
  end
private

  def populate_folders()
    Dir["*"].each do |f|
      @@FOLDER.push(f)
    end
  end
end
