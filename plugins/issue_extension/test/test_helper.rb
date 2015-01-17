# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

# делаем симлинки на fuxtures из плагина, дабы они были видны в тестах
# WARNING: нельзя создавать fixture с уже существующими именами из Redmine, иначе они перезапишутся симлинками
FileUtils.ln_s Dir.glob(File.expand_path('../fixtures/*.yml', __FILE__)), ActiveSupport::TestCase.fixture_path, force: true

