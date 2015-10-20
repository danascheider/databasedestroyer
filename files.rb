module DatabaseDestroyerPackage
  module Files
    MISC_FILES = %w(README.md config.ru databasedestroyer.gemspec files.rb version.rb)
    BIN_FILES = Dir.glob('./bin/*')
    LIB_FILES  = Dir.glob('./lib/**/*')
    CONFIG_FILES = Dir.glob('./config/**/*')
    TEST_FILES = [Dir.glob('./spec/**/*'), Dir.glob('./features/**/*')].flatten

    FILES = [MISC_FILES, BIN_FILES, LIB_FILES, CONFIG_FILES, TEST_FILES].flatten.sort
  end
end
